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
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import com.tas.wp500.utils.IntervalMapper;
import com.tas.wp500.utils.TCPClient;

@WebServlet("/alarmConfigServlet")
public class AlarmConfigServlet extends HttpServlet {
	final static Logger logger = Logger.getLogger(AlarmConfigServlet.class);

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		String check_role = (String) session.getAttribute("role");
		String csrfTokenFromRequest = request.getParameter("csrfToken");
		String csrfTokenFromSession = (String) session.getAttribute("csrfToken");
		if (check_username != null) {
			try {
				if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
					TCPClient client = new TCPClient();
					JSONObject json = new JSONObject();
					json.put("operation", "protocol");
					json.put("protocol_type", "alarm");
					json.put("operation_type", "get_query");
					json.put("user", check_username);
					json.put("token", check_token);
					json.put("role", check_role);

					String respStr = client.sendMessage(json.toString());
					JSONObject respJson = new JSONObject(respStr);
					String status = respJson.getString("status");
					String message = respJson.getString("msg");
					JSONObject finalJsonObj = new JSONObject();
					if (status.equals("success")) {
						JSONObject alarm_result = respJson.getJSONObject("result");
						finalJsonObj.put("status", status);
						if (alarm_result.length() > 0 && alarm_result.has("intrval")) {
							String interval = alarm_result.getString("intrval");
							int intervalValue = Integer.parseInt(interval);
							String intervalString = IntervalMapper.getIntervalByValue(intervalValue);
							finalJsonObj.put("intervalString", intervalString);
						}
						finalJsonObj.put("result", alarm_result);
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
				logger.error("Error getting alarm");
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
		String unit_id = null;
		String asset_id = null;
		String broker_type = null;
		String broker_name = null;
		String interval = null;
		String alarm_status = null;
		String tagData = null;
		String intervalValue = null;

		JSONParser parser = new JSONParser();
		org.json.simple.JSONObject json_string_con = null;
		if (check_username != null) {
			String action = request.getParameter("action");
			if (action != null) {
				switch (action) {
				case "add":
					unit_id = request.getParameter("unit_id");
					asset_id = request.getParameter("asset_id");
					broker_type = request.getParameter("broker_type");
					broker_name = request.getParameter("broker_name");
					interval = request.getParameter("interval");
					alarm_status = request.getParameter("status");
					tagData = request.getParameter("tagData");
					intervalValue = IntervalMapper.getIntervalByString(interval);
					try {
						json_string_con = (org.json.simple.JSONObject) parser.parse(tagData);
					} catch (ParseException e1) {
						e1.printStackTrace();
					}
					try {
						if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
							TCPClient client = new TCPClient();
							JSONObject json = new JSONObject();
							json.put("operation", "protocol");
							json.put("protocol_type", "alarm");
							json.put("operation_type", "add_query");
							json.put("id", "1");
							json.put("user", check_username);
							json.put("token", check_token);
							json.put("unit_id", unit_id);
							json.put("asset_id", asset_id);
							json.put("broker_type", broker_type);
							json.put("broker_ip", broker_name);
							json.put("intrval", intervalValue);
							json.put("alarm_status", alarm_status);
							json.put("alarm_tag", json_string_con);
							json.put("role", check_role);
							String respStr = client.sendMessage(json.toString());
							String message = new JSONObject(respStr).getString("msg");
							JSONObject jsonObject = new JSONObject();
							jsonObject.put("message", message);
							response.setContentType("application/json");
							PrintWriter out = response.getWriter();
							out.print(jsonObject.toString());
							out.flush();
						} else {
							logger.error("Token validation failed");
						}
					} catch (Exception e) {
						e.printStackTrace();
						logger.error("Error adding alarm");
					}
					break;

				case "update":
					unit_id = request.getParameter("unit_id");
					asset_id = request.getParameter("asset_id");
					broker_type = request.getParameter("broker_type");
					broker_name = request.getParameter("broker_name");
					interval = request.getParameter("interval");
					tagData = request.getParameter("tagData");
					alarm_status = request.getParameter("status");
					intervalValue = IntervalMapper.getIntervalByString(interval);
					try {
						json_string_con = (org.json.simple.JSONObject) parser.parse(tagData);
					} catch (ParseException e1) {
						e1.printStackTrace();
					}
					try {
						if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
							TCPClient client = new TCPClient();
							JSONObject json = new JSONObject();
							json.put("operation", "protocol");
							json.put("protocol_type", "alarm");
							json.put("operation_type", "update_query");
							json.put("user", check_username);
							json.put("token", check_token);
							json.put("id", "1");
							json.put("username", check_username);
							json.put("unit_id", unit_id);
							json.put("asset_id", asset_id);
							json.put("broker_type", broker_type);
							json.put("broker_ip", broker_name);
							json.put("intrval", intervalValue);
							json.put("alarm_status", alarm_status);
							json.put("alarm_tag", json_string_con);
							json.put("role", check_role);
							String respStr = client.sendMessage(json.toString());
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
						logger.error("Error updating alarm");
					}
					break;
				}
			}
		}
	}

	protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if (session != null) {
			String check_username = (String) session.getAttribute("username");
			String check_token = (String) session.getAttribute("token");
			String check_role = (String) session.getAttribute("role");
			try {
				TCPClient client = new TCPClient();
				JSONObject json = new JSONObject();
				json.put("operation", "protocol");
				json.put("protocol_type", "alarm");
				json.put("operation_type", "delete_query");
				json.put("id", "1");
				json.put("user", check_username);
				json.put("token", check_token);
				json.put("role", check_role);

				String respStr = client.sendMessage(json.toString());
				String message = new JSONObject(respStr).getString("msg");
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("message", message);
				response.setContentType("application/json");
				response.setHeader("X-Content-Type-Options", "nosniff");
				PrintWriter out = response.getWriter();
				out.print(jsonObject.toString());
				out.flush();
			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error deleting alarm");
			}
		}
	}
}