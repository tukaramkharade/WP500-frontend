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

@WebServlet("/search_logs")
public class LogDataSearch extends HttpServlet {
	final static Logger logger = Logger.getLogger(LogDataSearch.class);

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		String check_role = (String) session.getAttribute("role");
		String csrfTokenFromRequest = request.getParameter("csrfToken");
		String csrfTokenFromSession = (String) session.getAttribute("csrfToken");
		if (check_username != null) {
			String fileName = request.getParameter("log_file");
			String search_query = request.getParameter("search_query");
			String log_type = "application";
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();
			try {
				if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
					json.put("operation", "get_log_file_data");
					json.put("user", check_username);
					json.put("token", check_token);
					json.put("log_type", log_type);
					json.put("file_name", fileName);
					json.put("search", search_query);
					json.put("role", check_role);

					String respStr = client.sendMessage(json.toString());
					logger.info("res " + new JSONObject(respStr));
					JSONObject result = new JSONObject(respStr);
					JSONArray log_search_result = result.getJSONArray("result");
					JSONObject jsonObject = new JSONObject();
					jsonObject.put("log_search_result", log_search_result);
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
				logger.error("Error in getting log search result : " + e);
			}
		}
	}
}