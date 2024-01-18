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
import org.json.JSONException;
import org.json.JSONObject;

import com.tas.wp500.utils.TCPClient;

@WebServlet("/downloadBackupFile")
public class DownloadBackupFile extends HttpServlet {
	final static Logger logger = Logger.getLogger(DownloadBackupFile.class);

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		String check_role = (String) session.getAttribute("role");

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
						json.put("role", check_role);

						String respStr = client.sendMessage(json.toString());
						logger.info("res " + new JSONObject(respStr));
						String message = new JSONObject(respStr).getString("msg");
						String status = new JSONObject(respStr).getString("status");

						JSONObject jsonObject = new JSONObject();
						jsonObject.put("message", message);
						jsonObject.put("status", status);

						// Set the content type of the response to
						// application/json
						response.setContentType("application/json");
						response.setHeader("X-Content-Type-Options", "nosniff");

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
						json.put("role", check_role);

						String respStr = client.sendMessage(json.toString());

						logger.info("res " + new JSONObject(respStr));

						String message = new JSONObject(respStr).getString("msg");
						String status = new JSONObject(respStr).getString("status");

						JSONObject jsonObject = new JSONObject();

						jsonObject.put("message", message);
						jsonObject.put("status", status);
						// Set the content type of the response to
						// application/json
						response.setContentType("application/json");
						response.setHeader("X-Content-Type-Options", "nosniff");

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
				case "downloadBackupFile":
					String clientToken = request.getParameter("tokenValue");
					String serverToken = (String) session.getAttribute("token");

					if (clientToken != null && clientToken.equals(serverToken)) {
						if (session != null && session.getAttribute("role") != null) {
							String userRole = (String) session.getAttribute("role");

							if (userRole.equalsIgnoreCase("admin")) {
								String zipFilePath = "/data/wp500_backup/backup.zip";
								File zipFile = new File(zipFilePath);

								if (zipFile.exists() && zipFile.isFile()) {
									// Set custom headers
									response.setContentType("application/octet-stream");
									response.setContentLength((int) zipFile.length());
									response.setHeader("Content-Disposition",
											"attachment; filename=\"" + zipFile.getName() + "\"");

									// Custom headers for status and message
									response.setHeader("X-Status", "success");
									response.setHeader("X-Message", "File download initiated");

									try (FileInputStream fis = new FileInputStream(zipFile);
											ServletOutputStream os = response.getOutputStream()) {

										byte[] bufferData = new byte[1024];
										int read;
										while ((read = fis.read(bufferData)) != -1) {
											os.write(bufferData, 0, read);
										}
										os.flush();
									} catch (IOException e) {
										e.printStackTrace();
									}
								} else {
									// Set custom headers for status and message
									response.setHeader("X-Status", "error");
									response.setHeader("X-Message", "ZIP file not found or is not a file");
									response.setContentType("text/plain");
									response.getWriter().write("ZIP file not found or is not a file");
								}
							} else {
								// Set custom headers for status and message
								response.setHeader("X-Status", "error");
								response.setHeader("X-Message", "User does not have the required role");
								response.setContentType("text/plain");
								response.getWriter().write("User does not have the required role");
							}
						} else {
							// Set custom headers for status and message
							response.setHeader("X-Status", "error");
							response.setHeader("X-Message", "User session or role not found");
							response.setContentType("text/plain");
							response.getWriter().write("User session or role not found");
						}
					} else {
						// Set custom headers for status and message
						response.setHeader("X-Status", "error");
						response.setHeader("X-Message", "Your Session has expired !!");
						response.setContentType("text/plain");
						response.getWriter().write("Your Session has expired !!");
					}
					break;
				}
			}
		}
	}
}
