package com.tas.wp500.servlet;

import java.io.File;
import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import javax.servlet.annotation.MultipartConfig;
//...
@MultipartConfig(
 maxFileSize = 209715200, // 100MB in bytes
 maxRequestSize = 409715200, // 400MB in bytes
 fileSizeThreshold = 0
)
@WebServlet("/UploadServlet")
public class UploadServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    //    String uploadPath = "E:\\ftpupload"; // Specify the directory where you want to save uploaded files.
    	String uploadPath = "/file_upload_test";
     
        // Create the directory if it doesn't exist.
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        Part filePart = request.getPart("file"); // Get the uploaded file part.

        // Get the filename from the filePart.
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

        // Save the file to the specified directory.
        try (InputStream input = filePart.getInputStream()) {
            Files.copy(input, Paths.get(uploadPath, fileName), StandardCopyOption.REPLACE_EXISTING);
        }

        // You can now process the uploaded file as needed.

        response.getWriter().println("File uploaded successfully.");
     
        // Redirect to firmwarUpdate.jsp
        RequestDispatcher dispatcher = request.getRequestDispatcher("/firmwareUpdate.jsp");
        dispatcher.forward(request, response);
    
    }
}
