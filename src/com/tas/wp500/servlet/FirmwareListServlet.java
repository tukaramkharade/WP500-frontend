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

@WebServlet("/FirmwareListServlet")
public class FirmwareListServlet extends HttpServlet {
	final static Logger logger = Logger.getLogger(FirmwareListServlet.class);
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		HttpSession session = request.getSession(false);

		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		
		if (check_username != null) {
			
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();
			
			try{
				
				json.put("operation", "file_manager");				
				json.put("operation_type", "firmware_file_list");
				json.put("user", check_username);
				json.put("token", check_token);
				
				String respStr = client.sendMessage(json.toString());

				logger.info("res " + new JSONObject(respStr));

				JSONObject result = new JSONObject(respStr);

				JSONArray firmware_files_result = result.getJSONArray("files");

				JSONObject jsonObject = new JSONObject();
				jsonObject.put("firmware_files_result", firmware_files_result);

				// Set the content type of the response to application/json
				response.setContentType("application/json");

				// Get the response PrintWriter
				PrintWriter out = response.getWriter();

				// Write the JSON object to the response
				out.print(jsonObject.toString());
				out.flush();
				
				
			}catch(Exception e){
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

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		HttpSession session = request.getSession(false);

		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		
		if (check_username != null) {
			
			String file = request.getParameter("file");
			
			try {

				TCPClient client = new TCPClient();
				JSONObject json = new JSONObject();

				json.put("operation", "file_manager");
				json.put("operation_type", "firmware_file_delete");
				json.put("firmware_file_name", file);
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
				logger.error("Error in deleting mqtt : " + e);
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

}
