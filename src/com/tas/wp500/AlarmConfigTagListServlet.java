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
// * Servlet implementation class AlarmConfigTagListServlet
// */
//@WebServlet("/alarmConfigTagListServlet")
//public class AlarmConfigTagListServlet extends HttpServlet {
//	private static final long serialVersionUID = 1L;
//	final static Logger logger = Logger.getLogger(AlarmConfigTagListServlet.class);
//
//       
//    /**
//     * @see HttpServlet#HttpServlet()
//     */
//    public AlarmConfigTagListServlet() {
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
//			json.put("operation", "get_Tag_list");
//			
//			String respStr = client.sendMessage(json.toString());
//			
//			System.out.println("res " + new JSONObject(respStr));
//			logger.info("res " + new JSONObject(respStr));
//			
//			JSONObject result = new JSONObject(respStr);
//			
//			JSONArray tag_list_result= result.getJSONArray("result");
//			
//			JSONObject jsonObject = new JSONObject();
//		    jsonObject.put("tag_list_result", tag_list_result);
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
//		//doGet(request, response);
//	}
//
//}

//-------------------------------------------------------------

package com.tas.wp500;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;

import com.tas.utils.TCPClient;

/**
 * Servlet implementation class AlarmConfigTagListServlet
 */
@WebServlet("/alarmConfigTagListServlet")
public class AlarmConfigTagListServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	final static Logger logger = Logger.getLogger(AlarmConfigTagListServlet.class);

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public AlarmConfigTagListServlet() {
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

			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();

			try {

				// System.out.println("In json builder...");

				json.put("operation", "get_Tag_list");
				json.put("user", check_username);

				String respStr = client.sendMessage(json.toString());

				System.out.println("res " + new JSONObject(respStr));
				logger.info("res " + new JSONObject(respStr));

				JSONObject result = new JSONObject(respStr);

				JSONArray tag_list_result = result.getJSONArray("result");

				JSONObject jsonObject = new JSONObject();
				jsonObject.put("tag_list_result", tag_list_result);

				// Set the content type of the response to application/json
				response.setContentType("application/json");

				// Get the response PrintWriter
				PrintWriter out = response.getWriter();

				// Write the JSON object to the response
				out.print(jsonObject.toString());
				out.flush();
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else {
			System.out.println("Login first");
			response.sendRedirect("login.jsp");
		}

	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		// doGet(request, response);

		// delete operation

		HttpSession session = request.getSession(false);

		if (session != null) {
			String check_username = (String) session.getAttribute("username");

			try {
				System.out.println("in alarm delete!");

				TCPClient client = new TCPClient();
				JSONObject json = new JSONObject();

				json.put("operation", "protocol");
				json.put("protocol_type", "alarm");
				json.put("operation_type", "delete_query");
				json.put("id", "1");
				json.put("user", check_username);

				String respStr = client.sendMessage(json.toString());

				System.out.println("res " + new JSONObject(respStr).getString("msg"));

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
				e.printStackTrace();
			}
		} else {
			System.out.println("Login first");
			response.sendRedirect("login.jsp");
		}

	}

}
