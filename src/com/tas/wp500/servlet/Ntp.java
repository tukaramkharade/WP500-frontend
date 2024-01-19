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


@WebServlet("/ntp")
public class Ntp extends HttpServlet {
	
	final static Logger logger = Logger.getLogger(Ntp.class);

	TCPClient client = new TCPClient();
	JSONObject json = new JSONObject();
	JSONObject respJson = null;

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)

				throws ServletException, IOException {

			HttpSession session = request.getSession(true);
	 
				String check_username = (String) session.getAttribute("username");
				String check_token = (String) session.getAttribute("token");
				String check_role = (String) session.getAttribute("role");
				
				String csrfTokenFromRequest = request.getParameter("csrfToken");

				// Retrieve CSRF token from the session
				String csrfTokenFromSession = (String) session.getAttribute("csrfToken");

				if (check_username != null) {
	 
					try {
						if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();
	 
						json.put("operation", "get_ntp_details");
						json.put("user", check_username);
						json.put("token", check_token);
						json.put("role", check_role);
						
						String respStr = client.sendMessage(json.toString()); 
						
						logger.info("res: "+ new JSONObject(respStr));
						
						String status = new JSONObject(respStr).getString("status");
						String message = new JSONObject(respStr).getString("msg");

						
						
						JSONObject finalJsonObj = new JSONObject();
						if(status.equals("success")){
							String ntp_service = new JSONObject(respStr).getString("ntp_service");
							String system_clock_synchronized = new JSONObject(respStr).getString("system_clock_synchronized");
							
							finalJsonObj.put("ntp_service", ntp_service);
							finalJsonObj.put("system_clock_synchronized", system_clock_synchronized);
							
							finalJsonObj.put("status", status);

						}else if(status.equals("fail")){
							finalJsonObj.put("status", status);
						    finalJsonObj.put("message", message);
						}

					    // Set the response content type to JSON
					    response.setContentType("application/json");
					    response.setHeader("X-Content-Type-Options", "nosniff");

					    // Write the JSON data to the response
					    response.getWriter().print(finalJsonObj.toString());
						}else {
							logger.error("CSRF token validation failed");	
						}
					} catch (JSONException e) {

						// TODO Auto-generated catch block

						e.printStackTrace();

					}

				}	 
			}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	
		
		HttpSession session = request.getSession(false);
		
		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		String check_role = (String) session.getAttribute("role");
		
		String csrfTokenFromRequest = request.getParameter("csrfToken");

		// Retrieve CSRF token from the session
		String csrfTokenFromSession = (String) session.getAttribute("csrfToken");

		if (check_username != null) {
			
		String ntp_client = request.getParameter("ntp_client");

		try {
			
			if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();

			json.put("operation", "update_ntp");
			json.put("user", check_username);
			json.put("ntp_client", ntp_client);
			json.put("token", check_token);
			json.put("role", check_role);

			String respStr = client.sendMessage(json.toString());

			System.out.println("res " + new JSONObject(respStr).toString());
			logger.info("res " + new JSONObject(respStr).toString());

			String message = new JSONObject(respStr).getString("msg");
			String status = new JSONObject(respStr).getString("status");
			
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("message", message);
			jsonObject.put("status", status);

			// Set the content type of the response to application/json
			response.setContentType("application/json");
			 response.setHeader("X-Content-Type-Options", "nosniff");

			// Get the response PrintWriter
			PrintWriter out1 = response.getWriter();

			// Write the JSON object to the response
			out1.print(jsonObject.toString());
			out1.flush();
			}else {
				logger.error("CSRF token validation failed");	
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		}
	}

}
