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
@WebServlet("/ntp")
public class Ntp extends HttpServlet {
	private static final long serialVersionUID = 1L;

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
		// TODO Auto-generated method stub
		// response.getWriter().append("Served at:
		// ").append(request.getContextPath());
		
		HttpSession session = request.getSession(false);

		if (session.getAttribute("username") != null) {
			String check_username = (String) session.getAttribute("username");

			
			
		try {
			TCPClient client = new TCPClient();
			json = new JSONObject();

			json.put("operation", "get_ntp");
			json.put("user", check_username);

			String respStr = client.sendMessage(json.toString());

			// System.out.println("res " + new JSONObject(respStr));
			// logger.info("res " + new JSONObject(respStr));
			// JSONObject result = new JSONObject(respStr);

			// JSONObject ntp_interval = result.getJSONObject("ntp_interval");
			// System.out.println("ntp_interval :" + ntp_interval.toString());

			// JSONObject ntp_server = result.getJSONObject("ntp_server");
			// System.out.println("ntp_server :" + ntp_server.toString());
			// String ntp_client1 = "1"; //json.getString("ntp_client");
			String ntp_client1 = new JSONObject(respStr).getString("ntp_client");
			String ntp_client = ntp_client1.toString();
			System.out.println("ntp_client : " + ntp_client);
			logger.info("ntp_client : " + ntp_client);

			String ntp_interval1 = new JSONObject(respStr).getString("ntp_interval"); // json.getString("ntp_interval");
			String ntp_interval = ntp_interval1.toString();
			System.out.println("ntp_interval : " + ntp_interval);
			logger.info("ntp_interval : " + ntp_interval);

			String ntp_server1 = new JSONObject(respStr).getString("ntp_server"); // json.getString("ntp_server");
			String ntp_server = ntp_server1.toString();
			System.out.println("ntp_server : " + ntp_server);
			logger.info("ntp_server : " + ntp_server);

			JSONObject jsonObject = new JSONObject();
			jsonObject.put("ntp_client", ntp_client);
			jsonObject.put("ntp_interval", ntp_interval);

			jsonObject.put("ntp_server", ntp_server);
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
			try{
			JSONObject userObj = new JSONObject();
			userObj.put("msg", "Your session is timeout. Please login again");
			userObj.put("status", "fail");
			
			System.out.println(">>" +userObj);
			
			// Set the response content type to JSON
			response.setContentType("application/json");

			// Write the JSON data to the response
			response.getWriter().print(userObj.toString());
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		}

	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		// doGet(request, response);
		
		HttpSession session = request.getSession(false);

		if (session != null) {
			String check_username = (String) session.getAttribute("username");

		String ntp_client = request.getParameter("ntp_client");
		String ntp_interval = request.getParameter("ntp_interval");
		String ntp_server = request.getParameter("ntp_server");

		System.out.println(ntp_interval + " " + ntp_server + " " + ntp_client);
		logger.info(ntp_interval + " " + ntp_server + " " + ntp_client);

		try {
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();

			json.put("operation", "update_ntp");
			json.put("user", check_username);
			json.put("ntp_client", ntp_client);
			json.put("ntp_interval", ntp_interval);
			json.put("ntp_server", ntp_server);

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
