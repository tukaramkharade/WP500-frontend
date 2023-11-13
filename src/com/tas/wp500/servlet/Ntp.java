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
import org.json.JSONException;
import org.json.JSONObject;

import com.tas.wp500.utils.TCPClient;


@WebServlet("/ntp")
public class Ntp extends HttpServlet {
	
	final static Logger logger = Logger.getLogger(Ntp.class);

	public Ntp() {
		super();
		// TODO Auto-generated constructor stub
	}

	TCPClient client = new TCPClient();
	JSONObject json = new JSONObject();
	JSONObject respJson = null;

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)

				throws ServletException, IOException {

			HttpSession session = request.getSession(true);
	 
				String check_username = (String) session.getAttribute("username");

				JSONObject jsonObject = new JSONObject();
	 
				if (check_username != null) {
	 
					try {

						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();
	 
						json.put("operation", "get_ntp_details");
						json.put("user", check_username);
	 
						String respStr = client.sendMessage(json.toString()); 
						String ntp_service = new JSONObject(respStr).getString("ntp_service");
						String system_clock_synchronized = new JSONObject(respStr).getString("system_clock_synchronized");

						System.out.println("ntp_service : " + ntp_service);
						System.out.println("system_clock_synchronized : " + system_clock_synchronized);

						jsonObject.put("ntp_service", ntp_service);
						jsonObject.put("system_clock_synchronized", system_clock_synchronized);

	 					System.out.println(jsonObject);
	 
						// Set the content type of the response to application/json
	 					response.setContentType("application/json");
	 
						// Get the response PrintWriter
						PrintWriter out = response.getWriter();
	 
						// Write the JSON object to the response
						out.print(jsonObject.toString());
						out.flush();					

					} catch (JSONException e) {

						// TODO Auto-generated catch block

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
	
		
		HttpSession session = request.getSession(false);

		if (session != null) {
			String check_username = (String) session.getAttribute("username");

		String ntp_client = request.getParameter("ntp_client");


		try {
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();

			json.put("operation", "update_ntp");
			json.put("user", check_username);
			json.put("ntp_client", ntp_client);


			String respStr = client.sendMessage(json.toString());

			System.out.println("res " + new JSONObject(respStr).toString());
			logger.info("res " + new JSONObject(respStr).toString());

			String message = "Successfully Updated Ntp Setting";// new JSONObject(respStr).toString();
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("message", message);

			// Set the content type of the response to application/json
			response.setContentType("application/json");

			// Get the response PrintWriter
			PrintWriter out1 = response.getWriter();

			// Write the JSON object to the response
			out1.print(jsonObject.toString());
			out1.flush();

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		}else{
			System.out.println("Login first");
			response.sendRedirect("login.jsp");
		}
	}

}
