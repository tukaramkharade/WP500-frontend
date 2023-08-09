package com.tas.wp500;

import java.io.IOException;
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
		// String username = request.getParameter("username");
		// String password = request.getParameter("password");
		//
		//
		// System.out.println(username + " " + password);
		// // Check the credentials (in this example, the username is "admin"
		// and the
		// // password is "password")
		// if (username.equals("admin") && password.equals("password")) {
		// // Successful login
		// response.sendRedirect("overview.jsp");
		// } else {
		// // Failed login
		// response.sendRedirect("login.jsp?error=1");
		// }
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
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		try {
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();

			json.put("operation", "login");
			json.put("user", username);

			json.put("username", username);
			json.put("password", password);
			String respStr = client.sendMessage(json.toString());

			System.out.println("res " + new JSONObject(respStr).getString("msg"));
			logger.info("res " + new JSONObject(respStr).getString("msg"));

			String message = new JSONObject(respStr).getString("msg");
			String status = new JSONObject(respStr).getString("status");

			logger.info(new JSONObject(respStr).getString("status"));
			if (status.equals("success")) {
				// Successful login

				logger.info("username: " + username);
				logger.info("password: " + password);

				HttpSession session = request.getSession();
				session.setAttribute("username", username);

				response.sendRedirect("overview.jsp");
			} else {
				// Failed login
				response.sendRedirect("login.jsp?error=1");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
