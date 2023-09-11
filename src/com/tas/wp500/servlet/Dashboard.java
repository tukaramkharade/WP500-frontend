package com.tas.wp500.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
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
		
		
		//current date time
		Date currentDate = new Date();

        // Create a Calendar object and set it to the current date
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(currentDate);

        // Set the time part to midnight (00:00:00)
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MILLISECOND, 0);

        // Get the start of the day
        Date startOfDay = calendar.getTime();

        // Format the start of the day using SimpleDateFormat
        String formattedStartOfDay = outputFormat.format(startOfDay);
      
        logger.info("Start of the day: " + formattedStartOfDay);
        
   
        // Format the current date using SimpleDateFormat
        String formattedDate = outputFormat.format(currentDate);

        logger.info("Current Date: " + formattedDate);
		
		//---------------yesterday start date time---------------------------------------
        
        // Create a Calendar instance and set it to the current date
         calendar = Calendar.getInstance();
        calendar.setTime(currentDate);

        // Subtract one day from the current date
        calendar.add(Calendar.DAY_OF_MONTH, -1);

        // Set the time part of the date to midnight (00:00:00)
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MILLISECOND, 0);

        // Get the resulting date
        Date yesterdayStartDate = calendar.getTime();

        
        // Format and print the result
        String formattedDateStartYesterday = outputFormat.format(yesterdayStartDate);
        
     
      //---------------yesterday end date time---------------------------------------
        
        // Create a Calendar instance and set it to the current date
         calendar = Calendar.getInstance();
        calendar.setTime(currentDate);

        // Subtract one day from the current date
        calendar.add(Calendar.DAY_OF_MONTH, -1);

        // Set the time part of the date to the end of the day (23:59:59)
        calendar.set(Calendar.HOUR_OF_DAY, 23);
        calendar.set(Calendar.MINUTE, 59);
        calendar.set(Calendar.SECOND, 59);
        calendar.set(Calendar.MILLISECOND, 999);

        // Get the resulting date
        Date yesterdayEndDate = calendar.getTime();

        // Format and print the result
        String formattedDateEndYesterday = outputFormat.format(yesterdayEndDate);
        
        //----------------current week start day-----------------------
        
        
        Calendar calendar1 = Calendar.getInstance();

        // Set Sunday as the first day of the week
        calendar1.setFirstDayOfWeek(Calendar.SUNDAY);

        // Set the current date and time to the start of the week
        calendar1.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);
        calendar1.set(Calendar.HOUR_OF_DAY, 0);
        calendar1.set(Calendar.MINUTE, 0);
        calendar1.set(Calendar.SECOND, 0);


        // Format the current date and time as a string
        String formattedDateWeekStart = outputFormat.format(calendar1.getTime());

        
        //----------------current month start day--------------------------------------
        
        Calendar calendar2 = Calendar.getInstance();

        // Set the time to 12:00 midnight
        calendar2.set(Calendar.HOUR_OF_DAY, 0);
        calendar2.set(Calendar.MINUTE, 0);
        calendar2.set(Calendar.SECOND, 0);
        calendar2.set(Calendar.MILLISECOND, 0);

        // Set the day of the month to 1 (start of the month)
        calendar2.set(Calendar.DAY_OF_MONTH, 1);

        // Get the Date object representing the start date and time of the current month
         startDate = calendar2.getTime();

       
        // Format the date and print it
        String formattedDateStartMonth = outputFormat.format(startDate);
        
        //-------------------------------------------------------------------
        
        
		if(check_username != null){
			
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();
			
			String action = request.getParameter("action");

			if (action != null) {
				switch (action) {
				
				case "threat_count" :
					
					try{
						startDate = inputFormat.parse(start_time);
						String startDateTime = outputFormat.format(startDate);	
						endDate = inputFormat.parse(end_time);							
						String endDateTime = outputFormat.format(endDate);
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
						
						startDate = inputFormat.parse(start_time);
						String startDateTime = outputFormat.format(startDate);	
						endDate = inputFormat.parse(end_time);							
						String endDateTime = outputFormat.format(endDate);
						
						json.put("operation", "get_count_Threats_priority");
						json.put("start_time", startDateTime);
						json.put("end_time", endDateTime);
						json.put("user", check_username);
						
						String respStr = client.sendMessage(json.toString());

						logger.info("res " + new JSONObject(respStr));
						
						JSONObject jsonObject = new JSONObject(respStr);
				        JSONObject dataObject = jsonObject.getJSONObject("data");
				        
				        System.out.println("Data obj : "+dataObject);
				     

				        // Set the response content type to JSON
				        response.setContentType("application/json");

				        // Write the JSON data to the response
				        PrintWriter out = response.getWriter();
				        out.print(dataObject.toString());
				        out.flush();
						
						
					}catch(Exception e){
						e.printStackTrace();
						logger.error("Error loading threats priority : "+e);
					}
					break;
					
				case "threat_today_line" :
					
			        try{
			        	
			        	json.put("operation", "get_count_Threats");
						json.put("start_time", formattedStartOfDay);
						json.put("end_time", formattedDate);
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
			        	logger.error("Error fetching threat count data for current date : "+e);
			        }
			        break;
			        
				case "threat_today_bar" :
					
					try{
						
						json.put("operation", "get_count_Threats_priority");
						json.put("start_time", formattedStartOfDay);
						json.put("end_time", formattedDate);
						json.put("user", check_username);
						
						String respStr = client.sendMessage(json.toString());

						logger.info("res " + new JSONObject(respStr));
						
						JSONObject jsonObject = new JSONObject(respStr);
				        JSONObject dataObject = jsonObject.getJSONObject("data");
				        
				        System.out.println("Data obj : "+dataObject);
				     

				        // Set the response content type to JSON
				        response.setContentType("application/json");

				        // Write the JSON data to the response
				        PrintWriter out = response.getWriter();
				        out.print(dataObject.toString());
				        out.flush();
						
						
					}catch(Exception e){
						e.printStackTrace();
						logger.error("Error fetching threat priority count for current date : "+e);
					}
					break;
					
				case "threat_yesterday_line" :
					
					try{
						json.put("operation", "get_count_Threats");
						json.put("start_time", formattedDateStartYesterday);
						json.put("end_time", formattedDateEndYesterday);
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
						logger.error("Error fetching threat count details for yesterday : "+e);
					}
					break;
					
				case "threat_yesterday_bar" :
					
					try{
						
						json.put("operation", "get_count_Threats_priority");
						json.put("start_time", formattedDateStartYesterday);
						json.put("end_time", formattedDateEndYesterday);
						json.put("user", check_username);
						
						String respStr = client.sendMessage(json.toString());

						logger.info("res " + new JSONObject(respStr));
						
						JSONObject jsonObject = new JSONObject(respStr);
				        JSONObject dataObject = jsonObject.getJSONObject("data");
				        
				        System.out.println("Data obj : "+dataObject);
				     

				        // Set the response content type to JSON
				        response.setContentType("application/json");

				        // Write the JSON data to the response
				        PrintWriter out = response.getWriter();
				        out.print(dataObject.toString());
				        out.flush();
						
						
					}catch(Exception e){
						e.printStackTrace();
						logger.error("Error fetching threat priority details for yesterday : "+e);
					}
					break;
					
				case "threat_week_line" :
					
					try{
						
						json.put("operation", "get_count_Threats");
						json.put("start_time", formattedDateWeekStart);
						json.put("end_time", formattedDate);
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
						logger.error("Error fetching threat count details for current week : "+e);
					}
					break;
					
				case "threat_week_bar" :
					try{
						
						json.put("operation", "get_count_Threats_priority");
						json.put("start_time", formattedDateWeekStart);
						json.put("end_time", formattedDate);
						json.put("user", check_username);
						
						String respStr = client.sendMessage(json.toString());

						logger.info("res " + new JSONObject(respStr));
						
						JSONObject jsonObject = new JSONObject(respStr);
				        JSONObject dataObject = jsonObject.getJSONObject("data");
				        
				        System.out.println("Data obj : "+dataObject);
				     

				        // Set the response content type to JSON
				        response.setContentType("application/json");

				        // Write the JSON data to the response
				        PrintWriter out = response.getWriter();
				        out.print(dataObject.toString());
				        out.flush();
						
					}catch(Exception e){
						e.printStackTrace();
						logger.error("Error fetching threat priority details for current week : "+e);
					}
					break;
					
				case "threat_month_line" :
					try{
						json.put("operation", "get_count_Threats");
						json.put("start_time", formattedDateStartMonth);
						json.put("end_time", formattedDate);
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
						logger.error("Error fetching threat count details for current month : "+e);
					}
					break;
					
				case "threat_month_bar" :
					try{
						json.put("operation", "get_count_Threats_priority");
						json.put("start_time", formattedDateStartMonth);
						json.put("end_time", formattedDate);
						json.put("user", check_username);
						
						String respStr = client.sendMessage(json.toString());

						logger.info("res " + new JSONObject(respStr));
						
						JSONObject jsonObject = new JSONObject(respStr);
				        JSONObject dataObject = jsonObject.getJSONObject("data");
				        
				        System.out.println("Data obj : "+dataObject);
				     

				        // Set the response content type to JSON
				        response.setContentType("application/json");

				        // Write the JSON data to the response
				        PrintWriter out = response.getWriter();
				        out.print(dataObject.toString());
				        out.flush();
					}catch(Exception e){
						e.printStackTrace();
						logger.error("Error fetching threat priority details for current month : "+e);
					}
					break;
					
									
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
