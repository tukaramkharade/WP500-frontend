package com.tas.wp500;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import com.tas.utils.TCPClient;

@WebServlet("/alarmConfigAddData")
public class AlarmConfigAddData extends HttpServlet {

	final static Logger logger = Logger.getLogger(AlarmConfigAddData.class);

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);

		String check_username = (String) session.getAttribute("username");
		
		JSONObject disObj = new JSONObject();

		if (check_username != null) {
			try {
				JSONArray resJsonArray = new JSONArray();

				TCPClient client = new TCPClient();
				JSONObject json = new JSONObject();

				json.put("operation", "protocol");
				json.put("protocol_type", "alarm");
				json.put("operation_type", "get_query");
				json.put("user", check_username);

				String respStr = client.sendMessage(json.toString());

				logger.info("res " + new JSONObject(respStr));
				
				JSONObject respJson = new JSONObject(respStr);

				JSONObject alarm_result = respJson.getJSONObject("result");

				for (int i = 0; i < alarm_result.length(); i++) {

					String alarm_tag = alarm_result.getString("alarm_tag");
					String interval = alarm_result.getString("intrval");
					String broker_type =alarm_result.getString("broker_type");
					String broker_ip = alarm_result.getString("broker_ip");
					String asset_id = alarm_result.getString("asset_id");
					String unit_id = alarm_result.getString("unit_id");

					try {
						disObj.put("alarm_tag", alarm_tag);

						Map<String, String> reverseIntervalMap = new HashMap<>();
						reverseIntervalMap.put("5", "5 sec");
						reverseIntervalMap.put("10", "10 sec");
						reverseIntervalMap.put("15", "15 sec");
						reverseIntervalMap.put("20", "20 sec");
						reverseIntervalMap.put("25", "25 sec");
						reverseIntervalMap.put("30", "30 sec");
						reverseIntervalMap.put("60", "1 min");
						reverseIntervalMap.put("300", "5 min");
						reverseIntervalMap.put("600", "10 min");
						reverseIntervalMap.put("900", "15 min");
						reverseIntervalMap.put("1200", "20 min");
						reverseIntervalMap.put("1500", "25 min");
						reverseIntervalMap.put("1800", "30 min");
						reverseIntervalMap.put("3600", "1 hour");

						// Get the corresponding interval string from the map
						String intervalString = reverseIntervalMap.get(interval);
						if (intervalString != null) {
							disObj.put("interval", intervalString);
						}

						disObj.put("broker_type", broker_type);
						disObj.put("broker_ip", broker_ip);
						disObj.put("asset_id", asset_id);
						disObj.put("unit_id", unit_id);

					} catch (JSONException e) {
						e.printStackTrace();
						logger.error("Error putting alarm data in json object: " + e);
					}
				}

				// Get the response PrintWriter
				PrintWriter out = response.getWriter();

				// Write the JSON object to the response
				out.print(disObj.toString());
				out.flush();

			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error getting alarm data : " + e);
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
				logger.error("Error in session timeout: " + e);
			}
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);

		String check_username = (String) session.getAttribute("username");

		if (check_username != null) {

			String unit_id = request.getParameter("unit_id");
			String asset_id = request.getParameter("asset_id");
			String broker_type = request.getParameter("broker_type");
			String broker_name = request.getParameter("broker_name");
			String interval = request.getParameter("interval");
			String tagData = request.getParameter("tagData");

			JSONParser parser = new JSONParser();
			org.json.simple.JSONObject json_string_con = null;
			try {
				json_string_con = (org.json.simple.JSONObject) parser.parse(tagData);
			} catch (ParseException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
				logger.error("Error converting into json object: " + e1);
			}

			try {

				TCPClient client = new TCPClient();
				JSONObject json = new JSONObject();

				json.put("operation", "protocol");
				json.put("protocol_type", "alarm");
				json.put("operation_type", "add_query");

				json.put("id", "1");
				json.put("user", check_username);
				json.put("unit_id", unit_id);
				json.put("asset_id", asset_id);
				json.put("broker_type", broker_type);
				json.put("broker_ip", broker_name);

				Map<String, String> intervalMap = new HashMap<>();
				intervalMap.put("5 sec", "5");
				intervalMap.put("10 sec", "10");
				intervalMap.put("15 sec", "15");
				intervalMap.put("20 sec", "20");
				intervalMap.put("25 sec", "25");
				intervalMap.put("30 sec", "30");
				intervalMap.put("1 min", "60");
				intervalMap.put("5 min", "300");
				intervalMap.put("10 min", "600");
				intervalMap.put("15 min", "900");
				intervalMap.put("20 min", "1200");
				intervalMap.put("25 min", "1500");
				intervalMap.put("30 min", "1800");
				intervalMap.put("1 hour", "3600");

				String intervalValue = intervalMap.get(interval);
				if (intervalValue != null) {
					json.put("intrval", intervalValue);
				}

				json.put("alarm_tag", json_string_con);

				String respStr = client.sendMessage(json.toString());

				logger.info("res " + new JSONObject(respStr));

				String message = new JSONObject(respStr).getString("msg");
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("message", message);

				// Set the content type of the response to application/json
				response.setContentType("application/json");

				// Get the response PrintWriter
				PrintWriter out = response.getWriter();

				// Write the JSON object to the response
				out.print(jsonObject.toString());
				out.flush();

			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				logger.error("Error adding alarm data : " + e);
			}
		} else {

		}
	}
}
