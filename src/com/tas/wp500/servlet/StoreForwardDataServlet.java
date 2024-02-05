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

@WebServlet("/storeForwardDataServlet")
public class StoreForwardDataServlet extends HttpServlet {
	final static Logger logger = Logger.getLogger(StoreForwardDataServlet.class);

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		try {
			HttpSession session = request.getSession(false);
			String check_username = (String) session.getAttribute("username");
			String check_token = (String) session.getAttribute("token");
			String check_role = (String) session.getAttribute("role");
			String csrfTokenFromRequest = request.getParameter("csrfToken");
			String csrfTokenFromSession = (String) session.getAttribute("csrfToken");
			if (check_username != null) {
				TCPClient client = new TCPClient();
				JSONObject json = new JSONObject();
				try {
					if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
						json.put("operation", "get_store_forword_data");
						json.put("user", check_username);
						json.put("token", check_token);
						json.put("page_no", "1");
						json.put("role", check_role);

						String respStr = client.sendMessage(json.toString());
						logger.info("res " + new JSONObject(respStr));
						JSONObject result = new JSONObject(respStr);
						String totalPage = result.getString("total_pages");
						String status = result.getString("status");
						String message = result.getString("msg");
						JSONObject finalJsonObj = new JSONObject();
						if (status.equals("success")) {
							JSONArray event_log_result = result.getJSONArray("result");
							finalJsonObj.put("status", status);
							finalJsonObj.put("result", event_log_result);
							finalJsonObj.put("total_page", totalPage);
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
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("Error in getting store forward data: " + e);
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		try {
			HttpSession session = request.getSession(false);
			String check_username = (String) session.getAttribute("username");
			String check_token = (String) session.getAttribute("token");
			String check_role = (String) session.getAttribute("role");
			String csrfTokenFromRequest = request.getParameter("csrfToken");
			String csrfTokenFromSession = (String) session.getAttribute("csrfToken");
			String currentPage = request.getParameter("currentPage");
			if (check_username != null) {
				TCPClient client = new TCPClient();
				JSONObject json = new JSONObject();
				try {
					if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
						json.put("operation", "get_store_forword_data");
						json.put("user", check_username);
						json.put("token", check_token);
						json.put("page_no", currentPage);
						json.put("role", check_role);
						String respStr = client.sendMessage(json.toString());
						logger.info("res " + new JSONObject(respStr));
						JSONObject result = new JSONObject(respStr);
						String totalPage = result.getString("total_pages");
						JSONArray event_log_result = result.getJSONArray("result");
						JSONObject jsonObject = new JSONObject();
						jsonObject.put("event_log_result", event_log_result);
						jsonObject.put("total_page", totalPage);
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
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("Error in getting store forward data: " + e);
		}
	}
}