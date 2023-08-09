package com.tas.wp500;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;

import com.tas.utils.TCPClient;

@WebServlet("/getMqttStatus")
public class MqttStatus extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public MqttStatus() {
		super();
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		
		HttpSession session = request.getSession(false);

		if (session != null) {
			String check_username = (String) session.getAttribute("username");
			
		String broker_ip_address = request.getParameter("broker_ip_address");
		System.out.println("broker_ip_address-->" + broker_ip_address);

		try {
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();

			json.put("operation", "get_mqtt_status");
			json.put("user", check_username);			
			json.put("ip_address", broker_ip_address);

			String respStr = client.sendMessage(json.toString());

			System.out.println("res " + new JSONObject(respStr).getString("connection_status"));

			String connection_status = new JSONObject(respStr).getString("connection_status");
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("connection_status", connection_status);

			// Set the content type of the response to application/json
			response.setContentType("application/json");

			// Get the response PrintWriter
			PrintWriter out = response.getWriter();

			// Write the JSON object to the response
			out.print(jsonObject.toString());
			out.flush();

		} catch (Exception e) {
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
		}
		}else{
			System.out.println("Login first");
			response.sendRedirect("login.jsp");
		}
	}
}
