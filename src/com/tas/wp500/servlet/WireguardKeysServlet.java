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

@WebServlet("/wireguardKeysServlet")
public class WireguardKeysServlet extends HttpServlet {

	final static Logger logger = Logger.getLogger(WireguardKeysServlet.class);

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		String check_role = (String) session.getAttribute("role");
		String csrfTokenFromRequest = request.getParameter("csrfToken");
		String csrfTokenFromSession = (String) session.getAttribute("csrfToken");
		if (check_username != null) {
			String action = request.getParameter("action");
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();
			JSONObject jsonObject = new JSONObject();
			if (action != null) {
				switch (action) {
				case "get":
					try {
						if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
							json.put("operation", "get_wireguard_keys");
							json.put("user", check_username);
							json.put("token", check_token);
							json.put("role", check_role);

							String respStr = client.sendMessage(json.toString());
							logger.info("res " + new JSONObject(respStr));
							JSONObject respJson = new JSONObject(respStr);
							for (int i = 0; i < respJson.length(); i++) {
								String message = respJson.getString("msg");
								String public_key = respJson.getString("public_key");
								String private_key = respJson.getString("private_key");
								String status = respJson.getString("status");
								try {
									jsonObject.put("message", message);
									jsonObject.put("public_key", public_key);
									jsonObject.put("private_key", private_key);
									jsonObject.put("status", status);
								} catch (Exception e) {
									e.printStackTrace();
									logger.error("Error in wireguard keys in json object :" + e);
								}
							}
							response.setHeader("X-Content-Type-Options", "nosniff");
							PrintWriter out = response.getWriter();
							out.print(jsonObject.toString());
							out.flush();
						} else {
							logger.error("Token validation failed");
						}
					} catch (Exception e) {
						e.printStackTrace();
						logger.error("Error in getting keys: " + e);
					}
					break;

				case "generate_keys":
					try {
						if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
							json.put("operation", "genrate_wireguard_keys");
							json.put("user", check_username);
							json.put("token", check_token);
							json.put("role", check_role);

							String respStr = client.sendMessage(json.toString());
							logger.info("res " + new JSONObject(respStr));
							JSONObject respJson = new JSONObject(respStr);
							for (int i = 0; i < respJson.length(); i++) {
								String message = respJson.getString("msg");
								String public_key = respJson.getString("public_key");
								String private_key = respJson.getString("private_key");
								String status = respJson.getString("status");
								try {
									jsonObject.put("message", message);
									jsonObject.put("public_key", public_key);
									jsonObject.put("private_key", private_key);
									jsonObject.put("status", status);
								} catch (Exception e) {
									e.printStackTrace();
									logger.error("Error in wireguard keys in json object :" + e);
								}
							}
							response.setHeader("X-Content-Type-Options", "nosniff");
							PrintWriter out = response.getWriter();
							out.print(jsonObject.toString());
							out.flush();
						} else {
							logger.error("Token validation failed");
						}
					} catch (Exception e) {
						e.printStackTrace();
						logger.error("Error in generating keys: " + e);
					}
					break;

				case "activate_wireguard":
					try {
						if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
							json.put("operation", "activate_wireguard");
							json.put("user", check_username);
							json.put("token", check_token);
							json.put("role", check_role);

							String respStr = client.sendMessage(json.toString());
							logger.info("res " + new JSONObject(respStr));
							JSONObject respJson = new JSONObject(respStr);
							String message = respJson.getString("msg");
							String status = respJson.getString("status");
							JSONObject finalJsonObj = new JSONObject();
							if (status.equals("success")) {
								JSONArray activate_wireguard_result = respJson.getJSONArray("result");
								finalJsonObj.put("status", status);
								finalJsonObj.put("activate_wireguard_result", activate_wireguard_result);
							} else if (status.equals("fail")) {
								finalJsonObj.put("status", status);
								finalJsonObj.put("message", message);
							}
							response.setContentType("application/json");
							response.setHeader("X-Content-Type-Options", "nosniff");
							response.getWriter().print(finalJsonObj.toString());
						} else {
							logger.error("Token validation failed");
						}
					} catch (Exception e) {
						e.printStackTrace();
						logger.error("Error in activating wireguard: " + e);
					}
					break;

				case "deactivate_wireguard":
					try {
						if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
							json.put("operation", "deactivate_wireguard");
							json.put("user", check_username);
							json.put("token", check_token);
							json.put("role", check_role);

							String respStr = client.sendMessage(json.toString());
							logger.info("res " + new JSONObject(respStr));
							JSONObject respJson = new JSONObject(respStr);
							String message = respJson.getString("msg");
							String status = respJson.getString("status");
							JSONObject finalJsonObj = new JSONObject();
							if (status.equals("success")) {
								JSONArray deactivate_wireguard_result = respJson.getJSONArray("result");
								finalJsonObj.put("status", status);
								finalJsonObj.put("deactivate_wireguard_result", deactivate_wireguard_result);
							} else if (status.equals("fail")) {
								finalJsonObj.put("status", status);
								finalJsonObj.put("message", message);
							}
							response.setContentType("application/json");
							response.setHeader("X-Content-Type-Options", "nosniff");
							response.getWriter().print(finalJsonObj.toString());
						} else {
							logger.error("Token validation failed");
						}
					} catch (Exception e) {
						e.printStackTrace();
						logger.error("Error in deactivating wireguard: " + e);
					}
					break;

				case "wireguard_status":
					try {
						if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
							json.put("operation", "get_wireguard_info");
							json.put("user", check_username);
							json.put("token", check_token);
							json.put("role", check_role);

							String respStr = client.sendMessage(json.toString());
							logger.info("res " + new JSONObject(respStr));
							JSONObject respJson = new JSONObject(respStr);
							String message = respJson.getString("msg");
							String status = respJson.getString("status");
							JSONObject finalJsonObj = new JSONObject();
							if (status.equals("success")) {
								JSONArray wireguard_status_result = respJson.getJSONArray("wireguard_info");
								finalJsonObj.put("status", status);
								finalJsonObj.put("wireguard_status_result", wireguard_status_result);
							} else if (status.equals("fail")) {
								finalJsonObj.put("status", status);
								finalJsonObj.put("message", message);
							}
							response.setContentType("application/json");
							response.setHeader("X-Content-Type-Options", "nosniff");
							response.getWriter().print(finalJsonObj.toString());
						} else {
							logger.error("Token validation failed");
						}
					} catch (Exception e) {
						e.printStackTrace();
						logger.error("Error in getting wireguard info: " + e);
					}
					break;
				}
			}
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	}
}