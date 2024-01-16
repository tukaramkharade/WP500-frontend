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
		String check_role = (String) session.getAttribute("role");

		if (check_username != null) {

		TCPClient client = new TCPClient();
		JSONObject json = new JSONObject();

		try {

			json.put("operation", "protocol");
			json.put("protocol_type", "mqtt");
			json.put("operation_type", "get_crt_files");
			json.put("user", check_username);
			json.put("token", check_token);
			json.put("role", check_role);
			
			String respStr = client.sendMessage(json.toString());

			logger.info("res " + new JSONObject(respStr));

			JSONObject respJson = new JSONObject(respStr);
			String status = respJson.getString("status");
			String message = respJson.getString("msg");

			JSONObject finalJsonObj = new JSONObject();
			if(status.equals("success")){
				JSONArray crt_files_result = respJson.getJSONArray("result");
				finalJsonObj.put("status", status);
			    finalJsonObj.put("crt_files_result", crt_files_result);
			}else if(status.equals("fail")){
				finalJsonObj.put("status", status);
			    finalJsonObj.put("message", message);
			}

			// Set the content type of the response to application/json
			response.setContentType("application/json");
			 response.setHeader("X-Content-Type-Options", "nosniff");

			// Get the response PrintWriter
			PrintWriter out = response.getWriter();

			// Write the JSON object to the response
			out.print(finalJsonObj.toString());
			out.flush();

		} catch (Exception e) {
			e.printStackTrace();
			logger.error("Error in getting firmware files : "+e);
		}
		}
}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		HttpSession session = request.getSession(false);
		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		String check_role = (String) session.getAttribute("role");

		if (check_username != null) {

			String broker_ip_address = request.getParameter("broker_ip_address");

			try {
				TCPClient client = new TCPClient();
				JSONObject json = new JSONObject();

				json.put("operation", "get_mqtt_status");
				json.put("user", check_username);
				json.put("ip_address", broker_ip_address);
				json.put("token", check_token);
				json.put("role", check_role);

				String respStr = client.sendMessage(json.toString());

				logger.info("res " + new JSONObject(respStr));

				String connection_status = new JSONObject(respStr).getString("connection_status");
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("connection_status", connection_status);

				// Set the content type of the response to application/json
				response.setContentType("application/json");
				 response.setHeader("X-Content-Type-Options", "nosniff");

				// Get the response PrintWriter
				PrintWriter out = response.getWriter();

				// Write the JSON object to the response
				out.print(jsonObject.toString());
				out.flush();

			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error in getting mqtt status : " + e);

			}
		} 
	}
}
