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

@WebServlet("/ResetPasswordPolicyServlet")
public class ResetPasswordPolicyServlet extends HttpServlet {
	final static Logger logger = Logger.getLogger(ResetPasswordPolicyServlet.class);

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		String check_role = (String) session.getAttribute("role");
		if (check_username != null) {
			try {
				TCPClient client = new TCPClient();
				JSONObject json = new JSONObject();
				json.put("operation", "password_policy");
				json.put("operation_type", "reset_password");
				json.put("user", check_username);
				json.put("token", check_token);
				json.put("role", check_role);

				String respStr = client.sendMessage(json.toString());
				logger.info("res " + new JSONObject(respStr));
				String message = new JSONObject(respStr).getString("message");
				String status = new JSONObject(respStr).getString("status");
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("message", message);
				jsonObject.put("status", status);
				response.setContentType("application/json");
				response.setHeader("X-Content-Type-Options", "nosniff");
				PrintWriter out = response.getWriter();
				out.print(jsonObject.toString());
				out.flush();
			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error in applying traffic rules : " + e);
			}
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	}
}