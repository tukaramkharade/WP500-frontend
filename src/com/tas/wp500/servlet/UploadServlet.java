package com.tas.wp500.servlet;

import java.io.File;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
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
		// String uploadPath = "E:\\ftpupload"; // Specify the directory where
		// you want to save uploaded files.
		String uploadPath = "C:\\Users\\sanke\\Desktop\\DbFile\\New folder3";
//		String uploadPath = "\test";
		File uploadDir = new File(uploadPath);

		if (!uploadDir.exists()) {
			uploadDir.mkdirs();
		}

		Part filePart = request.getPart("file");

		// Get the filename from the filePart.
		String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
		String filePath = Paths.get(uploadPath, fileName).toString();

		try (InputStream input = filePart.getInputStream()) {
			Files.copy(input, Paths.get(uploadPath, fileName), StandardCopyOption.REPLACE_EXISTING);

			// Create a JSON object for success response
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("status", "success");
			jsonObject.put("message", "File uploaded successfully.");

			// Set the content type of the response to application/json
			response.setContentType("application/json");

			// Get the response PrintWriter
			PrintWriter out = response.getWriter();

			// Write the JSON object to the response
			out.print(jsonObject.toString());
			out.flush();
		} catch (IOException | JSONException e) {
			// Create a JSON object for error response
			JSONObject jsonObject = new JSONObject();
			try {
				jsonObject.put("status", "error");
				jsonObject.put("message", "Error uploading file.");
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
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
}
