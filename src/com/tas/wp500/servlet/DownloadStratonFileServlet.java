package com.tas.wp500.servlet;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/downloadSratonFile")
public class DownloadStratonFileServlet extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    String userProvidedFileName = request.getParameter("userFileName");
	    System.out.println("userProvidedFileName: " + userProvidedFileName);
	    if (userProvidedFileName == null || userProvidedFileName.equals("")) {
	        throw new ServletException("File Name can't be null or empty");
	    }

	    String logDirectoryPath =  "/etc/wp500cfg/t5cod";//"/etc/wp500cfg/t5cod";//"C:\\Users\\sanke\\Desktop\\DbFile\\New folder4\\t5cod"; // Directory path
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
	            System.out.println("File downloaded at client successfully");
	        } catch (IOException e) {
	            // Log the exception and handle it appropriately
	            e.printStackTrace();
	            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error while downloading file");
	        }
	    } else {
	        System.out.println("File not found or not available for download");
	        response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found or not available for download");
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
