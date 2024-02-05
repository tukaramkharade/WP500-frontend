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

@WebServlet("/trafficRulesServletLan2")
public class TrafficRulesServletLan2 extends HttpServlet {
	final static Logger logger = Logger.getLogger(TrafficRulesServletLan2.class);

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
				if (status.equals("success")) {
					JSONArray ip_tables = respJson.getJSONArray("ip_tables");
					finalJsonObj.put("status", status);
					finalJsonObj.put("result", ip_tables);
				} else if (status.equals("fail")) {
					finalJsonObj.put("status", status);
					finalJsonObj.put("message", message);
				}
				response.setContentType("application/json");
				response.setHeader("X-Content-Type-Options", "nosniff");
				response.getWriter().print(finalJsonObj.toString());
			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error in getting traffic rules data: " + e);
			}
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		String check_role = (String) session.getAttribute("role");
		String csrfTokenFromRequest = request.getParameter("csrfToken");
		String csrfTokenFromSession = (String) session.getAttribute("csrfToken");
		String name = null;
		String from_port = null;
		String to_port = null;
		String protocol = null;
		String from_ip_addr = null;
		String to_ip_addr = null;
		String action = null;
		if (check_username != null) {
			String operation_action = request.getParameter("operation_action_lan2");
			if (operation_action != null) {
				switch (operation_action) {
				case "add":
					name = request.getParameter("name");
					from_port = request.getParameter("from_port");
					to_port = request.getParameter("to_port");
					protocol = request.getParameter("protocol");
					from_ip_addr = request.getParameter("from_ip_addr");
					to_ip_addr = request.getParameter("to_ip_addr");
					action = request.getParameter("action");
					try {
						if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
							TCPClient client = new TCPClient();
							JSONObject json = new JSONObject();
							json.put("operation", "ip_tables");
							json.put("operation_type", "add_ip");
							json.put("user", check_username);
							json.put("name", name);
							json.put("iface", "lan2");
							json.put("protocol", protocol);
							json.put("fromIp", from_ip_addr);
							json.put("toIp", to_ip_addr);
							json.put("fromPort", from_port);
							json.put("toPort", to_port);
							json.put("action", action);
							json.put("token", check_token);
							json.put("role", check_role);

							String respStr = client.sendMessage(json.toString());
							logger.info("res " + new JSONObject(respStr));
							String message = new JSONObject(respStr).getString("msg");
							String status = new JSONObject(respStr).getString("status");
							JSONObject jsonObject = new JSONObject();
							jsonObject.put("message", message);
							jsonObject.put("status", status);
							response.setContentType("application/json");
							response.setHeader("X-Content-Type-Options", "nosniff");
							PrintWriter out = response.getWriter();
							out.print(jsonObject.toString());
							out.flush();
						} else {
							logger.error("Token validation failed");
						}
					} catch (Exception e) {
						e.printStackTrace();
						logger.error("Error in adding traffic rules : " + e);
					}
					break;

				case "update":
					name = request.getParameter("name");
					from_port = request.getParameter("from_port");
					to_port = request.getParameter("to_port");
					protocol = request.getParameter("protocol");
					from_ip_addr = request.getParameter("from_ip_addr");
					to_ip_addr = request.getParameter("to_ip_addr");
					action = request.getParameter("action");
					try {
						if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
							TCPClient client = new TCPClient();
							JSONObject json = new JSONObject();
							json.put("operation", "ip_tables");
							json.put("operation_type", "update_ip");
							json.put("user", check_username);
							json.put("name", name);
							json.put("iface", "lan2");
							json.put("protocol", protocol);
							json.put("fromIp", from_ip_addr);
							json.put("toIp", to_ip_addr);
							json.put("fromPort", from_port);
							json.put("toPort", to_port);
							json.put("action", action);
							json.put("token", check_token);
							json.put("role", check_role);

							String respStr = client.sendMessage(json.toString());
							logger.info("res " + new JSONObject(respStr));
							String message = new JSONObject(respStr).getString("msg");
							String status = new JSONObject(respStr).getString("status");
							JSONObject jsonObject = new JSONObject();
							jsonObject.put("message", message);
							jsonObject.put("status", status);
							response.setContentType("application/json");
							response.setHeader("X-Content-Type-Options", "nosniff");
							PrintWriter out = response.getWriter();
							out.print(jsonObject.toString());
							out.flush();
						} else {
							logger.error("Token validation failed");
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
							response.setContentType("application/json");
							response.setHeader("X-Content-Type-Options", "nosniff");
							PrintWriter out = response.getWriter();
							out.print(jsonObject.toString());
							out.flush();
						} else {
							logger.error("Token validation failed");
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
