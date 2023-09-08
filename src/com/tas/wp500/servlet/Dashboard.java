package com.tas.wp500.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;

import com.tas.wp500.utils.TCPClient;

@WebServlet("/dashboard")
public class Dashboard extends HttpServlet {
	final static Logger logger = Logger.getLogger(Dashboard.class);
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		HttpSession session = request.getSession(false);	
		String check_username = (String) session.getAttribute("username");
		
		if(check_username != null){
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();
			
			try{
				json.put("operation", "get_latest_five_active_threats");
				json.put("user", check_username);
				
				String respStr = client.sendMessage(json.toString());

				JSONObject respJson = new JSONObject(respStr);

				JSONArray resJsonArray = new JSONArray();

				logger.info("Active Threats response : " + respJson.toString());
				
				JSONArray resultArr = respJson.getJSONArray("data");
				
				for (int i = 0; i < resultArr.length(); i++) {
					JSONObject jsObj = resultArr.getJSONObject(i);
					
					String timeStamp = jsObj.getString("timeStamp");
					String alertMessage = jsObj.getString("alertMessage");	
					String threat_id = jsObj.getString("threat_id");
					String priority = jsObj.getString("priority");
					
					JSONObject latestThreatsObj = new JSONObject();
					
					try{
						
						latestThreatsObj.put("timeStamp", timeStamp);
						latestThreatsObj.put("alertMessage", alertMessage);
						latestThreatsObj.put("threat_id", threat_id);
						latestThreatsObj.put("priority", priority);
						
						resJsonArray.put(latestThreatsObj);
						
					}catch(Exception e){
						e.printStackTrace();
						logger.error("Error in putting latest active threats data in json array : " + e);
					}
				}
				
				logger.info("JSON ARRAY :" + resJsonArray.toString());

				response.setContentType("application/json");

				// Write the JSON data to the response
				response.getWriter().print(resJsonArray.toString());
				
			}catch(Exception e){
				e.printStackTrace();
				logger.error("Error getting latest active threats : "+e);
			}
			
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
				logger.error("Error in session timeout : "+e);
			}
		}
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		HttpSession session = request.getSession(false);	
		String check_username = (String) session.getAttribute("username");		
		
		String start_time = request.getParameter("start_time");
		String end_time = request.getParameter("end_time");
		
		SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
		SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		
		Date startDate = null;
		Date endDate = null;
		
		try {
			startDate = inputFormat.parse(start_time);
			endDate = inputFormat.parse(end_time);
		} catch (ParseException e1) {
			e1.printStackTrace();
		}
		String startDateTime = outputFormat.format(startDate);		
		String endDateTime = outputFormat.format(endDate);
		
		
		if(check_username != null){
			
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();
			
			String action = request.getParameter("action");

			if (action != null) {
				switch (action) {
				
				case "threat_count" :
					
					try{
						
						json.put("operation", "get_count_Threats");
						json.put("start_time", startDateTime);
						json.put("end_time", endDateTime);
						json.put("user", check_username);
						
						String respStr = client.sendMessage(json.toString());

						logger.info("res " + new JSONObject(respStr));
						
						 JSONObject jsonObject = new JSONObject(respStr);
				         JSONObject dataObject = jsonObject.getJSONObject("data");
				         
				         String[] keys = JSONObject.getNames(dataObject);
				         
				         List<String> dateLabels = new ArrayList<>();
				         List<Integer> threatCountValues = new ArrayList<>();

				            if (keys != null) {
				                // Iterate over the keys (dates)
				            	for (String date : keys) {
				                    int value = dataObject.getInt(date);

				                    // Add date and value to respective arrays
				                    dateLabels.add(date);
				                    threatCountValues.add(value);
				                }
				            }
				            
				         // Prepare data for the line chart
				            JSONObject chartData = new JSONObject();
				            chartData.put("labels", dateLabels); // Use the dateLabels array
				            chartData.put("values", threatCountValues); // Use the threatCountValues array

				            
				            // Set the response content type to JSON
				            response.setContentType("application/json");
				            
				            // Write the JSON data to the response
				            PrintWriter out = response.getWriter();
				            out.print(chartData.toString());
				            out.flush();
				            
						
					}catch(Exception e){
						e.printStackTrace();
						logger.error("Error loading threats count day wise data : "+e);
					}
					break;
					
				case "threat_priority" :
					try{
						json.put("operation", "get_count_Threats_priority");
						json.put("start_time", startDateTime);
						json.put("end_time", endDateTime);
						json.put("user", check_username);
						
					}catch(Exception e){
						e.printStackTrace();
						logger.error("Error loading threats priority : "+e);
					}
					
					
				}
			}
				
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
				logger.error("Error in session timeout : "+e);
			}
		}
		
	}

}
