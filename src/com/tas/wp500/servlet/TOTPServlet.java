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

@WebServlet("/TOTPServlet")
public class TOTPServlet extends HttpServlet {
	final static Logger logger = Logger.getLogger(TOTPServlet.class);

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		TCPClient client = new TCPClient();
		JSONObject json = new JSONObject();
		
		JSONObject jsonObject = new JSONObject();
		
		HttpSession session = request.getSession(true);

		String check_username = (String) session.getAttribute("username");
		String action = request.getParameter("action");
		
		if (check_username != null) {
			if (action != null) {
				switch (action) {
				case "getTOTPDetails":
					
					try{
						
						json.put("operation", "get_totp_details");
						json.put("username", check_username);
						json.put("user", check_username);
						
						String respStr = client.sendMessage(json.toString());

						JSONObject respJson = new JSONObject(respStr);

						logger.info("res " + respJson.toString());
						
						for (int i = 0; i < respJson.length(); i++) {
							String totp_authenticator = respJson.getString("totp_authenticator");
							
							try{
								
								jsonObject.put("totp_authenticator", totp_authenticator);
								
							}catch(Exception e){
								e.printStackTrace();
								logger.error("Error in putting totp details in json object :"+e);
							}
						}
						
						// Get the response PrintWriter
						PrintWriter out = response.getWriter();

						// Write the JSON object to the response
						out.print(jsonObject.toString());
						out.flush();
						
						
					}catch(Exception e){
						e.printStackTrace();
						logger.error("Error in getting totp details : "+e);
					}
					break;
					
				
				}
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

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		HttpSession session = request.getSession(true);

		String check_username = (String) session.getAttribute("username");
		
		if (check_username != null) {
			
			String totp_authenticator = request.getParameter("totp_authenticator");
			
			try{
				
				TCPClient client = new TCPClient();
				JSONObject json = new JSONObject();

				json.put("operation", "update_totp");
				json.put("user", check_username);
				json.put("username", check_username);
				json.put("totp_authenticator", totp_authenticator);
				
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
				
				
				
			}catch(Exception e){
				e.printStackTrace();
				logger.error("Error updating totp authenticator : "+e);
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
