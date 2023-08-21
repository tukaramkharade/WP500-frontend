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

/**
 * Servlet implementation class CommandConfigServlet
 */
@WebServlet("/commandConfigServlet")
public class CommandConfigServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	final static Logger logger = Logger.getLogger(CommandConfigServlet.class);

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public CommandConfigServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		// doGet(request, response);

		HttpSession session = request.getSession(false);

		if (session != null) {
			String check_username = (String) session.getAttribute("username");

			String unit_id = request.getParameter("unit_id");
			String asset_id = request.getParameter("asset_id");
			String broker_type = request.getParameter("broker_type");
			String broker_name = request.getParameter("broker_name");
			String interval = request.getParameter("interval");
			String tagData = request.getParameter("tagData");

			System.out.println("tagdata : " + tagData);

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

				System.out.println("In command config...");
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
				// json.put("intrval", interval);

				if (interval.equals("30 sec")) {
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
				json.put("command_tag", json_string_con);
				/*
				 * JSONObject json_data = new JSONObject();
				 * json_data.put(tag_name,tag_name_2);
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

	}

}
