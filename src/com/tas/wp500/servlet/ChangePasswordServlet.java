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
		TCPClient client = new TCPClient();
		JSONObject json = new JSONObject();
		
		HttpSession session = request.getSession(true);
		JSONObject jsonObject = new JSONObject();
		
		String check_username = (String) session.getAttribute("username");
		
		if (check_username != null) {
			try{
				
				json.put("operation", "password_policy");
				json.put("operation_type", "get_password_info");
				json.put("user", check_username);
				
				String respStr = client.sendMessage(json.toString());
				JSONObject respJson = new JSONObject(respStr);

				logger.info("res " + respJson.toString());
				
				for (int i = 0; i < respJson.length(); i++) {
					String characters_count = respJson.getString("characters_count");
					String ascii_ch_count = respJson.getString("ascii_ch_count");
					String number_count = respJson.getString("number_count");
					String mixed_ch_count = respJson.getString("mixed_ch_count");
					String allowed_special_ch = respJson.getString("allowed_special_ch");
					String special_ch_count = respJson.getString("special_ch_count");

					try {
						jsonObject.put("characters_count", characters_count);
						jsonObject.put("ascii_ch_count", ascii_ch_count);
						jsonObject.put("number_count", number_count);
						jsonObject.put("mixed_ch_count", mixed_ch_count);
						jsonObject.put("allowed_special_ch", allowed_special_ch);
						jsonObject.put("special_ch_count", special_ch_count);

					} catch (Exception e) {
						e.printStackTrace();
					}

				}

				response.setContentType("application/json");

				// Get the response PrintWriter
				PrintWriter out = response.getWriter();

				// Write the JSON object to the response
				// Trim the JSON data before sending
				out.print(jsonObject.toString().trim());

				out.flush();
				
				
			}catch(Exception e){
				e.printStackTrace();
				logger.error("Error in getting password info: " + e);
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
		TCPClient client = new TCPClient();
		JSONObject json = new JSONObject();
		
		HttpSession session = request.getSession(true);
		
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
					String status = new JSONObject(respStr).getString("status");
					System.out.println("status : "+status);
					
					JSONObject jsonObject = new JSONObject();
					jsonObject.put("message", message);
					jsonObject.put("status", status);
					
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
