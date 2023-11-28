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

@WebServlet("/wireguardServlet")
public class WireguardServlet extends HttpServlet {
	final static Logger logger = Logger.getLogger(WireguardServlet.class);
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		HttpSession session = request.getSession(false);

		String check_username = (String) session.getAttribute("username");
		
		if (check_username != null) {
			
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();
			JSONObject jsonObject = new JSONObject();
			
			try{
				
				json.put("operation", "get_wireguard_keys");
				json.put("user", check_username);
				
				String respStr = client.sendMessage(json.toString());

				logger.info("res " + new JSONObject(respStr));

				JSONObject respJson = new JSONObject(respStr);
				
				for (int i = 0; i < respJson.length(); i++) {
					String message = respJson.getString("msg");
					String public_key = respJson.getString("public_key");
					String private_key = respJson.getString("private_key");
					
					try{
						
						jsonObject.put("message", message);
						jsonObject.put("public_key", public_key);
						jsonObject.put("private_key", private_key);
						
					}catch(Exception e){
						e.printStackTrace();
						logger.error("Error in wireguard keys in json object :"+e);
					}
				}
				
				// Get the response PrintWriter
				PrintWriter out = response.getWriter();

				// Write the JSON object to the response
				out.print(jsonObject.toString());
				out.flush();
				
				
				
			}catch(Exception e){
				e.printStackTrace();
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
		
	}

}
