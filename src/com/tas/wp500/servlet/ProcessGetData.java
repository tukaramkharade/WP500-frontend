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

@WebServlet("/processGetData")
public class ProcessGetData extends HttpServlet {
	final static Logger logger = Logger.getLogger(ProcessGetData.class);

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		String check_role = (String) session.getAttribute("role");
		String csrfTokenFromRequest = request.getParameter("csrfToken");
		String csrfTokenFromSession = (String) session.getAttribute("csrfToken");
		String processType = request.getParameter("process_type");
		if (check_username != null) {
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();
			try {
				if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
					json.put("operation", "get_process_list");
					json.put("process_type", processType);
					json.put("user", check_username);
					json.put("token", check_token);
					json.put("role", check_role);

					String respStr = client.sendMessage(json.toString());
					logger.info("res " + new JSONObject(respStr));
					String status = new JSONObject(respStr).getString("status");
					System.out.println("status: " + status);
					String message = new JSONObject(respStr).getString("msg");
					JSONObject jsonObject = new JSONObject();
					if (status.equals("success")) {
						if (processType.equals("process_list")) {
							JSONObject white_list_process = new JSONObject(respStr);
							JSONObject black_list_process = new JSONObject(respStr);
							JSONArray white_list_process1 = white_list_process.getJSONArray("white_list_process");
							JSONArray black_list_process1 = black_list_process.getJSONArray("black_list_process");
							jsonObject.put("white_list_process", white_list_process1);
							jsonObject.put("black_list_process", black_list_process1);
							jsonObject.put("status", status);
						} else if (processType.equals("process_count")) {
							JSONObject black_list_process = new JSONObject(respStr);
							String black_list_process_count = black_list_process.getString("black_list_process");
							jsonObject.put("black_list_process_count", black_list_process_count);
							jsonObject.put("status", status);
						}
					} else if (status.equals("fail")) {
						jsonObject.put("status", status);
						jsonObject.put("message", message);
					}
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