package com.tas.wp500.servlet;

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
import org.json.JSONException;
import org.json.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import com.tas.wp500.utils.IntervalMapper;
import com.tas.wp500.utils.TCPClient;

@WebServlet("/commandConfigServlet")
public class CommandConfigServlet extends HttpServlet {

	final static Logger logger = Logger.getLogger(CommandConfigServlet.class);

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);

		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");

		JSONObject disObj = new JSONObject();

		if (check_username != null) {
			try {
				JSONArray resJsonArray = new JSONArray();

				TCPClient client = new TCPClient();
				JSONObject json = new JSONObject();

				json.put("operation", "protocol");
				json.put("protocol_type", "command");
				json.put("operation_type", "get_query");
				json.put("user", check_username);
				json.put("token", check_token);

				String respStr = client.sendMessage(json.toString());

				logger.info("res " + new JSONObject(respStr));

				JSONObject respJson = new JSONObject(respStr);

				JSONObject command_result = respJson.getJSONObject("result");

				for (int i = 0; i < command_result.length(); i++) {

					String command_tag = command_result.getString("command_tag");
					int interval = command_result.getInt("intrval");
					String broker_type = command_result.getString("broker_type");
					String broker_ip = command_result.getString("broker_ip");
					String asset_id = command_result.getString("asset_id");
					String unit_id = command_result.getString("unit_id");

					String intervalString = IntervalMapper.getIntervalByValue(interval);

					try {

						disObj.put("command_tag", command_tag);
						disObj.put("interval", intervalString);
						disObj.put("broker_type", broker_type);
						disObj.put("broker_ip", broker_ip);
						disObj.put("asset_id", asset_id);
						disObj.put("unit_id", unit_id);

						resJsonArray.put(disObj);

					} catch (JSONException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
						logger.error("Error putting command data in json object : " + e);
					}
				}

				PrintWriter out = response.getWriter();

				// Write the JSON object to the response
				out.print(disObj.toString());
				out.flush();

			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error getting command data : " + e);
			}

		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);

		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		
		String unit_id = null;
		String asset_id = null;
		String broker_type = null;
		String broker_name = null;
		String interval = null;
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
					 tagData = request.getParameter("tagData");

					 intervalValue = IntervalMapper.getIntervalByString(interval);

					
					try {
						json_string_con = (org.json.simple.JSONObject) parser.parse(tagData);
					} catch (ParseException e1) {
						e1.printStackTrace();
						logger.error("Error in converting into json object : " + e1);
					}

					try {

						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();

						json.put("operation", "protocol");
						json.put("protocol_type", "command");
						json.put("operation_type", "add_query");
						json.put("id", "1");
						json.put("user", check_username);
						json.put("token", check_token);
						json.put("unit_id", unit_id);
						json.put("asset_id", asset_id);
						json.put("broker_type", broker_type);
						json.put("broker_ip", broker_name);
						json.put("intrval", intervalValue);
						json.put("command_tag", json_string_con);

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
						logger.error("Error in adding command : " + e);
					}
					break;
					
				case "update":
					 unit_id = request.getParameter("unit_id");
					 asset_id = request.getParameter("asset_id");
					 broker_type = request.getParameter("broker_type");
					 broker_name = request.getParameter("broker_name");
					 interval = request.getParameter("interval");
					 tagData = request.getParameter("tagData");
					
					 intervalValue = IntervalMapper.getIntervalByString(interval);

					try {
						json_string_con = (org.json.simple.JSONObject) parser.parse(tagData);
					} catch (ParseException e1) {
						// TODO Auto-generated catch block
						e1.printStackTrace();
						logger.error("Error in converting into json object :"+e1);
					}

					try {

						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();

						json.put("operation", "protocol");
						json.put("protocol_type", "command");
						json.put("operation_type", "update_query");
						json.put("id", "1");
						json.put("user", check_username);
						json.put("token", check_token);
						json.put("unit_id", unit_id);
						json.put("asset_id", asset_id);
						json.put("broker_type", broker_type);
						json.put("broker_ip", broker_name);
						json.put("intrval", intervalValue);
						json.put("command_tag", json_string_con);

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
						e.printStackTrace();
						logger.error("Error in updating command :"+e);
					}
					
					break;
				}
			}
		} 
	}
	
	protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		HttpSession session = request.getSession(false);

		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");

		if (check_username != null) {
			try {

				TCPClient client = new TCPClient();
				JSONObject json = new JSONObject();

				json.put("operation", "protocol");
				json.put("protocol_type", "command");
				json.put("operation_type", "delete_query");
				json.put("id", "1");
				json.put("user", check_username);
				json.put("token", check_token);

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
				logger.error("Error deleting command data : " + e);
			}
		} 
	}
}
