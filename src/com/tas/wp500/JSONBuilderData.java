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
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import com.tas.utils.TCPClient;

/**
 * Servlet implementation class JSONBuilderData
 */
@WebServlet("/jsonBuilderData")
public class JSONBuilderData extends HttpServlet {
	private static final long serialVersionUID = 1L;
	final static Logger logger = Logger.getLogger(JSONBuilderData.class);

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public JSONBuilderData() {
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

				// System.out.println("In json builder...");

				json.put("operation", "protocol");
				json.put("protocol_type", "json_builder");
				json.put("operation_type", "get_broker_ip");
				json.put("user", check_username);

				String respStr = client.sendMessage(json.toString());

				System.out.println("res " + new JSONObject(respStr));
				logger.info("res " + new JSONObject(respStr));

				JSONObject result = new JSONObject(respStr);

				JSONArray broker_ip_result = result.getJSONArray("result");

				JSONObject jsonObject = new JSONObject();
				jsonObject.put("broker_ip_result", broker_ip_result);

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
		// doGet(request, response);

		HttpSession session = request.getSession(false);

		if (session != null) {
			String check_username = (String) session.getAttribute("username");

			String json_string_name = request.getParameter("json_string_name");
			String jsonInterval = request.getParameter("json_interval");
			String broker_type = request.getParameter("broker_type");
			String broker_name = request.getParameter("broker_name");
			String publishTopic = request.getParameter("publish_topic");
			String publishStatus = request.getParameter("publishing_status");
			String storeAndForward = request.getParameter("storeAndForward");
			String json_string_text = request.getParameter("json_string_text");
			

			JSONParser parser = new JSONParser();
			org.json.simple.JSONObject json_string_con = null;
			try {
				json_string_con = (org.json.simple.JSONObject) parser.parse(json_string_text);
			} catch (ParseException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			// System.out.println(firstName + " " + password);

			try {

				System.out.println("store forward : " + storeAndForward);
				TCPClient client = new TCPClient();
				JSONObject json = new JSONObject();

				json.put("operation", "protocol");
				json.put("protocol_type", "json_builder");
				json.put("operation_type", "add_query");
				json.put("user", check_username);

				JSONObject json_data = new JSONObject();
				json_data.put("json_string_name", json_string_name);
			//	json_data.put("json_interval", jsonInterval);
				
				if(jsonInterval.equals("30 sec")){
					json_data.put("json_interval", "30");
				}else if(jsonInterval.equals("1 min")){
					json_data.put("json_interval", "60");
				}else if(jsonInterval.equals("5 min")){
					json_data.put("json_interval", "300");
				}else if(jsonInterval.equals("10 min")){
					json_data.put("json_interval", "600");
				}else if(jsonInterval.equals("15 min")){
					json_data.put("json_interval", "900");
				}else if(jsonInterval.equals("20 min")){
					json_data.put("json_interval", "1200");
				}else if(jsonInterval.equals("25 min")){
					json_data.put("json_interval", "1500");
				}else if(jsonInterval.equals("30 min")){
					json_data.put("json_interval", "1800");
				}else if(jsonInterval.equals("1 hour")){
					json_data.put("json_interval", "3600");
				}
				
				json_data.put("broker_type", broker_type);
				json_data.put("broker_ip_address", broker_name);
				json_data.put("publish_topic_name", publishTopic);
				json_data.put("publishing_status", publishStatus);
				json_data.put("store_n_forward", storeAndForward);

				// JSONObject json_string = new JSONObject();
				json_data.put("json_string", json_string_con);

				// json_data.put("json_string", json_string);
				json.put("Data", json_data);

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
		} else {
			System.out.println("Login first");
			response.sendRedirect("login.jsp");
		}
	}

}
