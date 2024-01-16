package com.tas.wp500.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
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

		// Retrieve CSRF token from the request
		String csrfTokenFromRequest = request.getParameter("csrfToken");

		// Retrieve CSRF token from the session
		String csrfTokenFromSession = (String) session.getAttribute("csrfToken");

		System.out.println("csrf req: " + csrfTokenFromRequest);
		System.out.println("csrf session : " + csrfTokenFromSession);

		String username = request.getParameter("username");
		String password = request.getParameter("password");

		JSONObject userObj = new JSONObject();

		try {

			if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {

				TCPClient client = new TCPClient();
				JSONObject json = new JSONObject();

				json.put("operation", "login");
				json.put("username", username);
				json.put("password", password);

				String respStr = client.sendMessage(json.toString());

				logger.info("Response: " + respStr);

				JSONObject jsonResponse = new JSONObject(respStr);
				String status = jsonResponse.getString("status");
				String first_login = jsonResponse.getString("first_login");
				String totp_authenticator = jsonResponse.getString("totp_authenticator");

				if (status.equals("success") && first_login.equals("true") && totp_authenticator.equals("disable")) {
					
					session.setAttribute("username", username);
					
					userObj.put("status", status);
					userObj.put("first_login", first_login);
					
			
				} else if (status.equals("success") && first_login.equals("false")
						&& totp_authenticator.equals("enable")) {
					String role = jsonResponse.getString("role");
				

					session.setAttribute("username", username);
					session.setAttribute("role", role);
					session.setAttribute("totp_authenticator", totp_authenticator);
					

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

					userObj.put("status", status);
					userObj.put("first_login", first_login);
					userObj.put("totp_authenticator", totp_authenticator);
					
				
				}

				else if (status.equals("fail")) {
					userObj.put("msg", "Invalid user. Please login again");
					userObj.put("status", status);
				}

			} else {
				// CSRF token is invalid, reject the request
				userObj.put("status", "fail");
				userObj.put("msg", "CSRF token validation failed");
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

		
		// Set the content type of the response to application/json
		response.setContentType("application/json");
		
		response.setHeader("X-Content-Type-Options", "nosniff");


		// Get the response PrintWriter
		PrintWriter out = response.getWriter();

		// Write the JSON object to the response
		out.print(userObj.toString());
		out.flush();

	}
	


}

