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
import org.json.JSONObject;

import com.tas.wp500.utils.TCPClient;

@WebServlet("/ntpLiveTime")
public class NtpLiveTime extends HttpServlet {
	final static Logger logger = Logger.getLogger(NtpLiveTime.class);

	

	TCPClient client = new TCPClient();
	JSONObject json = new JSONObject();
	JSONObject respJson = null;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		HttpSession session = request.getSession(false);

		if (session != null) {
			String check_username = (String) session.getAttribute("username");
			String check_token = (String) session.getAttribute("token");
			String check_role = (String) session.getAttribute("role");

		try {
			TCPClient client = new TCPClient();
			json = new JSONObject();

			json.put("operation", "get_live_date_time");
			json.put("user", check_username);
			json.put("token", check_token);
			json.put("role", check_role);
			
			String respStr = client.sendMessage(json.toString());

			String IST_Time = new JSONObject(respStr).getString("IST_Time");
			String UTC_Time = new JSONObject(respStr).getString("UTC_Time");
			
			String IST_Time1 = IST_Time.toString();
			String UTC_Time1 = UTC_Time.toString();
			
			System.out.println("IST_Time : " + IST_Time1);
			System.out.println("UTC_Time : " + UTC_Time1);

			

			JSONObject jsonObject = new JSONObject();
			jsonObject.put("IST_Time", IST_Time1);
			jsonObject.put("UTC_Time", UTC_Time1);

			
			System.out.println(jsonObject);

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
		}
		}

	}

}
