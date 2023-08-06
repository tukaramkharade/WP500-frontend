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
// * Servlet implementation class AlarmConfigServlet
// */
//@WebServlet("/alarmConfigServlet")
//public class AlarmConfigServlet extends HttpServlet {
//	private static final long serialVersionUID = 1L;
//	final static Logger logger = Logger.getLogger(AlarmConfigServlet.class);
//
//       
//    /**
//     * @see HttpServlet#HttpServlet()
//     */
//    public AlarmConfigServlet() {
//        super();
//        // TODO Auto-generated constructor stub
//    }
//
//	/**
//	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
//	 */
//	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//		// TODO Auto-generated method stub
//	//	response.getWriter().append("Served at: ").append(request.getContextPath());
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

//------------------------------------------------------------------------


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

import com.tas.utils.TCPClient;

/**
 * Servlet implementation class AlarmConfigServlet
 */
@WebServlet("/alarmConfigServlet")
public class AlarmConfigServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	final static Logger logger = Logger.getLogger(AlarmConfigServlet.class);

       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AlarmConfigServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	//	response.getWriter().append("Served at: ").append(request.getContextPath());
		
		TCPClient client = new TCPClient();
		JSONObject json = new JSONObject();
		
		try{
			
			//System.out.println("In json builder...");
			
			json.put("operation", "protocol");
			json.put("protocol_type", "json_builder");
			json.put("operation_type", "get_broker_ip");
			
			String respStr = client.sendMessage(json.toString());
			
			System.out.println("res " + new JSONObject(respStr));
			logger.info("res " + new JSONObject(respStr));
			
			JSONObject result = new JSONObject(respStr);
			
			JSONArray broker_ip_result= result.getJSONArray("result");
			
			JSONObject jsonObject = new JSONObject();
		    jsonObject.put("broker_ip_result", broker_ip_result);
		    
			// Set the content type of the response to application/json
		    response.setContentType("application/json");
		    
		    // Get the response PrintWriter
		    PrintWriter out = response.getWriter();
		    
		    // Write the JSON object to the response
		    out.print(jsonObject.toString());
		    out.flush();
		}catch(Exception e){
			e.printStackTrace();
		}
		
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	//	doGet(request, response);
	}

}
