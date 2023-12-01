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

@WebServlet("/activeThreatServlet")
public class ActiveThreatServlet extends HttpServlet {
	final static Logger logger = Logger.getLogger(ActiveThreatServlet.class);

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");

		if (check_username != null) {
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();

			try {

				json.put("operation", "get_active_threats");
				json.put("user", check_username);
				json.put("token", check_token);

				String respStr = client.sendMessage(json.toString());

				JSONObject respJson = new JSONObject(respStr);

				JSONArray resJsonArray = new JSONArray();

				logger.info("Active Threats response : " + respJson.toString());

				JSONArray resultArr = respJson.getJSONArray("data");

				for (int i = 0; i < resultArr.length(); i++) {
					JSONObject jsObj = resultArr.getJSONObject(i);

					String src_ip = jsObj.getString("src_ip");
					int src_port = jsObj.getInt("src_port");
					String protocol_type = jsObj.getString("protocol_type");
					String ack_at = jsObj.getString("ack_at");
					String ack_by = jsObj.getString("ack_by");
					String alert_message = jsObj.getString("alert_message");
					String dest_ip = jsObj.getString("dest_ip");
					String threat_id = jsObj.getString("threat_id");
					String priority = jsObj.getString("priority");
					int dest_port = jsObj.getInt("dest_port");
					String timestamp = jsObj.getString("timestamp");

					JSONObject activeThreatsObj = new JSONObject();
					try {
						activeThreatsObj.put("src_ip", src_ip);
						activeThreatsObj.put("src_port", src_port);
						activeThreatsObj.put("protocol_type", protocol_type);
						activeThreatsObj.put("ack_at", ack_at);
						activeThreatsObj.put("ack_by", ack_by);
						activeThreatsObj.put("alert_message", alert_message);
						activeThreatsObj.put("dest_ip", dest_ip);
						activeThreatsObj.put("threat_id", threat_id);
						activeThreatsObj.put("priority", priority);
						activeThreatsObj.put("dest_port", dest_port);
						activeThreatsObj.put("timestamp", timestamp);

						resJsonArray.put(activeThreatsObj);
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

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		
		ArrayList<String> stringList = new ArrayList<>();
		String threat_id = request.getParameter("threat_id");

		stringList.add(threat_id);

		if (check_username != null) {
			String action = request.getParameter("action");
			switch (action) {

			case "get_ack_threats":

				Date currentDate = new Date();

				// Create a date format to format the date as a string
				SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

				// Format the current date and time as a string
				String formattedDate = dateFormat.format(currentDate);

				try {
					TCPClient client = new TCPClient();
					JSONObject json = new JSONObject();

					json.put("operation", "ack_threats");
					json.put("threats_ids", stringList);
					json.put("ack_at", formattedDate);
					json.put("ack_by", check_username);
					json.put("user", check_username);
					json.put("token", check_token);

					String respStr = client.sendMessage(json.toString());

					logger.info("res " + new JSONObject(respStr).getString("msg"));

					String message = new JSONObject(respStr).getString("msg");
					JSONObject jsonObject = new JSONObject();
					jsonObject.put("message", message);

					// Set the content type of the response to
					// application/json
					response.setContentType("application/json");

					// Get the response PrintWriter
					PrintWriter out = response.getWriter();

					// Write the JSON object to the response
					out.print(jsonObject.toString());
					out.flush();

				} catch (Exception e) {
					e.printStackTrace();
				}

				break;
			case "get_threats":
				
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

					System.out
							.println("start_date_time: " + formattedStartDate + " end_date_time: " + formattedEndDate);
				} catch (Exception e) {

				}
				try {
					TCPClient client = new TCPClient();
					JSONObject json = new JSONObject();

					json.put("operation", "get_threats");
					json.put("threats_type", "active_threat");
					json.put("start_time", formattedStartDate);
					json.put("end_time", formattedEndDate);
					json.put("user", check_username);
					json.put("token", check_token);

					String respStr = client.sendMessage(json.toString());

					JSONObject respJson = new JSONObject(respStr);

					JSONArray resJsonArray = new JSONArray();

					logger.info("Active Threats response : " + respJson.toString());

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
						threat_id = jsObj.getString("threat_id");
						String priority = jsObj.getString("priority");
						int dest_port = jsObj.getInt("destPort");
						String timestamp = jsObj.getString("timeStamp");

						JSONObject activeThreatsObj = new JSONObject();
						try {
							activeThreatsObj.put("src_ip", src_ip);
							activeThreatsObj.put("src_port", src_port);
							activeThreatsObj.put("protocol_type", protocol_type);
							activeThreatsObj.put("ack_at", ack_at);
							activeThreatsObj.put("ack_by", ack_by);
							activeThreatsObj.put("alert_message", alert_message);
							activeThreatsObj.put("dest_ip", dest_ip);
							activeThreatsObj.put("threat_id", threat_id);
							activeThreatsObj.put("priority", priority);
							activeThreatsObj.put("dest_port", dest_port);
							activeThreatsObj.put("timestamp", timestamp);

							resJsonArray.put(activeThreatsObj);
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

				break;

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
