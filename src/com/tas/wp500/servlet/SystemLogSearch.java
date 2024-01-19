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


@WebServlet("/loadSystemLogSearch") 
public class SystemLogSearch extends HttpServlet {
	
	final static Logger logger = Logger.getLogger(LogDataSearch.class);

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		

		
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		// doGet(request, response);

		HttpSession session = request.getSession(false);

		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		String check_role = (String) session.getAttribute("role");
		
		String csrfTokenFromRequest = request.getParameter("csrfToken");

		// Retrieve CSRF token from the session
		String csrfTokenFromSession = (String) session.getAttribute("csrfToken");
		
		if (check_username != null) {

			String start_date_time = request.getParameter("startdatetime");
			String end_date_time = request.getParameter("enddatetime");
			String search_query = request.getParameter("search_query");

			SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
			SimpleDateFormat outputFormat = new SimpleDateFormat("MMM dd HH:mm");
			SimpleDateFormat outputFormatMonth = new SimpleDateFormat("MMM dd");
			SimpleDateFormat outputFormatTime = new SimpleDateFormat("HH:mm");

			try {
				if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
				Date startDate = inputFormat.parse(start_date_time);
				String startDate1 = outputFormatMonth.format(startDate);

				Date startTime = inputFormat.parse(start_date_time);
				String startTime1 = outputFormatTime.format(startTime);

				Date endDate = inputFormat.parse(end_date_time);
				String endDate1 = outputFormatMonth.format(endDate);

				Date endTime = inputFormat.parse(end_date_time);
				String endTime1 = outputFormatTime.format(endTime);

				System.out.println("startDate date time : " + startDate1);
				System.out.println("startTime date time : " + startTime1);
				System.out.println("endDate date time : " + endDate1);
				System.out.println("endTime date time : " + endTime1);

				TCPClient client = new TCPClient();
				JSONObject json = new JSONObject();

				json.put("operation", "get_log_file_data");
				json.put("log_type", "system");
				json.put("start_month", startDate1);
				json.put("start_time", startTime1);
				json.put("role", check_role);
				json.put("end_month", endDate1);
				json.put("end_time", endTime1);
				json.accumulate("search", search_query);

				json.put("user", check_username);
				json.put("token", check_token);
				
				System.out.println(json);
				String respStr = client.sendMessage(json.toString());

				System.out.println("res " + new JSONObject(respStr));
				logger.info("res " + new JSONObject(respStr));

				JSONObject result = new JSONObject(respStr);

				JSONArray system_log_result = result.getJSONArray("result");

				JSONObject jsonObject = new JSONObject();
				jsonObject.put("system_log_result", system_log_result);
				// Set the content type of the response to application/json
				response.setContentType("application/json");
				 response.setHeader("X-Content-Type-Options", "nosniff");

				// Get the response PrintWriter
				PrintWriter out = response.getWriter();

				// Write the JSON object to the response
				out.print(jsonObject.toString());
				out.flush();
				}else {
					logger.error("CSRF token validation failed");	
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else {
			
		}
	}

}

