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

@WebServlet("/trafficRulesServletLan0")
public class TrafficRulesServletLan0 extends HttpServlet {
	final static Logger logger = Logger.getLogger(TrafficRulesServletLan0.class);
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		HttpSession session = request.getSession(false);
		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		String check_role = (String) session.getAttribute("role");

		if (check_username != null) {

			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();

			try {
				json.put("operation", "firewall_settings");
				json.put("user", check_username);
				json.put("token", check_token);
				json.put("role", check_role);
				
				String respStr = client.sendMessage(json.toString());

				JSONObject respJson = new JSONObject(respStr);
				String status = respJson.getString("status");
				String message = respJson.getString("msg");

				logger.info("Traffic Rules response : " + respJson.toString());

				JSONObject finalJsonObj = new JSONObject();
				if(status.equals("success")){
					JSONArray ip_tables = respJson.getJSONArray("ip_tables");
					finalJsonObj.put("status", status);
				    finalJsonObj.put("result", ip_tables);
				}else if(status.equals("fail")){
					finalJsonObj.put("status", status);
				    finalJsonObj.put("message", message);
				}

			    // Set the response content type to JSON
			    response.setContentType("application/json");
			    response.setHeader("X-Content-Type-Options", "nosniff");

			    // Write the JSON data to the response
			    response.getWriter().print(finalJsonObj.toString());

				} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error in getting traffic rules data: " + e);
			}
		} 

	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);

		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		String check_role = (String) session.getAttribute("role");
		
		String csrfTokenFromRequest = request.getParameter("csrfToken");

		// Retrieve CSRF token from the session
		String csrfTokenFromSession = (String) session.getAttribute("csrfToken");
		
		String name = null;
		String portNumber = null;
		String macAddress = null;
		String protocol = null;
		String ip_addr = null;
		String type = null;
		String action = null;
		
		if (check_username != null) {
			
			String operation_action = request.getParameter("operation_action_lan0");

			if (operation_action != null) {
				switch (operation_action) {
				
				case "add":
					name = request.getParameter("name");
					 portNumber = request.getParameter("portNumber");
					 macAddress = request.getParameter("macAddress");
					 protocol = request.getParameter("protocol");
					 ip_addr = request.getParameter("ip_addr");
					 type = request.getParameter("type");
					 action = request.getParameter("action");

					try {
						
						if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();

						json.put("operation", "ip_tables");
						json.put("operation_type", "add_ip");
						json.put("user", check_username);
						json.put("name", name);
						json.put("interface", "lan0");
						json.put("protocol", protocol);
						json.put("ipAddress", ip_addr);
						json.put("macAddress", macAddress);
						json.put("portNum", portNumber);
						json.put("action", action);
						json.put("type", type);
						json.put("token", check_token);
						json.put("role", check_role);

						String respStr = client.sendMessage(json.toString());

						logger.info("res " + new JSONObject(respStr));

						String message = new JSONObject(respStr).getString("msg");
						String status = new JSONObject(respStr).getString("status");
						
						JSONObject jsonObject = new JSONObject();
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
						}else {
							logger.error("CSRF token validation failed");	
						}
					} catch (Exception e) {
						e.printStackTrace();
						logger.error("Error in adding traffic rules : " + e);
					}
					
					break;
					
				case "update":
					 name = request.getParameter("name");
					 portNumber = request.getParameter("portNumber");
					 macAddress = request.getParameter("macAddress");
					 protocol = request.getParameter("protocol");
					 ip_addr = request.getParameter("ip_addr");
					 type = request.getParameter("type");
					 action = request.getParameter("action");

					try {
						if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();

						json.put("operation", "ip_tables");
						json.put("operation_type", "update_ip");
						json.put("user", check_username);
						json.put("name", name);
						json.put("interface", "lan0");
						json.put("protocol", protocol);
						json.put("ipAddress", ip_addr);
						json.put("macAddress", macAddress);
						json.put("portNum", portNumber);
						json.put("action", action);
						json.put("type", type);
						json.put("token", check_token);
						json.put("role", check_role);
						
						String respStr = client.sendMessage(json.toString());

						logger.info("res " + new JSONObject(respStr));

						String message = new JSONObject(respStr).getString("msg");
						String status = new JSONObject(respStr).getString("status");
						
						JSONObject jsonObject = new JSONObject();
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
						}else {
							logger.error("CSRF token validation failed");	
						}
					} catch (Exception e) {
						e.printStackTrace();
						logger.error("Error in updating traffic rules : " + e);
					}
					
					break;
					
					
				case "delete":
					 name = request.getParameter("name");

					try {
						if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();

						json.put("operation", "ip_tables");
						json.put("operation_type", "delete_ip");
						json.put("user", check_username);
						json.put("name", name);
						json.put("token", check_token);
						json.put("role", check_role);
						
						String respStr = client.sendMessage(json.toString());

						logger.info("res " + new JSONObject(respStr));

						String message = new JSONObject(respStr).getString("msg");
						String status = new JSONObject(respStr).getString("status");
						
						JSONObject jsonObject = new JSONObject();
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
						}else {
							logger.error("CSRF token validation failed");	
						}
					} catch (Exception e) {
						e.printStackTrace();
						logger.error("Error in deleting traffic rules : " + e);
					}
					
					break;		
				}
				} 
		} 
	}

}
