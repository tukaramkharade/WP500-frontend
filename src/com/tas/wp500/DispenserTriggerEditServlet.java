package com.tas.wp500;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.tas.utils.TCPClient;

/**
 * Servlet implementation class DispenserTriggerEditServlet
 */
@WebServlet("/dispenserTriggerEditServlet")
public class DispenserTriggerEditServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	final static Logger logger = Logger.getLogger(DispenserTriggerEditServlet.class);

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public DispenserTriggerEditServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		// response.getWriter().append("Served at:
		// ").append(request.getContextPath());

		TCPClient client = new TCPClient();
		JSONObject json = new JSONObject();

		try {
			json.put("operation", "protocol");
			json.put("protocol_type", "dispenser");
			json.put("operation_type", "get_query");

			String respStr = client.sendMessage(json.toString());

			JSONObject respJson = new JSONObject(respStr);

			System.out.println("res " + respJson.toString());

			JSONArray resJsonArray = new JSONArray();

			logger.info("Dispenser response : " + respJson.toString());

			JSONArray resultArr = respJson.getJSONArray("result");

			System.out.println("Result : " + resultArr.toString());

			for (int i = 0; i < resultArr.length(); i++) {
				JSONObject jsObj = resultArr.getJSONObject(i);

				String broker_ip_address = jsObj.getString("broker_ip_address");
				logger.info("broker_ip_address : " + broker_ip_address);

				String station_name = jsObj.getString("station_name");
				logger.info("station_name : " + station_name);

				String side = jsObj.getString("side");
				logger.info("side : " + side);

				String total = jsObj.getString("total");
				logger.info("total : " + total);

				String quantity = jsObj.getString("quantity");
				logger.info("quantity : " + quantity);

				String tempreture = jsObj.getString("tempreture");
				logger.info("tempreture : " + tempreture);

				String start_pressesure = jsObj.getString("start_pressesure");
				logger.info("start_pressesure : " + start_pressesure);

				String end_pressure = jsObj.getString("end_pressure");
				logger.info("end_pressure : " + end_pressure);

				String trigger_value = jsObj.getString("trigger_value");
				logger.info("trigger_value : " + trigger_value);
				
				String serial_number = jsObj.getString("serial_number");
				logger.info("serial_number : " + serial_number);

				String unit_price = jsObj.getString("unit_price");
				logger.info("unit_price : " + unit_price);
				
				String trigger_tag = jsObj.getString("trigger_tag");
				logger.info("trigger_tag : " + trigger_tag);

				String status = jsObj.getString("status");
				logger.info("status : " + status);

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

					resJsonArray.put(disObj);
					// firewallObj.put("lastName", "");
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}

			logger.info("JSON ARRAY :" + resJsonArray.length() + " " + resJsonArray.toString());

			response.setContentType("application/json");

			// Write the JSON data to the response
			response.getWriter().print(resJsonArray.toString());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		// doGet(request, response);
		
		
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
		
		try{
			
			System.out.println("In dispenser...");
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();

			json.put("operation", "protocol");
			json.put("protocol_type", "dispenser");
			json.put("operation_type", "update_query");
			
			
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

			String respStr = client.sendMessage(json.toString());

			System.out.println("res " + new JSONObject(respStr).getString("msg"));

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

			
		}catch(Exception e){
			e.printStackTrace();
		}
	}

}
