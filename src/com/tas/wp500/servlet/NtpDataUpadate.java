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

import com.tas.wp500.utils.IntervalMapper;
import com.tas.wp500.utils.TCPClient;

@WebServlet("/ntpDataUpadate")
public class NtpDataUpadate extends HttpServlet {
	final static Logger logger = Logger.getLogger(Lan.class);

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if (session.getAttribute("username") != null) {
			String check_username = (String) session.getAttribute("username");
			String check_token = (String) session.getAttribute("token");
			String check_role = (String) session.getAttribute("role");
			String csrfTokenFromRequest = request.getParameter("csrfToken");
			String csrfTokenFromSession = (String) session.getAttribute("csrfToken");
			try {
				if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
					TCPClient client = new TCPClient();
					JSONObject json = new JSONObject();
					json.put("operation", "get_ethernet_details");
					json.put("user", check_username);
					json.put("token", check_token);
					json.put("role", check_role);

					String respStr = client.sendMessage(json.toString());
					logger.info("res " + new JSONObject(respStr));
					JSONObject result = new JSONObject(respStr);
					String status = result.getString("status");
					String message = result.getString("msg");
					JSONObject ntp = result.getJSONObject("ntp_setting");
					String ntp_server1 = ntp.getString("ntp_server1");
					String ntp_server2 = ntp.getString("ntp_server2");
					String ntp_server3 = ntp.getString("ntp_server3");
					String ntp_interval = ntp.getString("ntp_interval");
					int intervalValue = Integer.parseInt(ntp_interval);
					String ntpIntervalString = IntervalMapper.getIntervalByValue(intervalValue);
					JSONObject jsonObject = new JSONObject();
					jsonObject.put("ntp_server1", ntp_server1);
					jsonObject.put("ntp_server2", ntp_server2);
					jsonObject.put("ntp_server3", ntp_server3);
					jsonObject.put("ntp_interval", ntpIntervalString);
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
		if (check_username != null) {
			String ntpIntervalValue = null;
			String ntp_server1 = request.getParameter("ntp_server1");
			String ntp_server2 = request.getParameter("ntp_server2");
			String ntp_server3 = request.getParameter("ntp_server2");
			String ntp_interval = request.getParameter("ntp_interval");
			ntpIntervalValue = IntervalMapper.getIntervalByString(ntp_interval);
			try {
				if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
					TCPClient client = new TCPClient();
					JSONObject json = new JSONObject();
					json.put("operation", "update_lan_setting");
					json.put("lan_type", "ntp");
					json.put("user", check_username);
					json.put("ntp_server1", ntp_server1);
					json.put("ntp_server2", ntp_server2);
					json.put("ntp_server3", ntp_server3);
					json.put("ntp_interval", ntpIntervalValue);
					json.put("token", check_token);
					json.put("role", check_role);

					String respStr = client.sendMessage(json.toString());
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
			}
		}
	}
}