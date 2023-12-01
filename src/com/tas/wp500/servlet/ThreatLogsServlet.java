package com.tas.wp500.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

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

@WebServlet("/threatLogsServlet")
public class ThreatLogsServlet extends HttpServlet {
	final static Logger logger = Logger.getLogger(ThreatLogsServlet.class);

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");

		if (check_username != null) {

			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();

			try {

				json.put("operation", "get_threat_logs");
				json.put("user", check_username);
				json.put("token", check_token);
				
				String respStr = client.sendMessage(json.toString());

				JSONObject respJson = new JSONObject(respStr);

				JSONArray resJsonArray = new JSONArray();

				logger.info("Threat Logs response : " + respJson.toString());

				JSONArray resultArr = respJson.getJSONArray("data");

				for (int i = 0; i < resultArr.length(); i++) {
					JSONObject jsObj = resultArr.getJSONObject(i);
					String src_ip = null;
					if (jsObj.has("src_ip")) {
						src_ip = jsObj.getString("src_ip");
						System.out.println("src ip: " + src_ip);
					} else {
						System.out.println("src ip not found in JSON object.");
					}

					int src_port = jsObj.getInt("src_port");
					String protocol_type = null;
					if (jsObj.has("protocol_type")) {
						protocol_type = jsObj.getString("protocol_type");
						System.out.println("protocol_type ip: " + protocol_type);
					} else {
						System.out.println("protocol type not found in JSON object.");
					}
					String ack_at = jsObj.getString("ack_at");
					String ack_by = jsObj.getString("ack_by");
					// String alert_message = jsObj.getString("alert_message");
					String alert_message = null;
					if (jsObj.has("alert_message")) {
						alert_message = jsObj.getString("alert_message");
						System.out.println("alert message : " + alert_message);
					} else {
						System.out.println("alert message not found in JSON object.");
					}

					// String dest_ip = jsObj.getString("dest_ip");
					String dest_ip = null;
					if (jsObj.has("dest_ip")) {
						dest_ip = jsObj.getString("dest_ip");
						System.out.println("dest ip : " + dest_ip);
					} else {
						System.out.println("dest ip not found in JSON object.");
					}
					String threat_id = jsObj.getString("threat_id");
					String priority = null;
					if (jsObj.has("priority")) {
						priority = jsObj.getString("priority");
						System.out.println(" priority: " + priority);
					} else {
						System.out.println("priority not found in JSON object.");
					}
					int dest_port = jsObj.getInt("dest_port");
					String timestamp = null;
					if (jsObj.has("timestamp")) {
						timestamp = jsObj.getString("timestamp");
						System.out.println("timestamp : " + timestamp);
					} else {
						System.out.println("timestamp not found in JSON object.");
					}

					JSONObject threatLogsObj = new JSONObject();
					try {
						threatLogsObj.put("src_ip", src_ip);
						threatLogsObj.put("src_port", src_port);
						threatLogsObj.put("protocol_type", protocol_type);
						threatLogsObj.put("ack_at", ack_at);
						threatLogsObj.put("ack_by", ack_by);
						threatLogsObj.put("alert_message", alert_message);
						threatLogsObj.put("dest_ip", dest_ip);
						threatLogsObj.put("threat_id", threat_id);
						threatLogsObj.put("priority", priority);
						threatLogsObj.put("dest_port", dest_port);
						threatLogsObj.put("timestamp", timestamp);

						resJsonArray.put(threatLogsObj);
					} catch (Exception e) {
						e.printStackTrace();
						logger.error("Error in putting threat logs data in json array : " + e);
					}
				}

				logger.info("JSON ARRAY :" + resJsonArray.length() + " " + resJsonArray.toString());

				response.setContentType("application/json");

				// Write the JSON data to the response
				response.getWriter().print(resJsonArray.toString());

			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error getting threat logs :" + e);
			}

		} else {
			try {
				JSONObject userObj = new JSONObject();
				userObj.put("msg", "Your session is timeout. Please login again");
				userObj.put("status", "fail");

				System.out.println(">>" + userObj);

				// Set the response content type to JSON
				response.setContentType("application/json");

				// Write the JSON data to the response
				response.getWriter().print(userObj.toString());

			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error in session timeout : " + e);
			}
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		HttpSession session = request.getSession(false);
		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");

		if (check_username != null) {

			String start_date_time = request.getParameter("startdatetime");
			String end_date_time = request.getParameter("enddatetime");
			SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
			SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			// System.out.println("start_date_time: " + start_date_time + "
			// end_date_time: " + end_date_time);
			String formattedStartDate = "";
			String formattedEndDate = "";
			try {
				Date startDate = inputFormat.parse(start_date_time);
				Date endDate = inputFormat.parse(end_date_time);
				// Format the dates to the desired format
				formattedStartDate = outputFormat.format(startDate);
				formattedEndDate = outputFormat.format(endDate);

				System.out.println("start_date_time: " + formattedStartDate + " end_date_time: " + formattedEndDate);
			} catch (Exception e) {

			}
			try {
				TCPClient client = new TCPClient();
				JSONObject json = new JSONObject();

				json.put("operation", "get_threats");
				json.put("threats_type", "threat_logs");
				json.put("start_time", formattedStartDate);
				json.put("end_time", formattedEndDate);
				json.put("user", check_username);
				json.put("token", check_token);
				
				String respStr = client.sendMessage(json.toString());

				JSONObject respJson = new JSONObject(respStr);

				JSONArray resJsonArray = new JSONArray();

				logger.info("threat_logs Threats response : " + respJson.toString());

				JSONArray resultArr = respJson.getJSONArray("data");

				for (int i = 0; i < resultArr.length(); i++) {
					JSONObject jsObj = resultArr.getJSONObject(i);

					String src_ip = jsObj.getString("srcIp");
					int src_port = jsObj.getInt("srcPort");
					String protocol_type = jsObj.getString("protocolType");
					String ack_at = jsObj.getString("ack_at");
					String ack_by = jsObj.getString("ack_by");
					String alert_message = jsObj.getString("alertMessage");
					String dest_ip = jsObj.getString("destIp");
					String threat_id = jsObj.getString("threat_id");
					String priority = jsObj.getString("priority");
					int dest_port = jsObj.getInt("destPort");
					String timestamp = jsObj.getString("timeStamp");

					JSONObject threatLogs = new JSONObject();
					try {
						threatLogs.put("src_ip", src_ip);
						threatLogs.put("src_port", src_port);
						threatLogs.put("protocol_type", protocol_type);
						threatLogs.put("ack_at", ack_at);
						threatLogs.put("ack_by", ack_by);
						threatLogs.put("alert_message", alert_message);
						threatLogs.put("dest_ip", dest_ip);
						threatLogs.put("threat_id", threat_id);
						threatLogs.put("priority", priority);
						threatLogs.put("dest_port", dest_port);
						threatLogs.put("timestamp", timestamp);

						resJsonArray.put(threatLogs);
					} catch (Exception e) {
						e.printStackTrace();
						logger.error("Error in putting active threats data in json array : " + e);
					}
				}

				logger.info("JSON ARRAY :" + resJsonArray.toString());

				response.setContentType("application/json");

				// Write the JSON data to the response
				response.getWriter().print(resJsonArray.toString());

			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error getting active threats :" + e);
			}

		} else {
			try {
				JSONObject userObj = new JSONObject();
				userObj.put("msg", "Your session is timeout. Please login again");
				userObj.put("status", "fail");

				System.out.println(">>" + userObj);

				// Set the response content type to JSON
				response.setContentType("application/json");

				// Write the JSON data to the response
				response.getWriter().print(userObj.toString());

			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error in session timeout : " + e);
			}
		}

	}

}
