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

@WebServlet("/generalSettingsServletLan0")
public class GeneralSettingsServletLan0 extends HttpServlet {
	
	final static Logger logger = Logger.getLogger(GeneralSettingsServletLan0.class);
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		String check_role = (String) session.getAttribute("role");
		if (check_username != null) {
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();
			JSONObject jsonObject = new JSONObject();			
			try {
				json.put("operation", "genral_settings");
				json.put("operation_type", "get");
				json.put("user", check_username);
				json.put("token", check_token);
				json.put("interface", "lan0");
				json.put("role", check_role);
				
				String respStr = client.sendMessage(json.toString());
				JSONObject respJson = new JSONObject(respStr);
				logger.info("res " + respJson.toString());
				for (int i = 0; i < respJson.length(); i++) {					
					String input = respJson.getString("input");
					String rule_drop = respJson.getString("rule_drop");				
					try {					
						jsonObject.put("input", input);
						jsonObject.put("rule_drop", rule_drop);						
					} catch (Exception e) {
						e.printStackTrace();
						logger.error("Error in general settings in json object: " + e);
						}					
				}				
				 response.setHeader("X-Content-Type-Options", "nosniff");
				PrintWriter out = response.getWriter();
				out.print(jsonObject.toString());
				out.flush();
			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error in getting general settings data : " + e);
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
		String input = null;	
		String rule_drop = null;
		if (check_username != null) {
			String operation_action = request.getParameter("operation_action_lan0");
			if (operation_action != null) {
				switch (operation_action) {
				case "update":
					 input = request.getParameter("input");			 
					 rule_drop = request.getParameter("rule_drop");
					try {
						if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();
						json.put("operation", "genral_settings");
						json.put("operation_type", "update");
						json.put("input", input);				
						json.put("rule_drop", rule_drop);
						json.put("user", check_username);
						json.put("token", check_token);
						json.put("interface", "lan0");
						json.put("role", check_role);
						
						String respStr = client.sendMessage(json.toString());
						logger.info("res " + new JSONObject(respStr));
						String message = new JSONObject(respStr).getString("msg");
						JSONObject jsonObject = new JSONObject();
						jsonObject.put("message", message);
						response.setContentType("application/json");
						response.setHeader("X-Content-Type-Options", "nosniff");
						PrintWriter out = response.getWriter();
						out.print(jsonObject.toString());
						out.flush();
						}else {
							logger.error("Token validation failed");	
						}
					} catch (Exception e) {
						e.printStackTrace();
						logger.error("Error in updating general settings : " + e);
					}
					break;
			}
		} 
	}
	}
}