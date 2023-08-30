package com.tas.wp500.servlet;

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

import com.tas.wp500.utils.TCPClient;

@WebServlet("/storeForwardDataServlet")
public class StoreForwardDataServlet extends HttpServlet {
	final static Logger logger = Logger.getLogger(StoreForwardDataServlet.class);

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		TCPClient client = new TCPClient();
		JSONObject json = new JSONObject();

		try {
			HttpSession session = request.getSession(false);

			String check_username = (String) session.getAttribute("username");

			if (check_username != null) {
				json.put("operation", "get_store_forword_data");
				json.put("page_no", "1");

				String respStr = client.sendMessage(json.toString());

				JSONObject respJson = new JSONObject(respStr);
				
				String total_pages = respJson.getString("total_pages");
				System.out.println("total_pages-->"+total_pages);
				
				//String totalPageNo =respJson.getString("total_pages");
				
				JSONArray resJsonArray = new JSONArray();
				JSONObject totalPage = new JSONObject();
			
				totalPage.put("total_pages",total_pages);
				resJsonArray.put(totalPage);
				System.out.println(resJsonArray);
//				logger.info("Store Forword data value response : " + respJson.toString());

				JSONArray resultArr = respJson.getJSONArray("result");
				
				
				//System.out.println("TotalPagr-->>"+totalPageNo);
				String dateTime="";
				for (int i = 0; i < resultArr.length(); i++) {
					JSONObject jsObj = resultArr.getJSONObject(i);

					 dateTime = jsObj.getString("date_time");
					String dataString = jsObj.getString("data_string");
					String brokerIp = jsObj.getString("broker_ip");
					String publishTopic = jsObj.getString("publish_topic");
					
					
					JSONObject storeForwardObj = new JSONObject();
					
					try {
						storeForwardObj.put("dateTime", dateTime);
						storeForwardObj.put("dataString", dataString);
						storeForwardObj.put("brokerIp", brokerIp);
						storeForwardObj.put("publishTopic", publishTopic);
						
						resJsonArray.put(storeForwardObj);
					} catch (JSONException e) {
						e.printStackTrace();
						logger.error("Error in putting store forward data in json array : " + e);
					}
				}
				
//				logger.info("JSON ARRAY :" + resJsonArray.length() + " " + resJsonArray.toString());

				response.setContentType("application/json");

				// Write the JSON data to the response
				response.getWriter().print(resJsonArray.toString());
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
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("Error in getting store forward data: " + e);
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		TCPClient client = new TCPClient();
		JSONObject json = new JSONObject();

		try {
			HttpSession session = request.getSession(false);

			String check_username = (String) session.getAttribute("username");
			String currentPage = request.getParameter("currentPage");
			if (check_username != null) {
				json.put("operation", "get_store_forword_data");
				json.put("page_no", currentPage);
				System.out.println("Json-->"+json);
				String respStr = client.sendMessage(json.toString());

				JSONObject respJson = new JSONObject(respStr);
				
				String total_pages = respJson.getString("total_pages");
				System.out.println("total_pages-->"+total_pages);
				
				//String totalPageNo =respJson.getString("total_pages");
				
				JSONArray resJsonArray = new JSONArray();
				JSONObject totalPage = new JSONObject();
			
				totalPage.put("total_pages",total_pages);
				resJsonArray.put(totalPage);
				System.out.println(resJsonArray);
				logger.info("Store Forword data value response : " + respJson.toString());

				JSONArray resultArr = respJson.getJSONArray("result");
				
				
				//System.out.println("TotalPagr-->>"+totalPageNo);
				
				for (int i = 0; i < resultArr.length(); i++) {
					JSONObject jsObj = resultArr.getJSONObject(i);

					String dateTime = jsObj.getString("date_time");
					String dataString = jsObj.getString("data_string");
					String brokerIp = jsObj.getString("broker_ip");
					String publishTopic = jsObj.getString("publish_topic");
					
					
					JSONObject storeForwardObj = new JSONObject();
					
					try {
						storeForwardObj.put("dateTime", dateTime);
						storeForwardObj.put("dataString", dataString);
						storeForwardObj.put("brokerIp", brokerIp);
						storeForwardObj.put("publishTopic", publishTopic);
						
						resJsonArray.put(storeForwardObj);
					} catch (JSONException e) {
						e.printStackTrace();
						logger.error("Error in putting store forward data in json array : " + e);
					}
				}
				
				logger.info("JSON ARRAY :" + resJsonArray.length() + " " + resJsonArray.toString());

				response.setContentType("application/json");

				// Write the JSON data to the response
				response.getWriter().print(resJsonArray.toString());
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
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("Error in getting store forward data: " + e);
		}

	}
}
