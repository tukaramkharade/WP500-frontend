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


@WebServlet("/twofacorAuthOTPServlet")
public class TwofacorAuthOTPServlet extends HttpServlet {
	final static Logger logger = Logger.getLogger(TwofacorAuthOTPServlet.class);
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		TCPClient client = new TCPClient();
		JSONObject json = new JSONObject();
		
		JSONObject jsonObject = new JSONObject();
		
		HttpSession session = request.getSession(true);

		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		String check_role = (String) session.getAttribute("role");
		
		if (check_username != null) {
			try{
				
				json.put("operation", "get_user_totp_key");
				json.put("username", check_username);
				json.put("user", check_username);
				json.put("role", check_role);
			//	json.put("token", check_token);
				
				String respStr = client.sendMessage(json.toString());

				JSONObject respJson = new JSONObject(respStr);

				logger.info("res " + respJson.toString());
				
				for (int i = 0; i < respJson.length(); i++) {
					String totp_key = respJson.getString("totp_key");
					
					try{
						
						jsonObject.put("totp_key", totp_key);
						
					}catch(Exception e){
						e.printStackTrace();
						logger.error("Error in putting totp details in json object :"+e);
					}
				}
				
				 response.setHeader("X-Content-Type-Options", "nosniff");
				// Get the response PrintWriter
				PrintWriter out = response.getWriter();

				// Write the JSON object to the response
				out.print(jsonObject.toString());
				out.flush();
				
			}catch(Exception e){
				
			}
		}
		
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
		TCPClient client = new TCPClient();
		JSONObject json = new JSONObject();
		
		JSONObject jsonObject = new JSONObject();
		
		HttpSession session = request.getSession(true);

		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		String check_role = (String) session.getAttribute("role");
		
		String to_email_id = request.getParameter("to_email_id");
		
		if (check_username != null) {
			try{
				
				json.put("operation", "send_otp_email");
				json.put("username", check_username);
				json.put("user", check_username);
		//		json.put("token", check_token);
				json.put("to_email_id", to_email_id);
				json.put("role", check_role);
				
				String respStr = client.sendMessage(json.toString());

				JSONObject respJson = new JSONObject(respStr);

				logger.info("res " + respJson.toString());
				
				String message = new JSONObject(respStr).getString("msg");
				String status = new JSONObject(respStr).getString("status");
				
				jsonObject.put("message", message);
				jsonObject.put("status", status);

				// Set the content type of the response to application/json
				response.setContentType("application/json");
				 response.setHeader("X-Content-Type-Options", "nosniff");

				// Get the response PrintWriter
				PrintWriter out = response.getWriter();

				// Write the JSON object to the response
				out.print(jsonObject.toString());
				out.flush();			
				
			}catch(Exception e){
				
				
			}
		}
	}

}
