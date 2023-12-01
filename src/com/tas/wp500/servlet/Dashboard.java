package com.tas.wp500.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringReader;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import javax.json.Json;
import javax.json.JsonObject;
import javax.json.JsonReader;
import javax.json.JsonValue;
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

import com.google.gson.Gson;
import com.tas.wp500.utils.TCPClient;

@WebServlet("/dashboard")
public class Dashboard extends HttpServlet {
	final static Logger logger = Logger.getLogger(Dashboard.class);

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");

		if (check_username != null) {
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();

			try {
				json.put("operation", "get_latest_five_active_threats");
				json.put("user", check_username);
				json.put("token", check_token);

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

					try {

						latestThreatsObj.put("timeStamp", timeStamp);
						latestThreatsObj.put("alertMessage", alertMessage);
						latestThreatsObj.put("threat_id", threat_id);
						latestThreatsObj.put("priority", priority);

						resJsonArray.put(latestThreatsObj);

					} catch (Exception e) {
						e.printStackTrace();
						logger.error("Error in putting latest active threats data in json array : " + e);
					}
				}

				logger.info("JSON ARRAY :" + resJsonArray.toString());

				response.setContentType("application/json");

				// Write the JSON data to the response
				response.getWriter().print(resJsonArray.toString());

			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error getting latest active threats : " + e);
			}

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
	}
	
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		
		HttpSession session = request.getSession(false);
		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		
		String action = request.getParameter("action");
		
		SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");		
		SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		JSONObject lineChartResponse = null;
		JSONObject barChartResponse = null;
		
		
		String start_time = request.getParameter("start_time");
		String end_time = request.getParameter("end_time");
		Calendar calendar = null;
		Date startDate = null, currentDate = null, endDate = null;
		String startDateTime = null, endDateTime = null, formattedDate = null, formattedStartDay = null, formattedEndDay = null;
			
		//set current date time
		currentDate = new Date();
		formattedDate = outputFormat.format(currentDate);
			
		if (check_username != null) {
			
			if (action != null) {
				switch (action) {
			case "threat_count":
				
					try {
						startDate = inputFormat.parse(start_time);
						startDateTime = outputFormat.format(startDate);
						endDate = inputFormat.parse(end_time);
						endDateTime = outputFormat.format(endDate);
					} catch (ParseException e1) {
						// TODO Auto-generated catch block
						e1.printStackTrace();
					}
				
					lineChartResponse = fetchThreatCountForLineChart(startDateTime, endDateTime, check_username, check_token);
					try {
						if (lineChartResponse.getBoolean("success")) {
						    JSONObject chartData = lineChartResponse.getJSONObject("chartData");
						    response.setContentType("application/json");
						    PrintWriter out = response.getWriter();
						    out.print(chartData.toString());
						    out.flush();
						} else {
						    // Handle the error case here
						}
					} catch (JSONException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
			    break;
			    
			case "threat_priority":
				
				try {
					startDate = inputFormat.parse(start_time);
					startDateTime = outputFormat.format(startDate);
					endDate = inputFormat.parse(end_time);
					endDateTime = outputFormat.format(endDate);
				} catch (ParseException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				
				 barChartResponse = fetchThreatPriorityCountForBarChart(startDateTime,endDateTime, check_username, check_token);
					try {
						if (barChartResponse.getBoolean("success")) {
						    JSONObject dataObject = barChartResponse.getJSONObject("dataObject");
						    response.setContentType("application/json");
						    PrintWriter out = response.getWriter();
						    out.print(dataObject.toString());
						    out.flush();
						} else {
						    // Handle the error case here
						}
					} catch (JSONException e1) {
						// TODO Auto-generated catch block
						e1.printStackTrace();
					}
			    break;
			    
			case "threat_today_line":
				
				// Create a Calendar object and set it to the current date
				
				calendar = Calendar.getInstance();
				calendar.setTime(currentDate);

				// Set the time part to midnight (00:00:00)
				calendar.set(Calendar.HOUR_OF_DAY, 0);
				calendar.set(Calendar.MINUTE, 0);
				calendar.set(Calendar.SECOND, 0);
				calendar.set(Calendar.MILLISECOND, 0);

				// Get the start of the day
				startDate = calendar.getTime();

				// Format the start of the day using SimpleDateFormat
				 formattedStartDay = outputFormat.format(startDate);
				 formattedDate = outputFormat.format(currentDate);
				 
				 lineChartResponse = fetchThreatCountForLineChart(formattedStartDay, formattedDate, check_username, check_token);
					try {
						if (lineChartResponse.getBoolean("success")) {
						    JSONObject chartData = lineChartResponse.getJSONObject("chartData");
						    response.setContentType("application/json");
						    PrintWriter out = response.getWriter();
						    out.print(chartData.toString());
						    out.flush();
						} else {
						    // Handle the error case here
						}
					} catch (JSONException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
			    break;

			case "threat_today_bar":

				calendar = Calendar.getInstance();
				calendar.setTime(currentDate);

				// Set the time part to midnight (00:00:00)
				calendar.set(Calendar.HOUR_OF_DAY, 0);
				calendar.set(Calendar.MINUTE, 0);
				calendar.set(Calendar.SECOND, 0);
				calendar.set(Calendar.MILLISECOND, 0);

				// Get the start of the day
				startDate = calendar.getTime();

				// Format the start of the day using SimpleDateFormat
				 formattedStartDay = outputFormat.format(startDate);
				 formattedDate = outputFormat.format(currentDate);
				 
				 barChartResponse = fetchThreatPriorityCountForBarChart(formattedStartDay, formattedDate, check_username, check_token);
					try {
						if (barChartResponse.getBoolean("success")) {
						    JSONObject dataObject = barChartResponse.getJSONObject("dataObject");
						    response.setContentType("application/json");
						    PrintWriter out = response.getWriter();
						    out.print(dataObject.toString());
						    out.flush();
						} else {
						    // Handle the error case here
						}
					} catch (JSONException e1) {
						// TODO Auto-generated catch block
						e1.printStackTrace();
					}
			    break;
				 
				 
				
			case "threat_yesterday_line":
				
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
				 startDate = calendar.getTime();

				// Format and print the result
				 formattedStartDay = outputFormat.format(startDate);
				 
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
					 endDate = calendar.getTime();

					// Format and print the result
					 formattedEndDay = outputFormat.format(endDate);
					 
					 lineChartResponse = fetchThreatCountForLineChart(formattedStartDay, formattedEndDay, check_username, check_token);
						try {
							if (lineChartResponse.getBoolean("success")) {
							    JSONObject chartData = lineChartResponse.getJSONObject("chartData");
							    response.setContentType("application/json");
							    PrintWriter out = response.getWriter();
							    out.print(chartData.toString());
							    out.flush();
							} else {
							    // Handle the error case here
							}
						} catch (JSONException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
				    break;
				    
			case "threat_yesterday_bar":
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
				 startDate = calendar.getTime();

				// Format and print the result
				 formattedStartDay = outputFormat.format(startDate);
				 
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
					 endDate = calendar.getTime();

					// Format and print the result
					 formattedEndDay = outputFormat.format(endDate);
					 
					 barChartResponse = fetchThreatPriorityCountForBarChart(formattedStartDay, formattedEndDay, check_username, check_token);
						try {
							if (barChartResponse.getBoolean("success")) {
							    JSONObject dataObject = barChartResponse.getJSONObject("dataObject");
							    response.setContentType("application/json");
							    PrintWriter out = response.getWriter();
							    out.print(dataObject.toString());
							    out.flush();
							} else {
							    // Handle the error case here
							}
						} catch (JSONException e1) {
							// TODO Auto-generated catch block
							e1.printStackTrace();
						}
				    break;
				
					 
			case "threat_week_line":
				calendar = Calendar.getInstance();
				
				// Set Sunday as the first day of the week
				calendar.setFirstDayOfWeek(Calendar.SUNDAY);
				
				// Set the current date and time to the start of the week
				calendar.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);
				calendar.set(Calendar.HOUR_OF_DAY, 0);
				calendar.set(Calendar.MINUTE, 0);
				calendar.set(Calendar.SECOND, 0);
				
				// Format the current date and time as a string
				formattedStartDay = outputFormat.format(calendar.getTime());
				
				lineChartResponse = fetchThreatCountForLineChart(formattedStartDay, formattedDate, check_username, check_token);
				try {
					if (lineChartResponse.getBoolean("success")) {
					    JSONObject chartData = lineChartResponse.getJSONObject("chartData");
					    response.setContentType("application/json");
					    PrintWriter out = response.getWriter();
					    out.print(chartData.toString());
					    out.flush();
					} else {
					    // Handle the error case here
					}
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
		    break;
		    
			case "threat_week_bar":
				calendar = Calendar.getInstance();
				
				// Set Sunday as the first day of the week
				calendar.setFirstDayOfWeek(Calendar.SUNDAY);
				
				// Set the current date and time to the start of the week
				calendar.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);
				calendar.set(Calendar.HOUR_OF_DAY, 0);
				calendar.set(Calendar.MINUTE, 0);
				calendar.set(Calendar.SECOND, 0);
				
				// Format the current date and time as a string
				formattedStartDay = outputFormat.format(calendar.getTime());
				
				barChartResponse = fetchThreatPriorityCountForBarChart(formattedStartDay, formattedDate, check_username, check_token);
				try {
					if (barChartResponse.getBoolean("success")) {
					    JSONObject dataObject = barChartResponse.getJSONObject("dataObject");
					    response.setContentType("application/json");
					    PrintWriter out = response.getWriter();
					    out.print(dataObject.toString());
					    out.flush();
					} else {
					    // Handle the error case here
					}
				} catch (JSONException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
		    break;
				
			case "threat_month_line":	
				calendar = Calendar.getInstance();
				// Set the time to 12:00 midnight
				calendar.set(Calendar.HOUR_OF_DAY, 0);
				calendar.set(Calendar.MINUTE, 0);
				calendar.set(Calendar.SECOND, 0);
				calendar.set(Calendar.MILLISECOND, 0);

				// Set the day of the month to 1 (start of the month)
				calendar.set(Calendar.DAY_OF_MONTH, 1);

				// Get the Date object representing the start date and time of the current month
				startDate = calendar.getTime();

				// Format the date and print it
				 formattedStartDay = outputFormat.format(startDate);
				 
				 lineChartResponse = fetchThreatCountForLineChart(formattedStartDay, formattedDate, check_username, check_token);
					try {
						if (lineChartResponse.getBoolean("success")) {
						    JSONObject chartData = lineChartResponse.getJSONObject("chartData");
						    response.setContentType("application/json");
						    PrintWriter out = response.getWriter();
						    out.print(chartData.toString());
						    out.flush();
						} else {
						    // Handle the error case here
						}
					} catch (JSONException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
			    break;
			    
			case "threat_month_bar":
				calendar = Calendar.getInstance();
				// Set the time to 12:00 midnight
				calendar.set(Calendar.HOUR_OF_DAY, 0);
				calendar.set(Calendar.MINUTE, 0);
				calendar.set(Calendar.SECOND, 0);
				calendar.set(Calendar.MILLISECOND, 0);

				// Set the day of the month to 1 (start of the month)
				calendar.set(Calendar.DAY_OF_MONTH, 1);

				// Get the Date object representing the start date and time of the current month
				startDate = calendar.getTime();

				// Format the date and print it
				 formattedStartDay = outputFormat.format(startDate);
				 
				 barChartResponse = fetchThreatPriorityCountForBarChart(formattedStartDay, formattedDate, check_username, check_token);
					try {
						if (barChartResponse.getBoolean("success")) {
						    JSONObject dataObject = barChartResponse.getJSONObject("dataObject");
						    response.setContentType("application/json");
						    PrintWriter out = response.getWriter();
						    out.print(dataObject.toString());
						    out.flush();
						} else {
						    // Handle the error case here
						}
					} catch (JSONException e1) {
						// TODO Auto-generated catch block
						e1.printStackTrace();
					}
				break;
				
			case "snort_type":
				
				String snort_type = request.getParameter("snort_type");
				
				try{
					
					TCPClient client = new TCPClient();
					JSONObject json = new JSONObject();

					json.put("operation", "snort_details");
					json.put("user", check_username);
					json.put("token", check_token);
					json.put("snort_type", snort_type);
					
					String respStr = client.sendMessage(json.toString());

					logger.info("res " + new JSONObject(respStr).getString("msg"));

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
					
				}catch(Exception e){
					e.printStackTrace();
					logger.error("Error fetching snort details: " + e);
				}
				}
			}
		}else{
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
		
		
	}
	
	private JSONObject fetchThreatCountForLineChart(String startTime, String endTime, String check_username, String check_token) {
	    JSONObject result = new JSONObject();
	    JSONObject json = new JSONObject();
	    TCPClient client = new TCPClient();

	    try {
	       
	        json.put("operation", "get_count_Threats");
	        json.put("start_time", startTime);
	        json.put("end_time", endTime);
	        json.put("user", check_username);
	        json.put("token", check_token);

	        String respStr = client.sendMessage(json.toString());

	        logger.info("res " + new JSONObject(respStr));

	        JSONObject jsonObject = new JSONObject(respStr);
	        JSONObject dataObject = jsonObject.getJSONObject("data");

	     // Extract the keys (dates) into a list
	        List<String> keys = new ArrayList<>();
	        Iterator<String> iterator = dataObject.keys();
	        while (iterator.hasNext()) {
	            keys.add(iterator.next());
	        }

	        // Sort the list of keys
	        Collections.sort(keys);

	        // Create a new JSONObject with the sorted keys
	        JSONObject sortedDataObject = new JSONObject();
	        for (String key : keys) {
	            sortedDataObject.put(key, dataObject.get(key));
	        }
        
	        String[] keys1 = JSONObject.getNames(sortedDataObject.toString(4));

			List<String> dateLabels = new ArrayList<>();
			List<Integer> threatCountValues = new ArrayList<>();

			if (keys1 != null) {
				// Iterate over the keys (dates)
				for (String date : keys) {
					int value = dataObject.getInt(date);

					// Add date and value to respective arrays
					dateLabels.add(date);
					threatCountValues.add(value);
												
				}
				System.out.println(dateLabels + " " + threatCountValues);
			}

			// Prepare data for the line chart
			JSONObject chartData = new JSONObject();
			chartData.put("labels", dateLabels); // Use the dateLabels array
			chartData.put("values", threatCountValues); // Use the threatCountValues array
			
	        result.put("success", true);
	        result.put("chartData", chartData);
	    } catch (Exception e) {
	        e.printStackTrace();
	        logger.error("Error fetching threat data for the specified time range: " + e);
	      
	        try {
	        	  result.put("success", false);
				result.put("error", "Error fetching threat data.");
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
	    }

	    return result;
	}
	
	
	private JSONObject fetchThreatPriorityCountForBarChart(String startTime, String endTime, String check_username, String check_token) {
		
		JSONObject result = new JSONObject();
		 JSONObject json = new JSONObject();
		    TCPClient client = new TCPClient();

	    try {
	        
	        json.put("operation", "get_count_Threats_priority");
	        json.put("start_time", startTime);
	        json.put("end_time", endTime);
	        json.put("user", check_username);
	        json.put("token", check_token);

	        String respStr = client.sendMessage(json.toString());

	        logger.info("res " + new JSONObject(respStr));

	        JSONObject jsonObject = new JSONObject(respStr);
	        JSONObject dataObject = jsonObject.getJSONObject("data");

	        result.put("success", true);
	        result.put("dataObject", dataObject);
	    } catch (Exception e) {
	        e.printStackTrace();
	        logger.error("Error fetching threat priority details for current month : " + e);
	        try {
				result.put("success", false);
				result.put("error", "Error fetching threat priority details.");
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
	        
	    }

	    return result;

	}

}
