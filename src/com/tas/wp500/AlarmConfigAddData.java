package com.tas.wp500;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
		
		try{
			
			System.out.println("In get alarm settings!");
			JSONArray resJsonArray = new JSONArray();
			
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();
			
			
			json.put("operation", "protocol");
			json.put("protocol_type", "alarm");
			json.put("operation_type", "get_query");
			json.put("username", "admin");
			
			String respStr = client.sendMessage(json.toString());
			
			System.out.println("res " + new JSONObject(respStr));
			logger.info("res " + new JSONObject(respStr));
			
			JSONObject result = new JSONObject(respStr);
			
			JSONArray alarm_result = result.getJSONArray("result");
			
			System.out.println("Result : " + alarm_result.toString());

			for (int i = 0; i < alarm_result.length(); i++) {
				
				JSONObject jsObj = alarm_result.getJSONObject(i);
				
				JSONObject alarm_tag = jsObj.getJSONObject("alarm_tag");
				System.out.println("alarm tag : "+alarm_tag.toString());
				
				String interval = jsObj.getString("intrval");
				System.out.println("Interval : "+interval);
				
				String broker_type = jsObj.getString("broker_type");
				System.out.println(" Broker_type : "+broker_type);
				
				String broker_ip = jsObj.getString("broker_ip");
				System.out.println("Broker_ip : "+broker_ip);
				
				String asset_id = jsObj.getString("asset_id");
				System.out.println("Asset id : "+asset_id);
				
				String unit_id = jsObj.getString("unit_id");
				System.out.println("Unit id : "+unit_id);
				
				JSONObject disObj = new JSONObject();
				
				try {

					disObj.put("alarm_tag", alarm_tag);
					disObj.put("interval", interval);
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
			
		}catch(Exception e){
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
		
		System.out.println("tagData>"+tagData);
		
		
		try {

			System.out.println("In alarm config...");
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();

			
			json.put("operation", "protocol");
			json.put("protocol_type", "alarm");
			json.put("operation_type", "add_query");
			
			json.put("id","1");
			json.put("username","admin");
			json.put("unit_id", unit_id);
			json.put("asset_id", asset_id);
			json.put("broker_type", broker_type);
			json.put("broker_ip", broker_name);
			json.put("intrval", interval);
			json.put("alarm_tag", json_string_con);
			/*JSONObject json_data = new JSONObject();
			json_data.put(tag_name,tag_name_2);
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
		// doGet(request, response);
	}

}
