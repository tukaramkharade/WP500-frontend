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
import org.json.JSONException;
import org.json.JSONObject;
import com.tas.wp500.utils.TCPClient;

@WebServlet("/WP500Login")
public class WP500Login extends HttpServlet {
	final static Logger logger = Logger.getLogger(WP500Login.class);

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession();
		session.setMaxInactiveInterval(3600);
		String csrfTokenFromRequest = request.getParameter("csrfToken");
		String csrfTokenFromSession = (String) session.getAttribute("csrfToken");
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		JSONObject userObj = new JSONObject();
		try {
			if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
				int loginAttempts = (int) session.getAttribute("loginAttempts");
				session.setAttribute("loginAttempts", loginAttempts + 1);
				int maxLoginAttempts = 5;
				if (loginAttempts >= maxLoginAttempts) {
					session.setAttribute("blockedUser", System.currentTimeMillis() + (5 * 60 * 1000)); // 5 minutes
					userObj.put("status", "blocked");
					userObj.put("msg",
							"You have reached the maximum number of login attempts. User is blocked for 5 minutes.");
				} else {

					TCPClient client = new TCPClient();
					JSONObject json = new JSONObject();
					json.put("operation", "login");
					json.put("username", username);
					json.put("password", password);
					json.put("hardCorePassword", "S3cureP@ss!2024");

					String respStr = client.sendMessage(json.toString());
					logger.info("Response: " + respStr);
					JSONObject jsonResponse = new JSONObject(respStr);
					String status = jsonResponse.getString("status");
					String first_login = jsonResponse.getString("first_login");
					String totp_authenticator = jsonResponse.getString("totp_authenticator");
					if (status.equals("success") && first_login.equals("true")
							&& totp_authenticator.equals("disable")) {
						String role = jsonResponse.getString("role");
						session.setAttribute("username", username);
						session.setAttribute("first_login", first_login);
						session.setAttribute("role", role);
						userObj.put("status", status);
						userObj.put("first_login", first_login);
					} else if (status.equals("success") && first_login.equals("false")
							&& totp_authenticator.equals("enable")) {
						String role = jsonResponse.getString("role");
						session.setAttribute("username", username);
						session.setAttribute("role", role);
						session.setAttribute("totp_authenticator", totp_authenticator);
						session.setAttribute("first_login", first_login);
						userObj.put("status", status);
						userObj.put("first_login", first_login);
						userObj.put("totp_authenticator", totp_authenticator);
					} else if (status.equals("success") && first_login.equals("false")
							&& totp_authenticator.equals("disable")) {
						String role = jsonResponse.getString("role");
						String token = jsonResponse.getString("token");
						session.setAttribute("username", username);
						session.setAttribute("role", role);
						session.setAttribute("token", token);
						session.setAttribute("first_login", first_login);
						userObj.put("status", status);
						userObj.put("first_login", first_login);
						userObj.put("totp_authenticator", totp_authenticator);
					} 
						else if (status.equals("fail")) {
						userObj.put("msg", "Invalid user. Please login again");
						userObj.put("status", status);
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("Error in login : " + e);
			try {
				userObj.put("status", "error");
				userObj.put("msg", "Invalid user.");
			} catch (JSONException e1) {
				e1.printStackTrace();
			}
		}
		response.setContentType("application/json");
		response.setHeader("Content-Security-Policy", "script-src *;");
		response.setHeader("X-Content-Type-Options", "nosniff");
		PrintWriter out = response.getWriter();
		out.print(userObj.toString());
		out.flush();
	}
}