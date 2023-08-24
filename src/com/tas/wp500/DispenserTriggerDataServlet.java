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
import org.json.JSONObject;

import com.tas.utils.TCPClient;

@WebServlet("/dispenserTriggerDataServlet")
public class DispenserTriggerDataServlet extends HttpServlet {

	final static Logger logger = Logger.getLogger(DispenserTriggerDataServlet.class);

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

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
				json.put("operation_type", "add_query");
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
				logger.error("Error in adding dispenser trigger : "+e);
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
