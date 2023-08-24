package com.tas.wp500;

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

import com.tas.utils.TCPClient;

@WebServlet("/dispenserTriggerEditServlet")
public class DispenserTriggerEditServlet extends HttpServlet {
	final static Logger logger = Logger.getLogger(DispenserTriggerEditServlet.class);

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		HttpSession session = request.getSession(false);
		String check_username = (String) session.getAttribute("username");

			if (check_username != null) {
				TCPClient client = new TCPClient();
				JSONObject json = new JSONObject();

				try {
					json.put("operation", "protocol");
					json.put("protocol_type", "dispenser");
					json.put("operation_type", "get_query");
					json.put("user", check_username);

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
						String unit_id= jsObj.getString("unit_id");

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
							logger.error("Error putting dispenser trigger in json array : "+e);
						}
					}

					logger.info("JSON ARRAY :" + resJsonArray.length() + " " + resJsonArray.toString());

					response.setContentType("application/json");

					// Write the JSON data to the response
					response.getWriter().print(resJsonArray.toString());
				} catch (Exception e) {
					e.printStackTrace();
					logger.error("Error getting dispenser trigger data :"+e);
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
					logger.error("Error in session timeout : "+e);
				}
			}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		HttpSession session = request.getSession(false);
		String check_username = (String) session.getAttribute("username");

		if (check_username != null) {
			
			String broker_name = request.getParameter("broker_name");
			String station_name = request.getParameter("station_name");
			String serial_number = request.getParameter("serial_number");
			String side = request.getParameter("side");
			String trigger_tag = request.getParameter("trigger_tag");
			String trigger_value = request.getParameter("trigger_value");
			String start_pressure = request.getParameter("start_pressure");
			String end_pressure = request.getParameter("end_pressure");
			String temperature = request.getParameter("temperature");
			String total = request.getParameter("total");
			String quantity = request.getParameter("quantity");
			String unit_price = request.getParameter("unit_price");
			String status = request.getParameter("status");
			String unit_id = request.getParameter("unit_id");

			try {

				TCPClient client = new TCPClient();
				JSONObject json = new JSONObject();

				json.put("operation", "protocol");
				json.put("protocol_type", "dispenser");
				json.put("operation_type", "update_query");
				json.put("user", check_username);

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

				// Set the content type of the response to application/json
				response.setContentType("application/json");

				// Get the response PrintWriter
				PrintWriter out = response.getWriter();

				// Write the JSON object to the response
				out.print(jsonObject.toString());
				out.flush();

			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error in updating dispenser trigger : "+e);
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
