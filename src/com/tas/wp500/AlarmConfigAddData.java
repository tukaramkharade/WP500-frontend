package com.tas.wp500;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.RequestDispatcher;
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
 * Servlet implementation class MQTTData
 */
@WebServlet("/alarmConfigAddData")
public class AlarmConfigAddData extends HttpServlet {
	private static final long serialVersionUID = 1L;
	final static Logger logger = Logger.getLogger(AlarmConfigAddData.class);

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public AlarmConfigAddData() {
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

			if (check_username != null) {

				try {

					System.out.println("In get alarm settings!");
					JSONArray resJsonArray = new JSONArray();

					TCPClient client = new TCPClient();
					JSONObject json = new JSONObject();

					json.put("operation", "protocol");
					json.put("protocol_type", "alarm");
					json.put("operation_type", "get_query");
					json.put("user", check_username);

					String respStr = client.sendMessage(json.toString());

					System.out.println("res " + new JSONObject(respStr));
					logger.info("res " + new JSONObject(respStr));

					JSONObject result = new JSONObject(respStr);

					JSONArray alarm_result = result.getJSONArray("result");

					System.out.println("Result : " + alarm_result.toString());

					for (int i = 0; i < alarm_result.length(); i++) {

						JSONObject jsObj = alarm_result.getJSONObject(i);

						String alarm_tag = jsObj.getString("alarm_tag");
						System.out.println("alarm tag : " + alarm_tag);

						String interval = jsObj.getString("intrval");
						System.out.println("Interval : " + interval);

						String broker_type = jsObj.getString("broker_type");
						System.out.println(" Broker_type : " + broker_type);

						String broker_ip = jsObj.getString("broker_ip");
						System.out.println("Broker_ip : " + broker_ip);

						String asset_id = jsObj.getString("asset_id");
						System.out.println("Asset id : " + asset_id);

						String unit_id = jsObj.getString("unit_id");
						System.out.println("Unit id : " + unit_id);

						JSONObject disObj = new JSONObject();

						try {

							disObj.put("alarm_tag", alarm_tag);
							// disObj.put("interval", interval);

							if (interval.equals("5")) {
								disObj.put("interval", "5 sec");
							} else if (interval.equals("10")) {
								disObj.put("interval", "10 sec");
							} else if (interval.equals("15")) {
								disObj.put("interval", "15 sec");
							} else if (interval.equals("20")) {
								disObj.put("interval", "20 sec");
							} else if (interval.equals("25")) {
								disObj.put("interval", "25 sec");
							} else if (interval.equals("30")) {
								disObj.put("interval", "30 sec");
							} else if (interval.equals("60")) {
								disObj.put("interval", "1 min");
							} else if (interval.equals("300")) {
								disObj.put("interval", "5 min");
							} else if (interval.equals("600")) {
								disObj.put("interval", "10 min");
							} else if (interval.equals("900")) {
								disObj.put("interval", "15 min");
							} else if (interval.equals("1200")) {
								disObj.put("interval", "20 min");
							} else if (interval.equals("1500")) {
								disObj.put("interval", "25 min");
							} else if (interval.equals("1800")) {
								disObj.put("interval", "30 min");
							} else if (interval.equals("3600")) {
								disObj.put("interval", "1 hour");
							}

							disObj.put("broker_type", broker_type);
							disObj.put("broker_ip", broker_ip);
							disObj.put("asset_id", asset_id);
							disObj.put("unit_id", unit_id);

							resJsonArray.put(disObj);
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
				}

			}

		} else {
			System.out.println("Invalid session");
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

			String unit_id = request.getParameter("unit_id");
			String asset_id = request.getParameter("asset_id");
			String broker_type = request.getParameter("broker_type");
			String broker_name = request.getParameter("broker_name");
			String interval = request.getParameter("interval");
			String tagData = request.getParameter("tagData");

			JSONParser parser = new JSONParser();
			org.json.simple.JSONObject json_string_con = null;
			try {
				json_string_con = (org.json.simple.JSONObject) parser.parse(tagData);
			} catch (ParseException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}

			System.out.println("tagData>" + tagData);

			try {

				System.out.println("In alarm config...");
				TCPClient client = new TCPClient();
				JSONObject json = new JSONObject();

				json.put("operation", "protocol");
				json.put("protocol_type", "alarm");
				json.put("operation_type", "add_query");

				json.put("id", "1");
				json.put("user", check_username);
				json.put("unit_id", unit_id);
				json.put("asset_id", asset_id);
				json.put("broker_type", broker_type);
				json.put("broker_ip", broker_name);
				// json.put("intrval", interval);

				if (interval.equals("5 sec")) {
					json.put("intrval", "5");
				}else if (interval.equals("10 sec")) {
					json.put("intrval", "10");
				}else if (interval.equals("15 sec")) {
					json.put("intrval", "15");
				}else if (interval.equals("20 sec")) {
					json.put("intrval", "20");
				}else if (interval.equals("25 sec")) {
					json.put("intrval", "25");
				} else if (interval.equals("30 sec")) {
					json.put("intrval", "30");
				} else if (interval.equals("1 min")) {
					json.put("intrval", "60");
				} else if (interval.equals("5 min")) {
					json.put("intrval", "300");
				} else if (interval.equals("10 min")) {
					json.put("intrval", "600");
				} else if (interval.equals("15 min")) {
					json.put("intrval", "900");
				} else if (interval.equals("20 min")) {
					json.put("intrval", "1200");
				} else if (interval.equals("25 min")) {
					json.put("intrval", "1500");
				} else if (interval.equals("30 min")) {
					json.put("intrval", "1800");
				} else if (interval.equals("1 hour")) {
					json.put("intrval", "3600");
				}

				json.put("alarm_tag", json_string_con);
				/*
				 * JSONObject json = new JSONObject();
				 * json.put(tag_name,tag_name_2);
				 */

				String respStr = client.sendMessage(json.toString());

				System.out.println("res " + new JSONObject(respStr));

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
		// doGet(request, response);
	}

}
