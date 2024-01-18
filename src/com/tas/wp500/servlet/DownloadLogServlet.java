package com.tas.wp500.servlet;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/DownloadLogServlet")
public class DownloadLogServlet extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		String clientToken = request.getParameter("token");
		String serverToken = (String) session.getAttribute("token");

		if (clientToken != null && clientToken.equals(serverToken)) {
			if (session != null && session.getAttribute("role") != null) {
				String userRole = (String) session.getAttribute("role");

				if (userRole.equalsIgnoreCase("admin")) {
					String requestedFileName = request.getParameter("log_file");
					if (requestedFileName == null || requestedFileName.equals("")) {
						response.setHeader("X-Message", "File Name can't be null or empty");
						response.setHeader("X-Status", "error");
						return;
					}
					String logDirectoryPath = "/data/log";
					File logDirectory = new File(logDirectoryPath);
					File logFile = new File(logDirectory, requestedFileName);

					if (!logFile.exists() || !logFile.isFile()) {
						response.setHeader("X-Message", "File not found");
						response.setHeader("X-Status", "error");
						return;
					}
					if (!logFile.getCanonicalPath().startsWith(logDirectory.getCanonicalPath())) {
						response.setHeader("X-Message", "Invalid file path");
						response.setHeader("X-Status", "error");
						return;
					}

					// Set response headers for success
					response.setHeader("X-Status", "success");
					response.setHeader("X-Message", "File download initiated");

					// Set response headers
					response.setContentType("application/octet-stream");
					response.setContentLength((int) logFile.length());
					String encodedFileName = URLEncoder.encode(logFile.getName(), "UTF-8");
					String headerKey = "Content-Disposition";
					String headerValue = String.format("attachment; filename=\"%s\"; filename*=UTF-8''%s",
							logFile.getName(), encodedFileName);
					response.setHeader(headerKey, headerValue);

					// Copy file content to response body
					try (OutputStream outStream = response.getOutputStream();
							FileInputStream inStream = new FileInputStream(logFile)) {
						byte[] buffer = new byte[4096];
						int bytesRead;
						while ((bytesRead = inStream.read(buffer)) != -1) {
							outStream.write(buffer, 0, bytesRead);
						}
					}
				} else {
					// Set response headers for unauthorized access
					response.setHeader("X-Status", "error");
					response.setHeader("X-Message", "Unauthorized access");
				}
			} else {
				// Set response headers for session invalid or not logged in
				response.setHeader("X-Status", "error");
				response.setHeader("X-Message", "Session invalid or not logged in");
				response.sendRedirect("login.jsp");
			}
		} else {
			// Set response headers for invalid token
			response.setHeader("X-Status", "error");
			response.setHeader("X-Message", "Invalid token");

		}
	}
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

	}

}
