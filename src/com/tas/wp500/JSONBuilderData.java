package com.tas.wp500;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import com.tas.utils.TCPClient;

@WebServlet("/jsonBuilderData")
public class JSONBuilderData extends HttpServlet {
	
	final static Logger logger = Logger.getLogger(JSONBuilderData.class);

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		HttpSession session = request.getSession(false);
		String check_username = (String) session.getAttribute("username");

		if (check_username != null) {

			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();

			try {
				json.put("operation", "protocol");
				json.put("protocol_type", "json_builder");
				json.put("operation_type", "get_broker_ip");
				json.put("user", check_username);

				String respStr = client.sendMessage(json.toString());

				logger.info("res " + new JSONObject(respStr));

				JSONObject result = new JSONObject(respStr);

				JSONArray broker_ip_result = result.getJSONArray("result");

				JSONObject jsonObject = new JSONObject();
				jsonObject.put("broker_ip_result", broker_ip_result);

				// Set the content type of the response to application/json
				response.setContentType("application/json");

				// Get the response PrintWriter
				PrintWriter out = response.getWriter();

				// Write the JSON object to the response
				out.print(jsonObject.toString());
				out.flush();
			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error in getting broker ip :"+e);
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

			String json_string_name = request.getParameter("json_string_name");
			String jsonInterval = request.getParameter("json_interval");
			String broker_type = request.getParameter("broker_type");
			String broker_name = request.getParameter("broker_name");
			String publishTopic = request.getParameter("publish_topic");
			String publishStatus = request.getParameter("publishing_status");
			String storeAndForward = request.getParameter("storeAndForward");
			String json_string_text = request.getParameter("json_string_text");
			
			JSONParser parser = new JSONParser();
			org.json.simple.JSONObject json_string_con = null;
			try {
				json_string_con = (org.json.simple.JSONObject) parser.parse(json_string_text);
			} catch (ParseException e1) {
				e1.printStackTrace();
				logger.error("Error in converting into json object : "+e1);
			}

			try {

				TCPClient client = new TCPClient();
				JSONObject json = new JSONObject();

				json.put("operation", "protocol");
				json.put("protocol_type", "json_builder");
				json.put("operation_type", "add_query");
				json.put("user", check_username);

				JSONObject json_data = new JSONObject();
				json_data.put("json_string_name", json_string_name);
				
				Map<String, String> intervalMap = new HashMap<>();
				intervalMap.put("30 sec", "30");
				intervalMap.put("1 min", "60");
				intervalMap.put("5 min", "300");
				intervalMap.put("10 min", "600");
				intervalMap.put("15 min", "900");
				intervalMap.put("20 min", "1200");
				intervalMap.put("25 min", "1500");
				intervalMap.put("30 min", "1800");
				intervalMap.put("1 hour", "3600");

				// Get the corresponding interval value from the map
				String intervalValue = intervalMap.get(jsonInterval);
				if (intervalValue != null) {
				    json_data.put("json_interval", intervalValue);
				}
				
				json_data.put("broker_type", broker_type);
				json_data.put("broker_ip_address", broker_name);
				json_data.put("publish_topic_name", publishTopic);
				json_data.put("publishing_status", publishStatus);
				json_data.put("store_n_forward", storeAndForward);
				json_data.put("json_string", json_string_con);

				json.put("Data", json_data);

				String respStr = client.sendMessage(json.toString());

				logger.info("res " + new JSONObject(respStr).getString("msg"));

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
				e.printStackTrace();
				logger.info("Error in adding json builder : "+e);
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
}
