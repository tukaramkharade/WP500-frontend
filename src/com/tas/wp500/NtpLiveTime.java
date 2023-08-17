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

/**
 * Servlet implementation class ntp
 */
@WebServlet("/ntpLiveTime")
public class NtpLiveTime extends HttpServlet {
	private static final long serialVersionUID = 1L;

	final static Logger logger = Logger.getLogger(Ntp.class);

	public NtpLiveTime() {
		super();
		// TODO Auto-generated constructor stub
	}

	TCPClient client = new TCPClient();
	JSONObject json = new JSONObject();
	JSONObject respJson = null;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		// response.getWriter().append("Served at:
		// ").append(request.getContextPath());
		
		HttpSession session = request.getSession(false);

		if (session != null) {
			String check_username = (String) session.getAttribute("username");

		try {
			TCPClient client = new TCPClient();
			json = new JSONObject();

			json.put("operation", "get_live_date_time");
			json.put("user", check_username);

			String respStr = client.sendMessage(json.toString());

			String IST_Time = new JSONObject(respStr).getString("IST Time");
			String UTC_Time = new JSONObject(respStr).getString("UTC Time");
			
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

			// Get the response PrintWriter
			PrintWriter out = response.getWriter();

			// Write the JSON object to the response
			out.print(jsonObject.toString());
			out.flush();
		} catch (Exception e) {
			e.printStackTrace();
		}
		}else{
			System.out.println("Login first");
			response.sendRedirect("login.jsp");
		}

	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */

}
