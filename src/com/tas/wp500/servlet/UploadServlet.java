package com.tas.wp500.servlet;

import java.io.File;
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
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import javax.servlet.annotation.MultipartConfig;

//...
@MultipartConfig(maxFileSize = 409715200, // 400MB in bytes
		maxRequestSize = 409715200, // 400MB in bytes
		fileSizeThreshold = 0)
@WebServlet("/UploadServlet")
public class UploadServlet extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		try {
			Part filePart = request.getPart("file");

			String uploadPath = "C:\\Users\\sanke\\Desktop\\DbFile\\New folder3";

			File uploadDir = new File(uploadPath);
			if (!uploadDir.exists()) {
				uploadDir.mkdirs();
			}
			String fileName = getFileName(filePart);
			String filePath = uploadPath + File.separator + fileName;

			HttpSession session = request.getSession();
			long fileSize = filePart.getSize();
			long uploadedBytes = 0;
			byte[] buffer = new byte[8192]; // 8KB buffer
			int bytesRead;

			try (InputStream input = filePart.getInputStream()) {
				while ((bytesRead = input.read(buffer)) != -1) {
					// Write the data to the file
					try (java.io.OutputStream out = new java.io.FileOutputStream(filePath, true)) {
						out.write(buffer, 0, bytesRead);
					}
					uploadedBytes += bytesRead;

					// Ensure uploadedBytes does not exceed fileSize
					if (uploadedBytes > fileSize) {
						uploadedBytes = fileSize;
					}

					// Calculate the progress
					int progress = (int) ((uploadedBytes * 100) / fileSize);

					// Set progress to 100% when upload is completed
					if (uploadedBytes == fileSize) {
						progress = 100;
					}

					// Update the progress attribute in session
					session.setAttribute("uploadProgress", progress);
				}			
			}

			JSONObject jsonObject = new JSONObject();
			jsonObject.put("status", "success");
			jsonObject.put("message", "File uploaded successfully.");

			response.setContentType("application/json");

			PrintWriter out = response.getWriter();

			out.print(jsonObject.toString());
			out.flush();
		} catch (IOException | JSONException e) {
			JSONObject jsonObject = new JSONObject();
			try {
				jsonObject.put("status", "error");
				jsonObject.put("message", "Error uploading file: " + e.getMessage());
			} catch (JSONException e1) {
				e1.printStackTrace();
			}

			response.setContentType("application/json");

			PrintWriter out = response.getWriter();

			out.print(jsonObject.toString());
			out.flush();
		}
	}

	private String getFileName(final Part part) {
		for (String content : part.getHeader("content-disposition").split(";")) {
			if (content.trim().startsWith("filename")) {
				return content.substring(content.indexOf('=') + 1).trim().replace("\"", "");
			}
		}
		return null;
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
