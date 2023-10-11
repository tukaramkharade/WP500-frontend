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

@WebServlet("/DownloadLogServlet")
public class DownloadLogServlet extends HttpServlet {
	 protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		 String requestedFileName = request.getParameter("log_file");
    	//String requestedFileName = "WP500_2020-09-20_10-17-09.log";
        if (requestedFileName == null || requestedFileName.equals("")) {
            throw new ServletException("File Name can't be null or empty");
        }

        String logDirectoryPath = "/var/log";
        File logDirectory = new File(logDirectoryPath);
        File[] files = logDirectory.listFiles();
        boolean fileFound = false;
        File logFile = null;

        for (File file : files) {
            if (file.isFile() && file.getName().equals(requestedFileName)) {
                fileFound = true;
                logFile = file;
                break;
            }
        }

        if (fileFound) {
            System.out.println("File Found: " + logFile.getAbsolutePath());

            ServletContext ctx = getServletContext();
            InputStream fis = new FileInputStream(logFile);
            String mimeType = ctx.getMimeType(logFile.getAbsolutePath());
            response.setContentType(mimeType != null ? mimeType : "application/octet-stream");
            response.setContentLength((int) logFile.length());
            response.setHeader("Content-Disposition", "attachment; filename=\"" + logFile.getName() + "\"");

            ServletOutputStream os = response.getOutputStream();
            byte[] bufferData = new byte[1024];
            int read;
            while ((read = fis.read(bufferData)) != -1) {
                os.write(bufferData, 0, read);
            }
            os.flush();
            os.close();
            fis.close();
            System.out.println("File downloaded at client successfully");
        } 
    }
}
