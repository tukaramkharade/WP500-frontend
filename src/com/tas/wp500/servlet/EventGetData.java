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

@WebServlet("/loadEventData")
public class EventGetData extends HttpServlet {
	final static Logger logger = Logger.getLogger(EventGetData.class);
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {		
		HttpSession session = request.getSession(false);
		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		String check_role = (String) session.getAttribute("role");		
		if (check_username != null) {		
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();
			try {
				json.put("operation", "get_event_data");
				 json.put("user", check_username);
				 json.put("token", check_token);
				json.put("page_no", "1");
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
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		HttpSession session = request.getSession(false);
		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		String check_role = (String) session.getAttribute("role");
		if (check_username != null) {
			String currentPage = request.getParameter("currentPage");
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();
			try {
				json.put("operation", "get_event_data");
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
			} catch (Exception e) {
				e.printStackTrace();
			}
		} 
	}
}