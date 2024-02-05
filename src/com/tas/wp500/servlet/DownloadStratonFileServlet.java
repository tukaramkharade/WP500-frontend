package com.tas.wp500.servlet;

import org.apache.log4j.Logger;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/downloadSratonFile")
public class DownloadStratonFileServlet extends HttpServlet {
	final static Logger logger = Logger.getLogger(DownloadStratonFileServlet.class);

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);		
	    String userProvidedFileName = request.getParameter("userFileName");
	    String csrfTokenFromRequest = request.getParameter("csrfToken");
		String csrfTokenFromSession = (String) session.getAttribute("csrfToken");		
		if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
	    if (userProvidedFileName == null || userProvidedFileName.equals("")) {
	        throw new ServletException("File Name can't be null or empty");
	    }
	    String logDirectoryPath =  "/etc/wp500cfg/t5cod";
	    File logDirectory = new File(logDirectoryPath);
	    File[] files = logDirectory.listFiles();
	    boolean fileFound = false;
	    File logFile = null;
	    String requestedFileName = "t5.cod"; // File name requested by the user
	    for (File file : files) {
	        if (file.isFile() && file.getName().equals(requestedFileName)) {
	            fileFound = true;
	            logFile = file;
	            break;
	        }
	    }
	    if (fileFound && logFile != null) {
	    	 String fileExtension = getFileExtension(logFile.getName());
	        response.setContentType("application/octet-stream");
	        response.setContentLength((int) logFile.length());
	        response.setHeader("Content-Disposition", "attachment; filename=\"" + userProvidedFileName + fileExtension + "\"");
	        response.setHeader("X-Status", "success");
	        try (InputStream fis = new FileInputStream(logFile);
	             ServletOutputStream os = response.getOutputStream()) {
	            byte[] bufferData = new byte[1024];
	            int read;
	            while ((read = fis.read(bufferData)) != -1) {
	                os.write(bufferData, 0, read);
	            }
	            os.flush();
	        } catch (IOException e) {
	            e.printStackTrace();
	            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error while downloading file");
	        }
	    } else {
	        response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found or not available for download");
	    }
		}else {
			logger.error("Token validation failed");	
		}
	}
	
	private String getFileExtension(String fileName) {
	    int lastDotIndex = fileName.lastIndexOf('.');
	    if (lastDotIndex != -1) {
	        return fileName.substring(lastDotIndex);
	    }
	    return ""; // If no extension found
	}
}