package com.tas.wp500;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import com.tas.utils.TCPClient;

/**
 * Servlet implementation class JSONBuilderDeleteServlet
 */
@WebServlet("/jsonBuilderDeleteServlet")
public class JSONBuilderDeleteServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public JSONBuilderDeleteServlet() {
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
		// doGet(request, response);

		String json_string_name = request.getParameter("jsonStringName");
		System.out.println("in json builder delete...");

		try {

			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();

			json.put("operation", "protocol");
			json.put("protocol_type", "json_builder");
			json.put("operation_type", "delete_query");

			json.put("json_string_name", json_string_name);
			
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
	}

}
