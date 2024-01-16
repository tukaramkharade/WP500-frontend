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
import org.json.JSONArray;
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
		String check_token = (String) session.getAttribute("token");
		String check_role = (String) session.getAttribute("role");
		
		String action = request.getParameter("action");
		
		if (check_username != null) {
			if (action != null) {
				switch (action) {
				case "getTOTPDetails":
					
					try{
						
						json.put("operation", "get_totp_details");
						json.put("username", check_username);
						json.put("user", check_username);
						json.put("token", check_token);
						json.put("role", check_role);
						
						String respStr = client.sendMessage(json.toString());

						JSONObject respJson = new JSONObject(respStr);

						String status = respJson.getString("status");
						
						logger.info("res " + respJson.toString());
						
						JSONObject finalJsonObj = new JSONObject();
						if(status.equals("success")){
							//for (int i = 0; i < respJson.length(); i++) {
								String totp_authenticator = respJson.getString("totp_authenticator");
								
								
								try{
									finalJsonObj.put("status", status);
									finalJsonObj.put("totp_authenticator", totp_authenticator);
									
								}catch(Exception e){
									e.printStackTrace();
									logger.error("Error in putting totp details in json object :"+e);
								}
							//}
						}else if(status.equals("fail")){
							String message = respJson.getString("msg");
							
							finalJsonObj.put("status", status);
						    finalJsonObj.put("message", message);
						}
						
						
						 response.setHeader("X-Content-Type-Options", "nosniff");
						 
						// Get the response PrintWriter
						PrintWriter out = response.getWriter();

						// Write the JSON object to the response
						out.print(finalJsonObj.toString());
						out.flush();
						
						
					}catch(Exception e){
						e.printStackTrace();
						logger.error("Error in getting totp details : "+e);
					}
					break;
					
				
				}
			}
			
		}
		
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		HttpSession session = request.getSession(true);

		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		String check_role = (String) session.getAttribute("role");
		
		if (check_username != null) {
			
			String totp_authenticator = request.getParameter("totp_authenticator");
			
			try{
				
				TCPClient client = new TCPClient();
				JSONObject json = new JSONObject();

				json.put("operation", "update_totp");
				json.put("user", check_username);
				json.put("username", check_username);
				json.put("totp_authenticator", totp_authenticator);
				json.put("token", check_token);
				json.put("role", check_role);
				
				String respStr = client.sendMessage(json.toString());

				logger.info("res " + new JSONObject(respStr));

				String message = new JSONObject(respStr).getString("msg");
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("message", message);

				// Set the content type of the response to
				// application/json
				response.setContentType("application/json");
				 response.setHeader("X-Content-Type-Options", "nosniff");

				// Get the response PrintWriter
				PrintWriter out = response.getWriter();

				// Write the JSON object to the response
				out.print(jsonObject.toString());
				out.flush();
				
			}catch(Exception e){
				e.printStackTrace();
				logger.error("Error updating totp authenticator : "+e);
			}
			
		}
	}

}
