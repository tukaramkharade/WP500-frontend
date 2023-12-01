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
import org.json.JSONObject;

import com.tas.wp500.utils.TCPClient;

@WebServlet("/mqttCrtFileListServlet")
public class MQTTCrtFileListServlet extends HttpServlet {
	final static Logger logger = Logger.getLogger(MQTTCrtFileListServlet.class);

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
			json.put("protocol_type", "mqtt");
			json.put("operation_type", "get_crt_files");
			json.put("user", check_username);
			json.put("token", check_token);
			
			String respStr = client.sendMessage(json.toString());

			logger.info("res " + new JSONObject(respStr));

			JSONObject result = new JSONObject(respStr);

			JSONArray crt_files_result = result.getJSONArray("result");

			JSONObject jsonObject = new JSONObject();
			jsonObject.put("crt_files_result", crt_files_result);

			// Set the content type of the response to application/json
			response.setContentType("application/json");

			// Get the response PrintWriter
			PrintWriter out = response.getWriter();

			// Write the JSON object to the response
			out.print(jsonObject.toString());
			out.flush();

		} catch (Exception e) {
			e.printStackTrace();
			logger.error("Error in getting firmware files : "+e);
		}
		}else{
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
		String check_token = (String) session.getAttribute("token");

		if (check_username != null) {

			String broker_ip_address = request.getParameter("broker_ip_address");

			try {
				TCPClient client = new TCPClient();
				JSONObject json = new JSONObject();

				json.put("operation", "get_mqtt_status");
				json.put("user", check_username);
				json.put("ip_address", broker_ip_address);
				json.put("token", check_token);

				String respStr = client.sendMessage(json.toString());

				logger.info("res " + new JSONObject(respStr).getString("connection_status"));

				String connection_status = new JSONObject(respStr).getString("connection_status");
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("connection_status", connection_status);

				// Set the content type of the response to application/json
				response.setContentType("application/json");

				// Get the response PrintWriter
				PrintWriter out = response.getWriter();

				// Write the JSON object to the response
				out.print(jsonObject.toString());
				out.flush();

			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error in getting mqtt status : " + e);

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
