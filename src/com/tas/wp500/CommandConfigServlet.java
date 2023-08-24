//package com.tas.wp500;
//
//import java.io.IOException;
//import java.io.PrintWriter;
//
//import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.HttpServlet;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//
//import org.apache.log4j.Logger;
//import org.json.JSONArray;
//import org.json.JSONObject;
//
//import com.tas.utils.TCPClient;
//
///**
// * Servlet implementation class CommandConfigServlet
// */
//@WebServlet("/commandConfigServlet")
//public class CommandConfigServlet extends HttpServlet {
//	private static final long serialVersionUID = 1L;
//	final static Logger logger = Logger.getLogger(CommandConfigServlet.class);
//
//       
//    /**
//     * @see HttpServlet#HttpServlet()
//     */
//    public CommandConfigServlet() {
//        super();
//        // TODO Auto-generated constructor stub
//    }
//
//	/**
//	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
//	 */
//	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//		// TODO Auto-generated method stub
//		//response.getWriter().append("Served at: ").append(request.getContextPath());
//		
//		TCPClient client = new TCPClient();
//		JSONObject json = new JSONObject();
//		
//		try{
//			
//			//System.out.println("In json builder...");
//			
//			json.put("operation", "protocol");
//			json.put("protocol_type", "json_builder");
//			json.put("operation_type", "get_broker_ip");
//			
//			String respStr = client.sendMessage(json.toString());
//			
//			System.out.println("res " + new JSONObject(respStr));
//			logger.info("res " + new JSONObject(respStr));
//			
//			JSONObject result = new JSONObject(respStr);
//			
//			JSONArray broker_ip_result= result.getJSONArray("result");
//			
//			JSONObject jsonObject = new JSONObject();
//		    jsonObject.put("broker_ip_result", broker_ip_result);
//		    
//			// Set the content type of the response to application/json
//		    response.setContentType("application/json");
//		    
//		    // Get the response PrintWriter
//		    PrintWriter out = response.getWriter();
//		    
//		    // Write the JSON object to the response
//		    out.print(jsonObject.toString());
//		    out.flush();
//		}catch(Exception e){
//			e.printStackTrace();
//		}
//		
//	}
//
//	/**
//	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
//	 */
//	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//		// TODO Auto-generated method stub
//	//	doGet(request, response);
//	}
//
//}

//-------------------------------------------------------------------------

package com.tas.wp500;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import com.tas.utils.TCPClient;


@WebServlet("/commandConfigServlet")
public class CommandConfigServlet extends HttpServlet {
	
	final static Logger logger = Logger.getLogger(CommandConfigServlet.class);

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		HttpSession session = request.getSession(false);

		String check_username = (String) session.getAttribute("username");
		if (check_username != null) {

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
				e1.printStackTrace();
				logger.error("Error in converting into json object : "+e1);
			}

			try {

				TCPClient client = new TCPClient();
				JSONObject json = new JSONObject();

				json.put("operation", "protocol");
				json.put("protocol_type", "command");
				json.put("operation_type", "add_query");
				json.put("id", "1");
				json.put("user", check_username);
				json.put("unit_id", unit_id);
				json.put("asset_id", asset_id);
				json.put("broker_type", broker_type);
				json.put("broker_ip", broker_name);
				
				Map<String, String> intervalMap = new HashMap<>();
				intervalMap.put("30 sec", "30");
				intervalMap.put("1 min", "60");
				intervalMap.put("5 min", "300");
				intervalMap.put("10 min", "600");
				intervalMap.put("15 min", "900");
				intervalMap.put("20 min", "1200");
				intervalMap.put("25 min", "1500");
				intervalMap.put("30 min", "1800");
				intervalMap.put("1 hour", "3600");

				String intervalValue = intervalMap.get(interval);
				if (intervalValue != null) {
				    json.put("intrval", intervalValue);
				}
				
				json.put("command_tag", json_string_con);
				
				String respStr = client.sendMessage(json.toString());

				logger.info("res " + new JSONObject(respStr));

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
				logger.error("Error in adding command : "+e);
			}
		} else {
			
		}
	}
}
