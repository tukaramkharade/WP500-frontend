package com.tas.wp500.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;

import com.tas.wp500.utils.TCPClient;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Base64;

@WebServlet("/imageServlet")
public class ImageServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {

        HttpSession session = request.getSession(false);

        if (session != null && session.getAttribute("username") != null) {
            String check_username = (String) session.getAttribute("username");

            try {
                TCPClient client = new TCPClient();
                JSONObject json = new JSONObject();

                json.put("operation", "get_qr_code");
                json.put("user", check_username);

                String respStr = client.sendMessage(json.toString());

                System.out.println("res " + new JSONObject(respStr));

                JSONObject result = new JSONObject(respStr);

                String qr_image = result.getString("qr_image");
                System.out.println("qr_image :"+qr_image.toString());
                
                String secret_key = result.getString("secret_key");
                System.out.println("secret_key :"+secret_key.toString());

                if (!qr_image.isEmpty()) {
                    // Create a JSON object to hold the image and secret_key
                    JSONObject responseJson = new JSONObject();
                    responseJson.put("qr_image", qr_image);
                    responseJson.put("secret_key", secret_key);

                    // Set the response content type to JSON
                    response.setContentType("application/json");

                    // Write the JSON data to the response
                    PrintWriter out = response.getWriter();
                    out.print(responseJson.toString());
                    out.flush();
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        } else {
            try {
                JSONObject userObj = new JSONObject();
                userObj.put("msg", "Your session has timed out. Please log in again");
                userObj.put("status", "fail");

                System.out.println(">>" + userObj);

                // Set the response content type to JSON
                response.setContentType("application/json");

                // Write the JSON data to the response
                PrintWriter out = response.getWriter();
                out.print(userObj.toString());
                out.flush();
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            } catch (Exception e) {
                e.printStackTrace();
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	
		
		HttpSession session = request.getSession(false);

		if (session != null) {
			String check_username = (String) session.getAttribute("username");

			String otp = request.getParameter("otp");
			String secretKey = request.getParameter("secretKey");
			System.out.println("otp-->"+otp+"secretKey-->"+secretKey);

		try {
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();

			json.put("operation", "totp_authenticator");
			json.put("secret_key", secretKey);
			json.put("otp", otp);


			String respStr = client.sendMessage(json.toString());

            System.out.println("res " + new JSONObject(respStr));

            JSONObject result = new JSONObject(respStr);

            String otp_result = result.getString("otp_result");
			
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("otp_result", otp_result);

			// Set the content type of the response to application/json
			response.setContentType("application/json");

			// Get the response PrintWriter
			PrintWriter out1 = response.getWriter();

			// Write the JSON object to the response
			out1.print(jsonObject.toString());
			out1.flush();

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		}else{
			System.out.println("Login first");
			response.sendRedirect("login.jsp");
		}
	}
    
}
