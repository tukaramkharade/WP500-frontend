package com.tas.wp500.servlet;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;

import com.tas.wp500.utils.TCPClient;
@WebServlet("/downloadBackupFile")
public class DownloadBackupFile extends HttpServlet {
	final static Logger logger = Logger.getLogger(DownloadBackupFile.class);
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String zipFilePath = "/data/wp500_backups/backup.zip"; // Path to the existing ZIP file
//        String zipFilePath ="C:\\Users\\sanke\\Desktop\\Firmware-File\\backup.zip";
        File zipFile = new File(zipFilePath);

        if (!zipFile.exists() || !zipFile.isFile()) {
            throw new ServletException("ZIP file not found or is not a file");
        }

        ServletContext ctx = getServletContext();
        String mimeType = ctx.getMimeType(zipFilePath);
        response.setContentType(mimeType != null ? mimeType : "application/octet-stream");
        response.setContentLength((int) zipFile.length());
        response.setHeader("Content-Disposition", "attachment; filename=\"" + zipFile.getName() + "\"");

        try (FileInputStream fis = new FileInputStream(zipFile);
             ServletOutputStream os = response.getOutputStream()) {

            byte[] bufferData = new byte[1024];
            int read;
            while ((read = fis.read(bufferData)) != -1) {
                os.write(bufferData, 0, read);
            }
            os.flush();
        }
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		
		if (check_username != null) {

			String action = request.getParameter("action");

			if (action != null) {
				switch (action) {

				case "createBackupFile":			
					
					try {
						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();

						json.put("operation", "create_backup_file");
						json.put("user", check_username);
						json.put("token", check_token);
						
						String respStr = client.sendMessage(json.toString());
						logger.info("res " + new JSONObject(respStr).getString("msg"));
						String message = new JSONObject(respStr).getString("msg");
						String status = new JSONObject(respStr).getString("status");
						
						JSONObject jsonObject = new JSONObject();
						jsonObject.put("message", message);
						jsonObject.put("status", status);
						
						// Set the content type of the response to application/json
						response.setContentType("application/json");
						// Get the response PrintWriter
						PrintWriter out = response.getWriter();
						// Write the JSON object to the response
						out.print(jsonObject.toString());
						out.flush();

					} catch (Exception e) {
						e.printStackTrace();
						logger.error("Error in adding mqtt : " + e);
					}
					break;

				case "restoreBackupFile":					
					try {

						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();

						json.put("operation", "restore_backup_file");
						json.put("user", check_username);
						json.put("token", check_token);
						
						String respStr = client.sendMessage(json.toString());

						logger.info("res " + new JSONObject(respStr).getString("msg"));

						String message = new JSONObject(respStr).getString("msg");
						String status = new JSONObject(respStr).getString("status");
						
						JSONObject jsonObject = new JSONObject();
						
						jsonObject.put("message", message);
						jsonObject.put("status", status);
						// Set the content type of the response to
						// application/json
						response.setContentType("application/json");

						// Get the response PrintWriter
						PrintWriter out = response.getWriter();

						// Write the JSON object to the response
						out.print(jsonObject.toString());
						out.flush();

					} catch (Exception e) {
						e.printStackTrace();
						logger.error("Error in updating mqtt : " + e);
					}

					break;						
				}
			}
		} 
	}
}
