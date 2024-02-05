package com.tas.wp500.servlet;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.JSONException;
import org.json.JSONObject;
import java.io.InputStream;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;

import javax.servlet.annotation.MultipartConfig;
import java.text.SimpleDateFormat;
import java.util.Date;

@MultipartConfig(maxFileSize = 409715200, // 400MB in bytes
		maxRequestSize = 409715200, // 400MB in bytes
		fileSizeThreshold = 0)
@WebServlet("/firmwareFileDownloadURL")
public class FirmwareFileDownloadURL extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {
	    try {
	    	String s3ObjectUrl = request.getParameter("fileUrl");
	    	Date currentDate = new Date();
	        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
	        String formattedDate = dateFormat.format(currentDate);
	        String newFileName = "taswp500-image-swupdate-taswp-" + formattedDate + ".swu";
	        String baseUploadPath = "/home/wp500/";//"C:\\Users\\sanke\\Desktop\\DbFile\\New folder4";
	        String newFolderName = "firmware-file"; // Change this to the desired folder name
	        String newFolderPath = baseUploadPath + File.separator + newFolderName;
	        File newFolder = new File(newFolderPath);
	        boolean folderCreated = newFolder.mkdirs();
	        String localFilePath = newFolderPath + File.separator + newFileName;	    		    	
	        HttpSession session = request.getSession();
	        URL url = new URL(s3ObjectUrl);
	        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
	        connection.setRequestMethod("GET");
	        connection.connect();
	        
	        if (connection.getResponseCode() == HttpURLConnection.HTTP_OK) {
	            int totalSize = connection.getContentLength();
	            byte[] buffer = new byte[4096]; // Chunk size
	            int bytesRead;
	            long downloadedBytes = 0;
	            try (InputStream inputStream = connection.getInputStream();
	                 FileOutputStream fileOutputStream = new FileOutputStream(localFilePath)) {
	                while ((bytesRead = inputStream.read(buffer)) != -1) {
	                    fileOutputStream.write(buffer, 0, bytesRead);
	                    downloadedBytes += bytesRead;
	                    int progress = (int) ((downloadedBytes * 100) / totalSize);
	                    session.setAttribute("uploadProgress", progress);
	                }
	            }	          
	            JSONObject jsonObject = new JSONObject();
	            jsonObject.put("status", "success");
	            jsonObject.put("message", "File downloaded successfully from URL.");
	            response.setContentType("application/json");
	            response.setHeader("X-Content-Type-Options", "nosniff");
	            PrintWriter out = response.getWriter();
	            out.print(jsonObject.toString());
	            out.flush();
	        } else {
	            JSONObject jsonObject = new JSONObject();
	            jsonObject.put("status", "error");
	            jsonObject.put("message", "Failed to download file. HTTP error code: " + connection.getResponseCode());
	            response.setContentType("application/json");
	            PrintWriter out = response.getWriter();
	            out.print(jsonObject.toString());
	            out.flush();
	        }
	    } catch (IOException | JSONException e) {
	        JSONObject jsonObject = new JSONObject();
	        try {
				jsonObject.put("status", "error");
				jsonObject.put("message", "Error downloading file: " + e.getMessage());
			} catch (JSONException e1) {
				e1.printStackTrace();
			}	        
	        response.setContentType("application/json");
	        response.setHeader("X-Content-Type-Options", "nosniff");
	        PrintWriter out = response.getWriter();
	        out.print(jsonObject.toString());
	        out.flush();
	    }
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		int progress = (int) session.getAttribute("uploadProgress");		
		JSONObject jsonObject = new JSONObject();
		try {
			jsonObject.put("progress", progress);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		response.setContentType("application/json");
		response.setHeader("X-Content-Type-Options", "nosniff");
		PrintWriter out = response.getWriter();
		out.print(jsonObject.toString());
		out.flush();
	}
}