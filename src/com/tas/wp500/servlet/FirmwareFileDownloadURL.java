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
import javax.servlet.http.Part;
import org.json.JSONException;
import org.json.JSONObject;
import java.io.InputStream;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import javax.servlet.annotation.MultipartConfig;
import java.text.SimpleDateFormat;
import java.util.Date;
//...
@MultipartConfig(maxFileSize = 409715200, // 400MB in bytes
		maxRequestSize = 409715200, // 400MB in bytes
		fileSizeThreshold = 0)
@WebServlet("/firmwareFileDownloadURL")
public class FirmwareFileDownloadURL extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {
	    try {
	    	String s3ObjectUrl = request.getParameter("fileUrl");
	    	System.out.println("Received file URL: " + s3ObjectUrl);
//	        String s3ObjectUrl = "https://wp500-public.s3.ap-south-1.amazonaws.com/taswp500-image-swupdate-taswp500-20231012125251.swu";
//	        String localFilePath = "C:\\Users\\Onkar\\Documents\\WP500 projects\\taswp500-image-swupdate-taswp500-20231012125251.swu";
	    	Date currentDate = new Date();
	        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
	        String formattedDate = dateFormat.format(currentDate);

	        String newFileName = "taswp500-image-swupdate-taswp-" + formattedDate + ".swu";

	        // Define the base directory path
	        String baseUploadPath = "/home/wp500/";//"C:\\Users\\sanke\\Desktop\\DbFile\\New folder4";
	        String newFolderName = "firmware-file"; // Change this to the desired folder name

	        // Create the path for the new folder
	        String newFolderPath = baseUploadPath + File.separator + newFolderName;

	        // Create the directory if it doesn't exist
	        File newFolder = new File(newFolderPath);
	        boolean folderCreated = newFolder.mkdirs();

	        // Construct the complete file path with the new file name inside the created folder
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

	                    // Calculate and display the download percentage
	                    int progress = (int) ((downloadedBytes * 100) / totalSize);
	                    System.out.println("Download Progress: " + progress + "%");
	                    session.setAttribute("uploadProgress", progress);
	                }
	            }
	            
	            JSONObject jsonObject = new JSONObject();
	            jsonObject.put("status", "success");
	            jsonObject.put("message", "File downloaded successfully from URL.");

	            response.setContentType("application/json");

	            PrintWriter out = response.getWriter();
	            out.print(jsonObject.toString());
	            out.flush();
	        } else {
	            // Handle connection errors
	            JSONObject jsonObject = new JSONObject();
	            jsonObject.put("status", "error");
	            jsonObject.put("message", "Failed to download file. HTTP error code: " + connection.getResponseCode());

	            response.setContentType("application/json");

	            PrintWriter out = response.getWriter();
	            out.print(jsonObject.toString());
	            out.flush();
	        }
	    } catch (IOException | JSONException e) {
	        // Handle exceptions
	        JSONObject jsonObject = new JSONObject();
	        try {
				jsonObject.put("status", "error");
				jsonObject.put("message", "Error downloading file: " + e.getMessage());
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}	        

	        response.setContentType("application/json");

	        PrintWriter out = response.getWriter();
	        out.print(jsonObject.toString());
	        out.flush();
	    }
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession();
		int progress = (int) session.getAttribute("uploadProgress");
		
		// Create a JSON object for progress response
		JSONObject jsonObject = new JSONObject();
		try {
			jsonObject.put("progress", progress);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		// Set the content type of the response to application/json
		response.setContentType("application/json");

		// Get the response PrintWriter
		PrintWriter out = response.getWriter();

		// Write the JSON object to the response
		out.print(jsonObject.toString());
		out.flush();
	}
}

