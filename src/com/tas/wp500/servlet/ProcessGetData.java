package com.tas.wp500.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;

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


@WebServlet("/processGetData")
public class ProcessGetData extends HttpServlet {
	private static final long serialVersionUID = 1L;
	final static Logger logger = Logger.getLogger(LogDataSearch.class);

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		// response.getWriter().append("Served at:
		// ").append(request.getContextPath());

		HttpSession session = request.getSession(false);
		String check_username = (String) session.getAttribute("username");
		if (check_username != null) {	

			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();

			try {
				json.put("operation", "get_process_list");
				
				String respStr = client.sendMessage(json.toString());

				System.out.println("res " + new JSONObject(respStr));
				logger.info("res " + new JSONObject(respStr));

				JSONObject white_list_process = new JSONObject(respStr);
				JSONObject black_list_process = new JSONObject(respStr);
				
				JSONArray white_list_process1 = white_list_process.getJSONArray("white_list_process");
				JSONArray black_list_process1 = black_list_process.getJSONArray("black_list_process");
				
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("white_list_process", white_list_process1);
				jsonObject.put("black_list_process", black_list_process1);
				
				// Set the content type of the response to application/json
				response.setContentType("application/json");

				// Get the response PrintWriter
				PrintWriter out = response.getWriter();

				// Write the JSON object to the response
				out.print(jsonObject.toString());
				out.flush();
			} catch (Exception e) {
				e.printStackTrace();
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
		
	}

}

