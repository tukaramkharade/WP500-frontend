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
import org.json.JSONException;
import org.json.JSONObject;

import com.tas.wp500.utils.TCPClient;

@WebServlet("/dispenserTriggerServlet")
public class DispenserTriggerServlet extends HttpServlet {

	final static Logger logger = Logger.getLogger(DispenserTriggerServlet.class);

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");

		if (check_username != null) {
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();

			try {
				json.put("operation", "protocol");
				json.put("protocol_type", "dispenser");
				json.put("operation_type", "get_query");
				json.put("user", check_username);
				json.put("token", check_token);

				String respStr = client.sendMessage(json.toString());

				JSONObject respJson = new JSONObject(respStr);

				JSONArray resJsonArray = new JSONArray();

				logger.info("Dispenser response : " + respJson.toString());

				JSONArray resultArr = respJson.getJSONArray("result");

				for (int i = 0; i < resultArr.length(); i++) {
					JSONObject jsObj = resultArr.getJSONObject(i);

					String broker_ip_address = jsObj.getString("broker_ip_address");
					String station_name = jsObj.getString("station_name");
					String side = jsObj.getString("side");
					String total = jsObj.getString("total");
					String quantity = jsObj.getString("quantity");
					String tempreture = jsObj.getString("tempreture");
					String start_pressesure = jsObj.getString("start_pressesure");
					String end_pressure = jsObj.getString("end_pressure");
					String trigger_value = jsObj.getString("trigger_value");
					String serial_number = jsObj.getString("serial_number");
					String unit_price = jsObj.getString("unit_price");
					String trigger_tag = jsObj.getString("trigger_tag");
					String status = jsObj.getString("status");
					String unit_id = jsObj.getString("unit_id");

					JSONObject disObj = new JSONObject();

					try {

						disObj.put("broker_ip_address", broker_ip_address);
						disObj.put("station_name", station_name);
						disObj.put("side", side);
						disObj.put("total", total);
						disObj.put("quantity", quantity);
						disObj.put("tempreture", tempreture);
						disObj.put("start_pressesure", start_pressesure);
						disObj.put("end_pressure", end_pressure);
						disObj.put("trigger_value", trigger_value);
						disObj.put("serial_number", serial_number);
						disObj.put("unit_price", unit_price);
						disObj.put("trigger_tag", trigger_tag);
						disObj.put("status", status);
						disObj.put("unit_id", unit_id);

						resJsonArray.put(disObj);
					} catch (JSONException e) {
						e.printStackTrace();
						logger.error("Error putting dispenser trigger in json array : " + e);
					}
				}

				logger.info("JSON ARRAY :" + resJsonArray.length() + " " + resJsonArray.toString());

				response.setContentType("application/json");

				// Write the JSON data to the response
				response.getWriter().print(resJsonArray.toString());
			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error getting dispenser trigger data :" + e);
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
		

		String broker_name = null;
		String station_name = null;
		String serial_number = null;
		String side = null;
		String trigger_tag = null;
		String trigger_value = null;
		String start_pressure = null;
		String end_pressure = null;
		String temperature = null;
		String total = null;
		String quantity = null;
		String unit_price = null;
		String status = null;
		String unit_id = null;

		if (check_username != null) {

			String action = request.getParameter("action");

			if (action != null) {
				switch (action) {

				case "add":
					broker_name = request.getParameter("broker_name");
					station_name = request.getParameter("station_name");
					serial_number = request.getParameter("serial_number");
					side = request.getParameter("side");
					trigger_tag = request.getParameter("trigger_tag");
					trigger_value = request.getParameter("trigger_value");
					start_pressure = request.getParameter("start_pressure");
					end_pressure = request.getParameter("end_pressure");
					temperature = request.getParameter("temperature");
					total = request.getParameter("total");
					quantity = request.getParameter("quantity");
					unit_price = request.getParameter("unit_price");
					status = request.getParameter("status");
					unit_id = request.getParameter("unit_id");

					try {

						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();

						json.put("operation", "protocol");
						json.put("protocol_type", "dispenser");
						json.put("operation_type", "add_query");
						json.put("user", check_username);
						json.put("token", check_token);
						json.put("station_name", station_name);
						json.put("serial_number", serial_number);
						json.put("side", side);
						json.put("trigger_tag", trigger_tag);
						json.put("trigger_value", trigger_value);
						json.put("status", status);
						json.put("start_pressesure", start_pressure);
						json.put("end_pressure", end_pressure);
						json.put("tempreture", temperature);
						json.put("total", total);
						json.put("quantity", quantity);
						json.put("unit_price", unit_price);
						json.put("broker_ip_address", broker_name);
						json.put("unit_id", unit_id);

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
						logger.error("Error in adding dispenser trigger : " + e);
					}
					break;

				case "update":

					broker_name = request.getParameter("broker_name");
					station_name = request.getParameter("station_name");
					serial_number = request.getParameter("serial_number");
					side = request.getParameter("side");
					trigger_tag = request.getParameter("trigger_tag");
					trigger_value = request.getParameter("trigger_value");
					start_pressure = request.getParameter("start_pressure");
					end_pressure = request.getParameter("end_pressure");
					temperature = request.getParameter("temperature");
					total = request.getParameter("total");
					quantity = request.getParameter("quantity");
					unit_price = request.getParameter("unit_price");
					status = request.getParameter("status");
					unit_id = request.getParameter("unit_id");

					try {

						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();

						json.put("operation", "protocol");
						json.put("protocol_type", "dispenser");
						json.put("operation_type", "update_query");
						json.put("user", check_username);
						json.put("token", check_token);
						json.put("station_name", station_name);
						json.put("serial_number", serial_number);
						json.put("side", side);
						json.put("trigger_tag", trigger_tag);
						json.put("trigger_value", trigger_value);
						json.put("status", status);
						json.put("start_pressesure", start_pressure);
						json.put("end_pressure", end_pressure);
						json.put("tempreture", temperature);
						json.put("total", total);
						json.put("quantity", quantity);
						json.put("unit_price", unit_price);
						json.put("broker_ip_address", broker_name);
						json.put("unit_id", unit_id);

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
						logger.error("Error in updating dispenser trigger : " + e);
					}
					break;

				case "delete":
					serial_number = request.getParameter("serial_number");
					side = request.getParameter("side");

					try {

						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();

						json.put("operation", "protocol");
						json.put("protocol_type", "dispenser");
						json.put("operation_type", "delete_query");
						json.put("user", check_username);
						json.put("token", check_token);
						json.put("serial_number", serial_number);
						json.put("side", side);

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
						logger.error("Error in deleting dispenser trigger : " + e);
					}
					break;
				}
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

	protected void doDelete(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);

		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");

		if (check_username != null) {

			String serial_number = request.getParameter("serial_number");
			String side = request.getParameter("side");

			try {

				TCPClient client = new TCPClient();
				JSONObject json = new JSONObject();

				json.put("operation", "protocol");
				json.put("protocol_type", "dispenser");
				json.put("operation_type", "delete_query");
				json.put("user", check_username);
				json.put("token", check_token);
				json.put("serial_number", serial_number);
				json.put("side", side);

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
				logger.error("Error in deleting dispenser trigger : " + e);
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
