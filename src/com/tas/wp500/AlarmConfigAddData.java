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
		
		
		System.out.println("broker name: "+broker_name);
		JSONParser parser = new JSONParser(); 
		org.json.simple.JSONObject json_string_con = null;
		try {
			json_string_con = (org.json.simple.JSONObject) parser.parse(tagData);
		} catch (ParseException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}  
		
		System.out.println("tagData>"+tagData);
		/*String tag_name = request.getParameter("tag_name");
		String tag_name_2 = request.getParameter("tag_name_2");*/
		
		System.out.println("unit id : "+unit_id);
		/*System.out.println("tag name: "+tag_name);
		System.out.println("variable : "+tag_name_2);*/
		
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
