package com.tas.wp500.servlet;

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

import com.tas.wp500.utils.TCPClient;


/**
 * Servlet implementation class Logs
 */
@WebServlet("/loadEventData")
public class EventGetData extends HttpServlet {
	private static final long serialVersionUID = 1L;
	final static Logger logger = Logger.getLogger(EventGetData.class);

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public EventGetData() {
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
				json.put("operation", "get_event_data");
				// json.put("user", "admin");

				json.put("page_no", "1");

				String respStr = client.sendMessage(json.toString());

//				System.out.println("res " + new JSONObject(respStr));
				logger.info("res " + new JSONObject(respStr));

				JSONObject result = new JSONObject(respStr);
				String totalPage = result.getString("total_pages");
				JSONArray event_log_result = result.getJSONArray("result");

				JSONObject jsonObject = new JSONObject();
				jsonObject.put("event_log_result", event_log_result);
				jsonObject.put("total_page", totalPage);
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
		HttpSession session = request.getSession(false);

		if (session != null) {
			String check_username = (String) session.getAttribute("username");

			String currentPage = request.getParameter("currentPage");

			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();

			try {
				json.put("operation", "get_event_data");
				
				// json.put("user", "admin");

				json.put("page_no", currentPage);

				String respStr = client.sendMessage(json.toString());

//				System.out.println("res " + new JSONObject(respStr));
				logger.info("res " + new JSONObject(respStr));

				JSONObject result = new JSONObject(respStr);
				String totalPage = result.getString("total_pages");
				JSONArray event_log_result = result.getJSONArray("result");

				JSONObject jsonObject = new JSONObject();
				jsonObject.put("event_log_result", event_log_result);
				jsonObject.put("total_page", totalPage);
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
