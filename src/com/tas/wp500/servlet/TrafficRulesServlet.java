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
import org.json.JSONException;
import org.json.JSONObject;

import com.tas.wp500.utils.TCPClient;

@WebServlet("/trafficRulesServlet")
public class TrafficRulesServlet extends HttpServlet {
	final static Logger logger = Logger.getLogger(TrafficRulesServlet.class);

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");

		if (check_username != null) {

			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();

			try {
				json.put("operation", "firewall_settings");
				json.put("user", check_username);
				json.put("token", check_token);
				
				String respStr = client.sendMessage(json.toString());

				JSONObject respJson = new JSONObject(respStr);

				JSONArray resJsonArray = new JSONArray();

				logger.info("Traffic Rules response : " + respJson.toString());

				JSONArray ip_tables = respJson.getJSONArray("ip_tables");

				for (int i = 0; i < ip_tables.length(); i++) {

					JSONObject jsObj = ip_tables.getJSONObject(i);
					String name = jsObj.getString("name");
					String iface = jsObj.getString("iface");
					String protocol = jsObj.getString("protocol");
					String macAddress = jsObj.getString("macAddress");
					String portNum = jsObj.getString("portNum");
					String ipAddress = jsObj.getString("ipAddress");
					String action = jsObj.getString("action");
					String type = jsObj.getString("type");

					JSONObject firewallObj = new JSONObject();
					try {

						firewallObj.put("name", name);
						firewallObj.put("iface", iface);
						firewallObj.put("protocol", protocol);
						firewallObj.put("macAddress", macAddress);
						firewallObj.put("portNum", portNum);
						firewallObj.put("ipAddress", ipAddress);
						firewallObj.put("action", action);
						firewallObj.put("type", type);

						resJsonArray.put(firewallObj);
					} catch (JSONException e) {
						e.printStackTrace();
						logger.error("Error in putting traffic rules data in json array : " + e);
					}
				}

				logger.info("JSON ARRAY :" + resJsonArray.length() + " " + resJsonArray.toString());
				// Set the response content type to JSON
				response.setContentType("application/json");

				// Write the JSON data to the response
				response.getWriter().print(resJsonArray.toString());

			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error in getting traffic rules data: " + e);
			}
		} else {
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
				logger.error("Error in session timeout : " + e);
			}
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);

		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		
		String name = null;
		String iface = null;
		String portNumber = null;
		String macAddress = null;
		String protocol = null;
		String ip_addr = null;
		String type = null;
		String action = null;
		
		if (check_username != null) {
			
			String operation_action = request.getParameter("operation_action");

			if (operation_action != null) {
				switch (operation_action) {
				
				case "add":
					name = request.getParameter("name");
					 iface = request.getParameter("iface");
					 portNumber = request.getParameter("portNumber");
					 macAddress = request.getParameter("macAddress");
					 protocol = request.getParameter("protocol");
					 ip_addr = request.getParameter("ip_addr");
					 type = request.getParameter("type");
					 action = request.getParameter("action");

					 
					 System.out.println("action : "+action);
					try {
						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();

						json.put("operation", "ip_tables");
						json.put("operation_type", "add_ip");
						json.put("user", check_username);
						json.put("name", name);
						json.put("interface", iface);
						json.put("protocol", protocol);
						json.put("ipAddress", ip_addr);
						json.put("macAddress", macAddress);
						json.put("portNum", portNumber);
						json.put("action", action);
						json.put("type", type);
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

					} catch (Exception e) {
						e.printStackTrace();
						logger.error("Error in adding traffic rules : " + e);
					}
					
					break;
					
				case "update":
					 name = request.getParameter("name");
					 iface = request.getParameter("iface");
					 portNumber = request.getParameter("portNumber");
					 macAddress = request.getParameter("macAddress");
					 protocol = request.getParameter("protocol");
					 ip_addr = request.getParameter("ip_addr");
					 type = request.getParameter("type");
					 action = request.getParameter("action");

					try {
						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();

						json.put("operation", "ip_tables");
						json.put("operation_type", "update_ip");
						json.put("user", check_username);
						json.put("name", name);
						json.put("interface", iface);
						json.put("protocol", protocol);
						json.put("ipAddress", ip_addr);
						json.put("macAddress", macAddress);
						json.put("portNum", portNumber);
						json.put("action", action);
						json.put("type", type);
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

					} catch (Exception e) {
						e.printStackTrace();
						logger.error("Error in updating traffic rules : " + e);
					}
					
					break;
					
					
				case "delete":
					 name = request.getParameter("name");

					try {
						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();

						json.put("operation", "ip_tables");
						json.put("operation_type", "delete_ip");
						json.put("user", check_username);
						json.put("name", name);
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

					} catch (Exception e) {
						e.printStackTrace();
						logger.error("Error in deleting traffic rules : " + e);
					}
					
					break;		
				}
				} 
		} else {
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
