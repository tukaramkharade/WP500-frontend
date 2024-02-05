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

@WebServlet("/eventTriggerdataServlet")
public class EventTriggerDataServlet extends HttpServlet {

	final static Logger logger = Logger.getLogger(EventTriggerDataServlet.class);

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		String check_role = (String) session.getAttribute("role");
		if (check_username != null) {
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();
			try {
				json.put("operation", "protocol");
				json.put("protocol_type", "dispenser");
				json.put("operation_type", "get_query");
				json.put("user", check_username);
				json.put("token", check_token);
				json.put("role", check_role);

				String respStr = client.sendMessage(json.toString());
				JSONObject respJson = new JSONObject(respStr);
				String status = respJson.getString("status");
				String message = respJson.getString("msg");
				logger.info("Dispenser response : " + respJson.toString());				
				JSONObject finalJsonObj = new JSONObject();
				if(status.equals("success")){
					JSONArray resultArr = respJson.getJSONArray("result");
					finalJsonObj.put("status", status);
				    finalJsonObj.put("result", resultArr);
				}else if(status.equals("fail")){
					finalJsonObj.put("status", status);
				    finalJsonObj.put("message", message);
				}
			    response.setContentType("application/json");
			    response.setHeader("X-Content-Type-Options", "nosniff");
			    response.getWriter().print(finalJsonObj.toString());
			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error getting dispenser trigger data :" + e);
			}
		} 
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		String check_role = (String) session.getAttribute("role");		
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
		String status_req = null;
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
					status_req = request.getParameter("status");
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
						json.put("status", status_req);
						json.put("start_pressesure", start_pressure);
						json.put("end_pressure", end_pressure);
						json.put("tempreture", temperature);
						json.put("total", total);
						json.put("quantity", quantity);
						json.put("unit_price", unit_price);
						json.put("broker_ip_address", broker_name);
						json.put("unit_id", unit_id);
						json.put("role", check_role);

						String respStr = client.sendMessage(json.toString());
						logger.info("res " + new JSONObject(respStr));
						String message = new JSONObject(respStr).getString("msg");
						String status = new JSONObject(respStr).getString("status");						
						JSONObject jsonObject = new JSONObject();
						jsonObject.put("message", message);
						jsonObject.put("status", status);
						response.setContentType("application/json");
						response.setHeader("X-Content-Type-Options", "nosniff");
						PrintWriter out = response.getWriter();
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
					status_req = request.getParameter("status");
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
						json.put("status", status_req);
						json.put("start_pressesure", start_pressure);
						json.put("end_pressure", end_pressure);
						json.put("tempreture", temperature);
						json.put("total", total);
						json.put("quantity", quantity);
						json.put("unit_price", unit_price);
						json.put("broker_ip_address", broker_name);
						json.put("unit_id", unit_id);
						json.put("role", check_role);

						String respStr = client.sendMessage(json.toString());
						logger.info("res " + new JSONObject(respStr));
						String message = new JSONObject(respStr).getString("msg");
						String status = new JSONObject(respStr).getString("status");						
						JSONObject jsonObject = new JSONObject();
						jsonObject.put("message", message);
						jsonObject.put("status", status);
						response.setContentType("application/json");
						response.setHeader("X-Content-Type-Options", "nosniff");
						PrintWriter out = response.getWriter();
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
						json.put("role", check_role);

						String respStr = client.sendMessage(json.toString());
						logger.info("res " + new JSONObject(respStr));
						String message = new JSONObject(respStr).getString("msg");
						String status = new JSONObject(respStr).getString("status");						
						JSONObject jsonObject = new JSONObject();
						jsonObject.put("message", message);
						jsonObject.put("status", status);
						response.setContentType("application/json");
						response.setHeader("X-Content-Type-Options", "nosniff");
						PrintWriter out = response.getWriter();
						out.print(jsonObject.toString());
						out.flush();
					} catch (Exception e) {
						e.printStackTrace();
						logger.error("Error in deleting dispenser trigger : " + e);
					}
					break;
				}
			}
		} 
	}
}