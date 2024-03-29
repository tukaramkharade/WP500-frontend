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

@WebServlet("/syslogStatus")
public class SyslogStatus extends HttpServlet {
	final static Logger logger = Logger.getLogger(SyslogStatus.class);

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		String check_role = (String) session.getAttribute("role");
		String csrfTokenFromRequest = request.getParameter("csrfToken");
		String csrfTokenFromSession = (String) session.getAttribute("csrfToken");
		if (check_username != null) {
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();
			JSONObject jsonObject = new JSONObject();
			try {
				if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
					json.put("operation", "rsyslog_manager");
					json.put("operation_type", "get_rsyslog_status");
					json.put("user", check_username);
					json.put("token", check_token);
					json.put("role", check_role);

					String respStr = client.sendMessage(json.toString());
					JSONObject respJson = new JSONObject(respStr);
					logger.info("res " + respJson.toString());
					for (int i = 0; i < respJson.length(); i++) {
						String rsyslog_status = respJson.getString("rsyslog_status");
						try {
							jsonObject.put("rsyslog_status", rsyslog_status);
						} catch (Exception e) {
							e.printStackTrace();
							logger.error("Error in putting syslog status in json object: " + e);
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
				logger.error("Error in getting syslog config data : " + e);
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
		String syslog_status = null;
		if (check_username != null) {
			syslog_status = request.getParameter("status");
			try {
				if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
					TCPClient client = new TCPClient();
					JSONObject json = new JSONObject();
					json.put("operation", "rsyslog_manager");
					json.put("operation_type", "update_rsyslog_status");
					json.put("rsyslog_status", syslog_status);
					json.put("user", check_username);
					json.put("token", check_token);
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
				} else {
					logger.error("Token validation failed");
				}
			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error in updating general settings : " + e);
			}
		}
	}
}