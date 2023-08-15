package com.tas.wp500;

import java.io.IOException;
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

import com.tas.utils.TCPClient;

/**
 * Servlet implementation class StratonLiveDataServlet
 */
@WebServlet("/storeForwardDataServlet")
public class StoreForwardDataServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	final static Logger logger = Logger.getLogger(StoreForwardDataServlet.class);

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public StoreForwardDataServlet() {
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

		
		
		TCPClient client = new TCPClient();
		JSONObject json = new JSONObject();

		try {

			
			HttpSession session = request.getSession(false);

			System.out.println(">> " + session.getAttribute("username"));
			
			String check_username = (String) session.getAttribute("username");
			
			if (check_username != null) {
			json.put("operation", "get_store_forword_data");

			String respStr = client.sendMessage(json.toString());

			JSONObject respJson = new JSONObject(respStr);

			System.out.println("res " + respJson.toString());

			JSONArray resJsonArray = new JSONArray();

			logger.info("Store Forword data value response : " + respJson.toString());

			JSONArray resultArr = respJson.getJSONArray("result");

			System.out.println("Result : " + resultArr.toString());

			for (int i = 0; i < resultArr.length(); i++) {
				JSONObject jsObj = resultArr.getJSONObject(i);

				String dateTime = jsObj.getString("date_time");
				logger.info("dateTime : " + dateTime);

				String dataString = jsObj.getString("data_string");
				logger.info("dataString : " + dataString);

				String brokerIp = jsObj.getString("broker_ip");
				logger.info("brokerIp : " + brokerIp);

				String publishTopic = jsObj.getString("publish_topic");
				logger.info("publishTopic : " + publishTopic);

				

				JSONObject storeForwardObj = new JSONObject();

				try {

					storeForwardObj.put("dateTime", dateTime);
					storeForwardObj.put("dataString", dataString);
					storeForwardObj.put("brokerIp", brokerIp);
					storeForwardObj.put("publishTopic", publishTopic);

					resJsonArray.put(storeForwardObj);
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
			}else{
				
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
		} catch (Exception e) {
			e.printStackTrace();
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
	}

}
