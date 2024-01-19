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
		String check_role = (String) session.getAttribute("role");
		

		String csrfTokenFromRequest = request.getParameter("csrfToken");

		// Retrieve CSRF token from the session
		String csrfTokenFromSession = (String) session.getAttribute("csrfToken");

		if (check_username != null) {

			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();

			try {
				if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
				json.put("operation", "get_threat_logs");
				json.put("user", check_username);
				json.put("token", check_token);
				json.put("role", check_role);
				
				String respStr = client.sendMessage(json.toString());

				JSONObject respJson = new JSONObject(respStr);
				String status = respJson.getString("status");
				String message = respJson.getString("msg");

			
				logger.info("Threat Logs response : " + respJson.toString());

				JSONObject finalJsonObj = new JSONObject();
				if(status.equals("success")){
					JSONArray resultArr = respJson.getJSONArray("data");
					finalJsonObj.put("status", status);
				    finalJsonObj.put("result", resultArr);
				}else if(status.equals("fail")){
					finalJsonObj.put("status", status);
				    finalJsonObj.put("message", message);
				}

			    // Set the response content type to JSON
			    response.setContentType("application/json");
			    response.setHeader("X-Content-Type-Options", "nosniff");

			    // Write the JSON data to the response
			    response.getWriter().print(finalJsonObj.toString());
				}else {
					logger.error("CSRF token validation failed");	
				}
			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error getting threat logs :" + e);
			}

		} 
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		HttpSession session = request.getSession(false);
		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		String check_role = (String) session.getAttribute("role");
		

		String csrfTokenFromRequest = request.getParameter("csrfToken");

		// Retrieve CSRF token from the session
		String csrfTokenFromSession = (String) session.getAttribute("csrfToken");

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
				if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
				TCPClient client = new TCPClient();
				JSONObject json = new JSONObject();

				json.put("operation", "get_threats");
				json.put("threats_type", "threat_logs");
				json.put("start_time", formattedStartDate);
				json.put("end_time", formattedEndDate);
				json.put("user", check_username);
				json.put("token", check_token);
				json.put("role", check_role);
				
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
				 response.setHeader("X-Content-Type-Options", "nosniff");

				// Write the JSON data to the response
				response.getWriter().print(resJsonArray.toString());
				}else {
					logger.error("CSRF token validation failed");	
				}
			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error getting active threats :" + e);
			}

		} 

	}

}
