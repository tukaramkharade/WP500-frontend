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
import org.json.JSONObject;

import com.tas.wp500.utils.TCPClient;

@WebServlet("/ChangePasswordServlet")
public class ChangePasswordServlet extends HttpServlet {
	final static Logger logger = Logger.getLogger(ChangePasswordServlet.class);

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		TCPClient client = new TCPClient();
		JSONObject json = new JSONObject();
		JSONObject respJson = null;
		
		HttpSession session = request.getSession(true);
		
		// Check if the password is set in the session
        boolean isPasswordSet = session.getAttribute("password_set") != null;

		String check_username = (String) session.getAttribute("username");
		
		if (check_username != null) {
			
		
			String username = request.getParameter("username");
			String old_password = request.getParameter("old_password");
			String new_password = request.getParameter("new_password");
			
			
				try{
					
					json.put("operation", "update_old_password");
					json.put("user", check_username);
					json.put("username", username);
					json.put("old_password", old_password);
					json.put("new_password", new_password);
					
					String respStr = client.sendMessage(json.toString());

					logger.info("res " + new JSONObject(respStr).getString("msg"));
					
					String message = new JSONObject(respStr).getString("msg");
					JSONObject jsonObject = new JSONObject();
					jsonObject.put("message", message);
					
					// Set the content type of the response to
					// application/json
					response.setContentType("application/json");

					// Get the response PrintWriter
					PrintWriter out = response.getWriter();

					// Write the JSON object to the response
					out.print(jsonObject.toString());
					out.flush();
					
					if (!isPasswordSet) {
		                // Set the flag in the session to indicate that the password is set
		                session.setAttribute("password_set", true);
		            }
					
				}catch(Exception e){
					e.printStackTrace();
					logger.error("Error in updating old password to new password: "+e);
				}
			
			
		}else{
			try {
				JSONObject userObj = new JSONObject();
				userObj.put("msg", "Your session is timeout. Please login again");
				userObj.put("status", "fail");

				System.out.println(">>" + userObj);

				// Set the response content type to JSON
				response.setContentType("application/json");

				// Write the JSON data to the response
				response.getWriter().print(userObj.toString());

			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error in session timeout: " + e);
			}
		}
	}

}
