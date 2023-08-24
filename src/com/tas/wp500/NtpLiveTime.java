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
import org.json.JSONObject;
import org.json.JSONException;

import com.tas.utils.TCPClient;


@WebServlet("/ntpLiveTime")
public class NtpLiveTime extends HttpServlet {
	final static Logger logger = Logger.getLogger(Ntp.class);

	TCPClient client = new TCPClient();
	JSONObject json = new JSONObject();
	JSONObject respJson = null;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		HttpSession session = request.getSession(false);

		String check_username = (String) session.getAttribute("username");

		if (check_username != null) {

		try {
			TCPClient client = new TCPClient();
			json = new JSONObject();

			json.put("operation", "get_live_date_time");
			json.put("user", check_username);

			String respStr = client.sendMessage(json.toString());
			
			logger.info("res : "+new JSONObject(respStr));

			String IST_Time = new JSONObject(respStr).getString("IST_Time");
			String UTC_Time = new JSONObject(respStr).getString("UTC_Time");
			
			String IST_Time1 = IST_Time.toString();
			String UTC_Time1 = UTC_Time.toString();
			
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("IST_Time", IST_Time1);
			jsonObject.put("UTC_Time", UTC_Time1);

			// Set the content type of the response to application/json
			response.setContentType("application/json");

			// Get the response PrintWriter
			PrintWriter out = response.getWriter();

			// Write the JSON object to the response
			out.print(jsonObject.toString());
			out.flush();
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("Error in getting live date and time : "+e);
		}
		}else{
			
		}

	}

}
