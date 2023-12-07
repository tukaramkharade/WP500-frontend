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

@WebServlet("/OPCUAClientServlet")
public class OPCUAClientServlet extends HttpServlet {
	final static Logger logger = Logger.getLogger(OPCUAClientServlet.class);
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		TCPClient client = new TCPClient();
		JSONObject json = new JSONObject();
		
		try {
			
			HttpSession session = request.getSession(false);

			String check_username = (String) session.getAttribute("username");
			String check_token = (String) session.getAttribute("token");
			
			if (check_username != null) {
				
				json.put("operation", "get_opc_client_settings");
				json.put("user", check_username);
				json.put("token", check_token);
				
				String respStr = client.sendMessage(json.toString());
				JSONObject respJson = new JSONObject(respStr);

				String status = respJson.getString("status");
				String message = respJson.getString("msg");
				
				logger.info(respJson.toString());

				JSONObject finalJsonObj = new JSONObject();
				if(status.equals("success")){
					JSONArray jsonArray = respJson.getJSONArray("data");
					finalJsonObj.put("status", status);
				    finalJsonObj.put("result", jsonArray);
				}else if(status.equals("fail")){
					finalJsonObj.put("status", status);
				    finalJsonObj.put("message", message);
				}

			    // Set the response content type to JSON
			    response.setContentType("application/json");

			    // Write the JSON data to the response
			    response.getWriter().print(finalJsonObj.toString());
			}
			
	}catch (Exception e) {
		e.printStackTrace();
		logger.error("Error in getting mqtt data: " + e);
	}
} 

			

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		HttpSession session = request.getSession(false);
		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");

		String endUrl = null;
		String Username = null;
		String Password = null;
		String Security = null;
		String ActionType = null;
		String prefix = null;
		
		if (check_username != null) {
			
			String action = request.getParameter("action");
			
			if (action != null) {
				switch (action) {
				
				case "add":
					
					endUrl = request.getParameter("endURL");
					Username = request.getParameter("username");
					Password = request.getParameter("password");
					Security = request.getParameter("security");
					ActionType = request.getParameter("actionType");
					prefix = request.getParameter("prefix");
					
					try{
						
						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();

						json.put("operation", "add_opc_client_settings");
						json.put("user", check_username);
						json.put("token", check_token);
						JSONObject json_data = new JSONObject();
						
						json_data.put("endUrl", endUrl);
						json_data.put("Username", Username);
						json_data.put("Password", Password);
						json_data.put("Security", Security);
						json_data.put("ActionType", ActionType);
						json_data.put("prefix", prefix);
						
						json.put("data", json_data);

						String respStr = client.sendMessage(json.toString());
						System.out.println("res " + new JSONObject(respStr));

						//logger.info("res " + new JSONObject(respStr).getString("msg"));

						String message = new JSONObject(respStr).getString("msg");
						JSONObject jsonObject = new JSONObject();
						jsonObject.put("message", message);

						// Set the content type of the response to application/json
						response.setContentType("application/json");

						// Get the response PrintWriter
						PrintWriter out = response.getWriter();

						// Write the JSON object to the response
						out.print(jsonObject.toString());
						out.flush();
						
						
					}catch(Exception e){
						e.printStackTrace();
						logger.error("Error in adding OPCUA client : " + e);
					}
					break;
					
				case "update":
					
					endUrl = request.getParameter("endURL");
					System.out.println("endurl : "+endUrl);
					Username = request.getParameter("username");
					Password = request.getParameter("password");
					Security = request.getParameter("security");
					ActionType = request.getParameter("actionType");
					prefix = request.getParameter("prefix");
					
					try{
						
						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();

						json.put("operation", "update_opc_client_settings");
						json.put("user", check_username);
						json.put("token", check_token);
						
						JSONObject json_data = new JSONObject();
						
						json_data.put("endUrl", endUrl);
						json_data.put("Username", Username);
						json_data.put("Password", Password);
						json_data.put("Security", Security);
						json_data.put("ActionType", ActionType);
						json_data.put("prefix", prefix);
						
						json.put("data", json_data);

						String respStr = client.sendMessage(json.toString());
						System.out.println("res " + new JSONObject(respStr));

						//logger.info("res " + new JSONObject(respStr).getString("msg"));

						String message = new JSONObject(respStr).getString("msg");
						JSONObject jsonObject = new JSONObject();
						jsonObject.put("message", message);

						// Set the content type of the response to application/json
						response.setContentType("application/json");

						// Get the response PrintWriter
						PrintWriter out = response.getWriter();

						// Write the JSON object to the response
						out.print(jsonObject.toString());
						out.flush();
						
						
					}catch(Exception e){
						e.printStackTrace();
						logger.error("Error in adding OPCUA client : " + e);
					}
					break;
					
				case "delete":
					
					prefix = request.getParameter("prefix");
					
					try{
						
						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();
						
						json.put("operation", "delete_opc_client_settings");
						json.put("user", check_username);
						json.put("prefix", prefix);
						json.put("token", check_token);
						
						String respStr = client.sendMessage(json.toString());

						logger.info("res " + new JSONObject(respStr).getString("msg"));

						String message = new JSONObject(respStr).getString("msg");
						JSONObject jsonObject = new JSONObject();
						jsonObject.put("message", message);

						// Set the content type of the response to application/json
						response.setContentType("application/json");

						// Get the response PrintWriter
						PrintWriter out = response.getWriter();

						// Write the JSON object to the response
						out.print(jsonObject.toString());
						out.flush();
						
					}catch(Exception e){
						e.printStackTrace();
						logger.error("Error in deleting opcua client : " + e);
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

}
