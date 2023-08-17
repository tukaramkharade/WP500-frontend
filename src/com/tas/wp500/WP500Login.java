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
import org.json.JSONObject;

import com.tas.utils.TCPClient;

/**
 * Servlet implementation class WP500Login
 */
@WebServlet("/WP500Login")
public class WP500Login extends HttpServlet {
	private static final long serialVersionUID = 1L;
	final static Logger logger = Logger.getLogger(WP500Login.class);

	/**
	 * Default constructor.
	 */
	public WP500Login() {
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

		System.out.println("In login...");
		
		HttpSession session = request.getSession();
		session.setMaxInactiveInterval(1800);
		
		
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		try {
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();

			json.put("operation", "login");

			json.put("username", username);
			json.put("password", password);
			String respStr = client.sendMessage(json.toString());

			System.out.println("res " + new JSONObject(respStr).getString("msg"));
			logger.info("res " + new JSONObject(respStr).getString("msg"));

			
			String status = new JSONObject(respStr).getString("status");
			String role = new JSONObject(respStr).getString("role");
			
			logger.info(new JSONObject(respStr).getString("status"));
			if (status.equals("success")) {
				// Successful login

				logger.info("username: " + username);
				logger.info("password: " + password);
				
				response.sendRedirect("overview.jsp");
				session.setAttribute("username", username);
				session.setAttribute("role", role);
				
			}else {
				
				try {
					JSONObject userObj = new JSONObject();
					userObj.put("msg", "Invalid user. Please login again");
					userObj.put("status", "fail");
					
					
					System.out.println(">>" +userObj);
					
					// Set the response content type to JSON
					response.setContentType("application/json");

					// Write the JSON data to the response
					response.getWriter().print(userObj.toString());
					
				} catch (Exception e) {
					e.printStackTrace();
				}
				
				//response.sendRedirect("login.jsp");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect("login.jsp?error=1");
		}
	}

}
