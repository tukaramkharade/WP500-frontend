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
import org.json.JSONException;
import org.json.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import com.tas.utils.TCPClient;

/**
 * Servlet implementation class JSONBuilderEditServlet
 */
@WebServlet("/jsonBuilderEditServlet")
public class JSONBuilderEditServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	final static Logger logger = Logger.getLogger(JSONBuilderEditServlet.class);

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public JSONBuilderEditServlet() {
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

		String check_username = (String) session.getAttribute("username");
		if (check_username != null) {
			

			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();

			try {

				json.put("operation", "protocol");
				json.put("protocol_type", "json_builder");
				json.put("operation_type", "get_query");
				json.put("user", check_username);

				String respStr = client.sendMessage(json.toString());

				JSONObject respJson = new JSONObject(respStr);

				System.out.println("res " + respJson.toString());

				JSONArray resJsonArray = new JSONArray();

				logger.info("JSON Builder response : " + respJson.toString());

				JSONArray resultArr = respJson.getJSONArray("result");

				System.out.println("Result : " + resultArr.toString());

				for (int i = 0; i < resultArr.length(); i++) {
					JSONObject jsObj = resultArr.getJSONObject(i);

					String json_string_name = jsObj.getString("json_string_name");
					logger.info("json_string_name : " + json_string_name);

					String json_interval = jsObj.getString("json_interval");
					
					
					
				//	logger.info("json_interval : " + json_interval);

					String broker_type = jsObj.getString("broker_type");
					logger.info("broker_type : " + broker_type);

					String broker_ip_address = jsObj.getString("broker_ip_address");
					logger.info("broker_ip_address : " + broker_ip_address);

					String publish_topic_name = jsObj.getString("publish_topic_name");
					logger.info("publish_topic_name : " + publish_topic_name);

					String publishing_status = jsObj.getString("publishing_status");
					logger.info("publishing_status : " + publishing_status);

					String store_n_forward = jsObj.getString("store_n_forward");
					logger.info("store_n_forward : " + store_n_forward);

					String json_string = jsObj.getString("json_string");
					logger.info("json_string : " + json_string);

					JSONObject jsonBuilderObj = new JSONObject();

					try {

						jsonBuilderObj.put("json_string_name", json_string_name);
					//	jsonBuilderObj.put("json_interval", json_interval);
						
						if(json_interval.equals("30")){
							jsonBuilderObj.put("json_interval", "30 sec");
						}else if(json_interval.equals("60")){
							jsonBuilderObj.put("json_interval", "1 min");
						}else if(json_interval.equals("300")){
							jsonBuilderObj.put("json_interval", "5 min");
						}else if(json_interval.equals("600")){
							jsonBuilderObj.put("json_interval", "10 min");
						}else if(json_interval.equals("900")){
							jsonBuilderObj.put("json_interval", "15 min");
						}else if(json_interval.equals("1200")){
							jsonBuilderObj.put("json_interval", "20 min");
						}else if(json_interval.equals("1500")){
							jsonBuilderObj.put("json_interval", "25 min");
						}else if(json_interval.equals("1800")){
							jsonBuilderObj.put("json_interval", "30 min");
						}else if(json_interval.equals("3600")){
							jsonBuilderObj.put("json_interval", "1 hour");
						}
						
						jsonBuilderObj.put("broker_type", broker_type);
						jsonBuilderObj.put("broker_ip_address", broker_ip_address);
						jsonBuilderObj.put("publish_topic_name", publish_topic_name);
						jsonBuilderObj.put("publishing_status", publishing_status);
						jsonBuilderObj.put("store_n_forward", store_n_forward);
						jsonBuilderObj.put("json_string", json_string);

						resJsonArray.put(jsonBuilderObj);
						// firewallObj.put("lastName", "");
					} catch (JSONException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}

				logger.info("JSON ARRAY :" + resJsonArray.length() + " " + resJsonArray.toString());

				response.setContentType("application/json");

				// Write the JSON data to the response
				response.getWriter().print(resJsonArray.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else {
//			System.out.println("Login first");
//			response.sendRedirect("login.jsp");
			
			
			try {
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

			try {

				TCPClient client = new TCPClient();
				JSONObject json = new JSONObject();

				json.put("operation", "protocol");
				json.put("protocol_type", "json_builder");
				json.put("operation_type", "update_query");
				json.put("user", check_username);

				JSONObject json_data = new JSONObject();
				json_data.put("json_string_name", json_string_name);
				//json_data.put("json_interval", jsonInterval);
				
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
				e.printStackTrace();
			}
		} else {
			System.out.println("Login first");
			response.sendRedirect("login.jsp");
		}
	}

}
