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

@WebServlet("/logs")
public class Logs extends HttpServlet {
	final static Logger logger = Logger.getLogger(Logs.class);

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
				json.put("operation", "get_log_file_list");
				json.put("user", check_username);
				json.put("token", check_token);
				json.put("role", check_role);
				
				String respStr = client.sendMessage(json.toString());
				logger.info("res " + new JSONObject(respStr));

				JSONObject result = new JSONObject(respStr);
				String status = result.getString("status");
				String message = result.getString("msg");
				
				
				
				JSONObject finalJsonObj = new JSONObject();
				if(status.equals("success")){
					JSONArray log_file_result = result.getJSONArray("result");
					finalJsonObj.put("status", status);
					finalJsonObj.put("log_file_result", log_file_result);
				}else if(status.equals("fail")){
					finalJsonObj.put("status", status);
				    finalJsonObj.put("message", message);
				}

			    // Set the response content type to JSON
			    response.setContentType("application/json");
			    response.setHeader("X-Content-Type-Options", "nosniff");
			    
			    // Write the JSON data to the response
			    response.getWriter().print(finalJsonObj.toString());
			
			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error in getting log file list : " + e);
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

			String fileName = request.getParameter("log_file");
			String log_type = "application";
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();

			try {
				json.put("operation", "get_log_file_data");
				json.put("user", check_username);
				json.put("token", check_token);
				json.put("log_type", log_type);
				json.put("file_name", fileName);
				json.put("role", check_role);

				String respStr = client.sendMessage(json.toString());

				logger.info("res " + new JSONObject(respStr));

				JSONObject result = new JSONObject(respStr);
				JSONArray log_file_result = result.getJSONArray("result");
				String status = result.getString("status");
				String message = result.getString("msg");
				
				
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("log_file_data", log_file_result);
				jsonObject.put("status", status);
				jsonObject.put("message", message);
				
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
				logger.error("Error in getting log file data : " + e);
			}
		} 
	}
}
