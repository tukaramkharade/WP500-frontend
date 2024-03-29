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

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		String check_role = (String) session.getAttribute("role");
		if (check_username != null) {
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();
			try {
				json.put("operation", "get_latest_five_active_threats");
				json.put("user", check_username);
				json.put("token", check_token);
				json.put("role", check_role);

				String respStr = client.sendMessage(json.toString());
				JSONObject respJson = new JSONObject(respStr);
				String status = respJson.getString("status");
				String message = respJson.getString("msg");
				logger.info("Active Threats response : " + respJson.toString());
				JSONObject finalJsonObj = new JSONObject();
				if (status.equals("success")) {
					JSONArray resultArr = respJson.getJSONArray("data");
					finalJsonObj.put("status", status);
					finalJsonObj.put("result", resultArr);
				} else if (status.equals("fail")) {
					finalJsonObj.put("status", status);
					finalJsonObj.put("message", message);
				}
				response.setContentType("application/json");
				response.setHeader("X-Content-Type-Options", "nosniff");
				response.getWriter().print(finalJsonObj.toString());
			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error getting latest active threats : " + e);
			}
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		String check_role = (String) session.getAttribute("role");
		String action = request.getParameter("action");
		SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd");
		SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		JSONObject lineChartResponse = null;
		JSONObject barChartResponse = null;
		String start_time = request.getParameter("start_time");
		String end_time = request.getParameter("end_time");
		if (start_time != null && !start_time.isEmpty()) {
			try {
				SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				Date startDate = dateTimeFormat.parse(start_time);
				startDate.setHours(0);
				startDate.setMinutes(0);
				startDate.setSeconds(0);
				SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
				start_time = dateFormat.format(startDate) + " 00:00:00";
			} catch (ParseException e) {
				e.printStackTrace();
			}
		}
		if (end_time != null && !end_time.isEmpty()) {
			try {
				SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				Date endDate = dateTimeFormat.parse(end_time);
				endDate.setHours(23);
				endDate.setMinutes(59);
				endDate.setSeconds(59);
				SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
				end_time = dateFormat.format(endDate) + " 23:59:59";
			} catch (ParseException e) {
				e.printStackTrace();
			}
		}
		Calendar calendar = null;
		Date startDate = null, currentDate = null, endDate = null;
		String startDateTime = null, endDateTime = null, formattedDate = null, formattedStartDay = null,
				formattedEndDay = null;
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
						e1.printStackTrace();
					}
					lineChartResponse = fetchThreatCountForLineChart(startDateTime, endDateTime, check_username,
							check_token, check_role);
					try {
						if (lineChartResponse.getBoolean("success")) {
							JSONObject chartData = lineChartResponse.getJSONObject("chartData");
							response.setContentType("application/json");
							PrintWriter out = response.getWriter();
							out.print(chartData.toString());
							out.flush();
						} else {
						}
					} catch (JSONException e) {
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
						e1.printStackTrace();
					}
					barChartResponse = fetchThreatPriorityCountForBarChart(startDateTime, endDateTime, check_username,
							check_token, check_role);
					try {
						if (barChartResponse.getBoolean("success")) {
							JSONObject dataObject = barChartResponse.getJSONObject("dataObject");
							response.setContentType("application/json");
							PrintWriter out = response.getWriter();
							out.print(dataObject.toString());
							out.flush();
						} else {
						}
					} catch (JSONException e1) {
						e1.printStackTrace();
					}
					break;

				case "threat_today_line":
					calendar = Calendar.getInstance();
					calendar.setTime(currentDate);
					calendar.set(Calendar.HOUR_OF_DAY, 0);
					calendar.set(Calendar.MINUTE, 0);
					calendar.set(Calendar.SECOND, 0);
					calendar.set(Calendar.MILLISECOND, 0);
					startDate = calendar.getTime();
					formattedStartDay = outputFormat.format(startDate);
					formattedDate = outputFormat.format(currentDate);
					lineChartResponse = fetchThreatCountForLineChart(formattedStartDay, formattedDate, check_username,
							check_token, check_role);
					try {
						if (lineChartResponse.getBoolean("success")) {
							JSONObject chartData = lineChartResponse.getJSONObject("chartData");
							response.setContentType("application/json");
							PrintWriter out = response.getWriter();
							out.print(chartData.toString());
							out.flush();
						} else {
						}
					} catch (JSONException e) {
						e.printStackTrace();
					}
					break;

				case "threat_today_bar":
					calendar = Calendar.getInstance();
					calendar.setTime(currentDate);
					calendar.set(Calendar.HOUR_OF_DAY, 0);
					calendar.set(Calendar.MINUTE, 0);
					calendar.set(Calendar.SECOND, 0);
					calendar.set(Calendar.MILLISECOND, 0);
					startDate = calendar.getTime();
					formattedStartDay = outputFormat.format(startDate);
					formattedDate = outputFormat.format(currentDate);
					barChartResponse = fetchThreatPriorityCountForBarChart(formattedStartDay, formattedDate,
							check_username, check_token, check_role);
					try {
						if (barChartResponse.getBoolean("success")) {
							JSONObject dataObject = barChartResponse.getJSONObject("dataObject");
							response.setContentType("application/json");
							PrintWriter out = response.getWriter();
							out.print(dataObject.toString());
							out.flush();
						} else {
						}
					} catch (JSONException e1) {
						e1.printStackTrace();
					}
					break;

				case "threat_yesterday_line":
					calendar = Calendar.getInstance();
					calendar.setTime(currentDate);
					calendar.add(Calendar.DAY_OF_MONTH, -1);
					calendar.set(Calendar.HOUR_OF_DAY, 0);
					calendar.set(Calendar.MINUTE, 0);
					calendar.set(Calendar.SECOND, 0);
					calendar.set(Calendar.MILLISECOND, 0);
					startDate = calendar.getTime();
					formattedStartDay = outputFormat.format(startDate);
					calendar = Calendar.getInstance();
					calendar.setTime(currentDate);
					calendar.add(Calendar.DAY_OF_MONTH, -1);
					calendar.set(Calendar.HOUR_OF_DAY, 23);
					calendar.set(Calendar.MINUTE, 59);
					calendar.set(Calendar.SECOND, 59);
					calendar.set(Calendar.MILLISECOND, 999);
					endDate = calendar.getTime();
					formattedEndDay = outputFormat.format(endDate);
					lineChartResponse = fetchThreatCountForLineChart(formattedStartDay, formattedEndDay, check_username,
							check_token, check_role);
					try {
						if (lineChartResponse.getBoolean("success")) {
							JSONObject chartData = lineChartResponse.getJSONObject("chartData");
							response.setContentType("application/json");
							PrintWriter out = response.getWriter();
							out.print(chartData.toString());
							out.flush();
						} else {
						}
					} catch (JSONException e) {
						e.printStackTrace();
					}
					break;

				case "threat_yesterday_bar":
					calendar = Calendar.getInstance();
					calendar.setTime(currentDate);
					calendar.add(Calendar.DAY_OF_MONTH, -1);
					calendar.set(Calendar.HOUR_OF_DAY, 0);
					calendar.set(Calendar.MINUTE, 0);
					calendar.set(Calendar.SECOND, 0);
					calendar.set(Calendar.MILLISECOND, 0);
					startDate = calendar.getTime();
					formattedStartDay = outputFormat.format(startDate);
					calendar = Calendar.getInstance();
					calendar.setTime(currentDate);
					calendar.add(Calendar.DAY_OF_MONTH, -1);
					calendar.set(Calendar.HOUR_OF_DAY, 23);
					calendar.set(Calendar.MINUTE, 59);
					calendar.set(Calendar.SECOND, 59);
					calendar.set(Calendar.MILLISECOND, 999);
					endDate = calendar.getTime();
					formattedEndDay = outputFormat.format(endDate);
					barChartResponse = fetchThreatPriorityCountForBarChart(formattedStartDay, formattedEndDay,
							check_username, check_token, check_role);
					try {
						if (barChartResponse.getBoolean("success")) {
							JSONObject dataObject = barChartResponse.getJSONObject("dataObject");
							response.setContentType("application/json");
							PrintWriter out = response.getWriter();
							out.print(dataObject.toString());
							out.flush();
						} else {
						}
					} catch (JSONException e1) {
						e1.printStackTrace();
					}
					break;

				case "threat_week_line":
					calendar = Calendar.getInstance();
					calendar.setFirstDayOfWeek(Calendar.SUNDAY);
					calendar.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);
					calendar.set(Calendar.HOUR_OF_DAY, 0);
					calendar.set(Calendar.MINUTE, 0);
					calendar.set(Calendar.SECOND, 0);
					formattedStartDay = outputFormat.format(calendar.getTime());
					lineChartResponse = fetchThreatCountForLineChart(formattedStartDay, formattedDate, check_username,
							check_token, check_role);
					try {
						if (lineChartResponse.getBoolean("success")) {
							JSONObject chartData = lineChartResponse.getJSONObject("chartData");
							response.setContentType("application/json");
							PrintWriter out = response.getWriter();
							out.print(chartData.toString());
							out.flush();
						} else {
						}
					} catch (JSONException e) {
						e.printStackTrace();
					}
					break;

				case "threat_week_bar":
					calendar = Calendar.getInstance();
					calendar.setFirstDayOfWeek(Calendar.SUNDAY);
					calendar.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);
					calendar.set(Calendar.HOUR_OF_DAY, 0);
					calendar.set(Calendar.MINUTE, 0);
					calendar.set(Calendar.SECOND, 0);
					formattedStartDay = outputFormat.format(calendar.getTime());
					barChartResponse = fetchThreatPriorityCountForBarChart(formattedStartDay, formattedDate,
							check_username, check_token, check_role);
					try {
						if (barChartResponse.getBoolean("success")) {
							JSONObject dataObject = barChartResponse.getJSONObject("dataObject");
							response.setContentType("application/json");
							PrintWriter out = response.getWriter();
							out.print(dataObject.toString());
							out.flush();
						} else {
						}
					} catch (JSONException e1) {
						e1.printStackTrace();
					}
					break;

				case "threat_month_line":
					calendar = Calendar.getInstance();
					calendar.set(Calendar.HOUR_OF_DAY, 0);
					calendar.set(Calendar.MINUTE, 0);
					calendar.set(Calendar.SECOND, 0);
					calendar.set(Calendar.MILLISECOND, 0);
					calendar.set(Calendar.DAY_OF_MONTH, 1);
					startDate = calendar.getTime();
					formattedStartDay = outputFormat.format(startDate);
					lineChartResponse = fetchThreatCountForLineChart(formattedStartDay, formattedDate, check_username,
							check_token, check_role);
					try {
						if (lineChartResponse.getBoolean("success")) {
							JSONObject chartData = lineChartResponse.getJSONObject("chartData");
							response.setContentType("application/json");
							PrintWriter out = response.getWriter();
							out.print(chartData.toString());
							out.flush();
						} else {
						}
					} catch (JSONException e) {
						e.printStackTrace();
					}
					break;

				case "threat_month_bar":
					calendar = Calendar.getInstance();
					calendar.set(Calendar.HOUR_OF_DAY, 0);
					calendar.set(Calendar.MINUTE, 0);
					calendar.set(Calendar.SECOND, 0);
					calendar.set(Calendar.MILLISECOND, 0);
					calendar.set(Calendar.DAY_OF_MONTH, 1);
					startDate = calendar.getTime();
					formattedStartDay = outputFormat.format(startDate);
					barChartResponse = fetchThreatPriorityCountForBarChart(formattedStartDay, formattedDate,
							check_username, check_token, check_role);
					try {
						if (barChartResponse.getBoolean("success")) {
							JSONObject dataObject = barChartResponse.getJSONObject("dataObject");
							response.setContentType("application/json");
							PrintWriter out = response.getWriter();
							out.print(dataObject.toString());
							out.flush();
						} else {
						}
					} catch (JSONException e1) {
						e1.printStackTrace();
					}
					break;

				case "snort_type":
					String snort_type = request.getParameter("snort_type");
					try {
						TCPClient client = new TCPClient();
						JSONObject json = new JSONObject();
						json.put("operation", "snort_details");
						json.put("user", check_username);
						json.put("token", check_token);
						json.put("snort_type", snort_type);
						json.put("role", check_role);

						String respStr = client.sendMessage(json.toString());
						logger.info("res " + new JSONObject(respStr).getString("msg"));
						String message = new JSONObject(respStr).getString("msg");
						JSONObject jsonObject = new JSONObject();
						jsonObject.put("message", message);
						response.setContentType("application/json");
						response.setHeader("X-Content-Type-Options", "nosniff");
						PrintWriter out = response.getWriter();
						out.print(jsonObject.toString());
						out.flush();
					} catch (Exception e) {
						e.printStackTrace();
						logger.error("Error fetching snort details: " + e);
					}
				}
			}
		}
	}

	private JSONObject fetchThreatCountForLineChart(String startTime, String endTime, String check_username,
		String check_token, String check_role) {
		JSONObject result = new JSONObject();
		JSONObject json = new JSONObject();
		TCPClient client = new TCPClient();
		try {
			json.put("operation", "get_count_Threats");
			json.put("start_time", startTime);
			json.put("end_time", endTime);
			json.put("user", check_username);
			json.put("token", check_token);
			json.put("role", check_role);

			String respStr = client.sendMessage(json.toString());
			logger.info("res " + new JSONObject(respStr));
			JSONObject jsonObject = new JSONObject(respStr);
			JSONObject dataObject = jsonObject.getJSONObject("data");
			List<String> keys = new ArrayList<>();
			Iterator<String> iterator = dataObject.keys();
			while (iterator.hasNext()) {
				keys.add(iterator.next());
			}
			Collections.sort(keys);
			JSONObject sortedDataObject = new JSONObject();
			for (String key : keys) {
				sortedDataObject.put(key, dataObject.get(key));
			}
			String[] keys1 = JSONObject.getNames(sortedDataObject.toString(4));
			List<String> dateLabels = new ArrayList<>();
			List<Integer> threatCountValues = new ArrayList<>();
			if (keys1 != null) {
				for (String date : keys) {
					int value = dataObject.getInt(date);
					dateLabels.add(date);
					threatCountValues.add(value);
				}
			}
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
				e1.printStackTrace();
			}
		}
		return result;
	}

	private JSONObject fetchThreatPriorityCountForBarChart(String startTime, String endTime, String check_username, String check_token, String check_role) {
		JSONObject result = new JSONObject();
		JSONObject json = new JSONObject();
		TCPClient client = new TCPClient();
		try {
			json.put("operation", "get_count_Threats_priority");
			json.put("start_time", startTime);
			json.put("end_time", endTime);
			json.put("user", check_username);
			json.put("token", check_token);
			json.put("role", check_role);

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
				e1.printStackTrace();
			}
		}
		return result;
	}
}