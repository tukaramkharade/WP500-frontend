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
import javax.servlet.annotation.MultipartConfig;

@MultipartConfig(maxFileSize = 409715200, // 400MB in bytes
		maxRequestSize = 409715200, // 400MB in bytes
		fileSizeThreshold = 0)
@WebServlet("/UploadServlet")
public class UploadServlet extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		try {
			Part filePart = request.getPart("file");
			String uploadPath = "";
			String fileName = "";
			String filePath = "";

			String fileExtension = getFileExtension(filePart);
			System.out.println("fileExtension-->" + fileExtension);
			if (fileExtension != null && fileExtension.equalsIgnoreCase("swu")) {
				String baseUploadPath = "/home/wp500/";
				String newFolderName = "firmware-file"; // Change this to the desired folder name
				String newFolderPath = baseUploadPath + File.separator + newFolderName;
				File newFolder = new File(newFolderPath);
				boolean folderCreated = newFolder.mkdirs();
				fileName = getFileName(filePart);
				filePath = newFolderPath + File.separator + fileName;
			} else if (fileExtension != null && fileExtension.equalsIgnoreCase("cod")) {
				String baseUploadPath = "/etc/wp500cfg/";
				String originalFileName;
				String newFolderName = "t5cod";
				String defaultFileName = "t5.cod";
				String newFolderPath = baseUploadPath + File.separator + newFolderName;
				File newFolder = new File(newFolderPath);
				boolean folderCreated = newFolder.mkdirs();
				originalFileName = getFileName(filePart);
				if (originalFileName != null && !originalFileName.isEmpty()) {
					fileName = defaultFileName; // Set the default file name
				} else {
					fileName = originalFileName; // Use the original file name
				}
				File existingFile = new File(newFolderPath + File.separator + defaultFileName);
				if (existingFile.exists() && existingFile.isFile()) {
					boolean deletionStatus = existingFile.delete();
					if (deletionStatus) {
						filePath = newFolderPath + File.separator + fileName;
					} else {
					}
				} else {
					filePath = newFolderPath + File.separator + fileName;
				}
			} else if (fileExtension != null && fileExtension.equalsIgnoreCase("zip")) {
				String baseUploadPath = "/data/";
				String originalFileName;
				String newFolderName = "wp500_backup";
				String defaultFileName = "backup.zip";
				String newFolderPath = baseUploadPath + File.separator + newFolderName;
				File newFolder = new File(newFolderPath);
				boolean folderCreated = newFolder.mkdirs();
				originalFileName = getFileName(filePart);
				if (originalFileName != null && !originalFileName.isEmpty()) {
					fileName = defaultFileName; // Set the default file name
				} else {
					fileName = originalFileName; // Use the original file name
				}

				File existingFile = new File(newFolderPath + File.separator + defaultFileName);
				if (existingFile.exists() && existingFile.isFile()) {
					boolean deletionStatus = existingFile.delete();
					if (deletionStatus) {
						filePath = newFolderPath + File.separator + fileName;
					} else {
					}
				} else {
					filePath = newFolderPath + File.separator + fileName;
				}
			}
			HttpSession session = request.getSession();
			long fileSize = filePart.getSize();
			long uploadedBytes = 0;
			byte[] buffer = new byte[8192]; // 8KB buffer
			int bytesRead;
			try (InputStream input = filePart.getInputStream()) {
				while ((bytesRead = input.read(buffer)) != -1) {
					try (java.io.OutputStream out = new java.io.FileOutputStream(filePath, true)) {
						out.write(buffer, 0, bytesRead);
					}
					uploadedBytes += bytesRead;
					if (uploadedBytes > fileSize) {
						uploadedBytes = fileSize;
					}
					int progress = (int) ((uploadedBytes * 100) / fileSize);
					if (uploadedBytes == fileSize) {
						progress = 100;
					}
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
			response.setHeader("X-Content-Type-Options", "nosniff");
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

	private String getFileExtension(final Part part) {
		String contentDisposition = part.getHeader("content-disposition");
		if (contentDisposition != null) {
			for (String content : contentDisposition.split(";")) {
				if (content.trim().startsWith("filename")) {
					String fileName = content.substring(content.indexOf('=') + 1).trim().replace("\"", "");
					int lastDotIndex = fileName.lastIndexOf('.');
					if (lastDotIndex > 0) {
						return fileName.substring(lastDotIndex + 1);
					}
				}
			}
		}
		return "";
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
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