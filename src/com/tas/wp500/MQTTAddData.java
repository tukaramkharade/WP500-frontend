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
import org.json.JSONArray;
import org.json.JSONObject;

import com.tas.utils.TCPClient;

/**
 * Servlet implementation class MQTTData
 */
@WebServlet("/mqttAddData")
public class MQTTAddData extends HttpServlet {
	private static final long serialVersionUID = 1L;
	final static Logger logger = Logger.getLogger(MQTTAddData.class);

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public MQTTAddData() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		// response.getWriter().append("Served at:
		// ").append(request.getContextPath());
		
		HttpSession session = request.getSession(false);

		if (session != null) {
			String check_username = (String) session.getAttribute("username");

		TCPClient client = new TCPClient();
		JSONObject json = new JSONObject();

		try {

			json.put("operation", "protocol");
			json.put("protocol_type", "mqtt");
			json.put("operation_type", "get_crt_files");
			json.put("user", check_username);

			String respStr = client.sendMessage(json.toString());

			System.out.println("res " + new JSONObject(respStr));
			logger.info("res " + new JSONObject(respStr));

			JSONObject result = new JSONObject(respStr);

			JSONArray crt_files_result = result.getJSONArray("result");

			JSONObject jsonObject = new JSONObject();
			jsonObject.put("crt_files_result", crt_files_result);

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
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		
		
		HttpSession session = request.getSession(false);

		if (session != null) {
			String check_username = (String) session.getAttribute("username");
			
			
			
		String broker_ip_address = request.getParameter("broker_ip_address");
		String port_number = request.getParameter("port_number");
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String sub_topic = request.getParameter("sub_topic");
		String pub_topic = request.getParameter("pub_topic");
		String prefix = request.getParameter("prefix");
		String file_type = request.getParameter("file_type");
		String enable = request.getParameter("enable");
		String file_name = request.getParameter("file_name");

		// System.out.println(firstName + " " + password);
		
		System.out.println("broker ip : "+broker_ip_address);
		System.out.println("file name : "+file_name);

		try {

			System.out.println("In mqtt...");
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();

			System.out.println("broker ip addr :" + broker_ip_address);
			json.put("operation", "protocol");
			json.put("protocol_type", "mqtt");
			json.put("operation_type", "add_query");
			json.put("user", check_username);
			
			json.put("broker_ip_address", broker_ip_address);
			json.put("port_number", port_number);
			json.put("username", username);
			json.put("password", password);
			json.put("subscribe_topic", sub_topic);
			json.put("publish_topic", pub_topic);
			json.put("prefix", prefix);
			json.put("file_type", file_type);
			json.put("enable", enable);
			json.put("file_name", file_name);
			

			String respStr = client.sendMessage(json.toString());

			System.out.println("res " + new JSONObject(respStr).getString("msg"));

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
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		}else{
			System.out.println("Login first");
			response.sendRedirect("login.jsp");
		}
		// doGet(request, response);
	}

}
