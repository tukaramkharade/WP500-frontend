package com.tas.wp500.servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;

import com.tas.wp500.utils.TCPClient;

@WebServlet("/WP500Login")
public class WP500Login extends HttpServlet {
    final static Logger logger = Logger.getLogger(WP500Login.class);

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        boolean isFirstLogin = (session.getAttribute("firstLogin") == null);

        
        session.setMaxInactiveInterval(1800);

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        JSONObject userObj = new JSONObject();

        try {
            TCPClient client = new TCPClient();
            JSONObject json = new JSONObject();

            json.put("operation", "login");
            json.put("username", username);
            json.put("password", password);
            
            String respStr = client.sendMessage(json.toString());

            logger.info("Response: " + respStr);

            JSONObject jsonResponse = new JSONObject(respStr);
            String status = jsonResponse.getString("status");
            
            if(status.equals("success")) {
                String role = jsonResponse.getString("role");
                session.setAttribute("username", username);
                session.setAttribute("role", role);

                userObj.put("status", status);
            } else if (status.equals("fail")) {
                userObj.put("msg", "Invalid user. Please login again");
                userObj.put("status", status);
            }

        } catch (Exception e) {
            e.printStackTrace();
            logger.error("Error in login : " + e);
           
            try {
            	 userObj.put("status", "error");
				userObj.put("msg", "An error occurred during login.");
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
        }

        // Set the content type of the response to application/json
        response.setContentType("application/json");

        // Get the response PrintWriter
        PrintWriter out = response.getWriter();

        // Write the JSON object to the response
        out.print(userObj.toString());
        out.flush();
        
    }
}
