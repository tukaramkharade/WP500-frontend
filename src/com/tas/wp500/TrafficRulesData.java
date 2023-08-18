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
import org.json.JSONException;
import org.json.JSONObject;

import com.tas.utils.TCPClient;

/**
 * Servlet implementation class Firewall
 */
@WebServlet("/trafficRulesData")
public class TrafficRulesData extends HttpServlet {
	private static final long serialVersionUID = 1L;
	final static Logger logger = Logger.getLogger(TrafficRulesData.class);

	public TrafficRulesData() {
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
			
			if (check_username != null) {

			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();
			
			

			try {
				json.put("operation", "firewall_settings");
				json.put("user", check_username);

				String respStr = client.sendMessage(json.toString());

				
				JSONObject respJson = new JSONObject(respStr);
				// JSONObject respJson = new JSONObject(var);

				System.out.println("res " + respJson.toString());

				JSONArray resJsonArray = new JSONArray();

				logger.info("Traffic Rules response : " + respJson.toString());

				
				JSONArray ip_tables = respJson.getJSONArray("ip_tables");

				logger.info("Result : " + ip_tables);

				

				for (int i = 0; i < ip_tables.length(); i++) {

					JSONObject jsObj = ip_tables.getJSONObject(i);
					String name = jsObj.getString("name");
					logger.info("name : " + name);

					String iface = jsObj.getString("iface");
					logger.info("iface : " + iface);

					String protocol = jsObj.getString("protocol");
					logger.info("protocol : " + protocol);

					String macAddress = jsObj.getString("macAddress");
					logger.info("macAddress : " + macAddress);

					String portNum = jsObj.getString("portNum");
					logger.info("portNum : " + portNum);

					String ipAddress = jsObj.getString("ipAddress");
					logger.info("ipAddress : " + ipAddress);
					
					String action = jsObj.getString("action");
					logger.info("action : " + action);

					String type = jsObj.getString("type");
					logger.info("type : " + type);

					JSONObject firewallObj = new JSONObject();
					try {

						firewallObj.put("name", name);
						firewallObj.put("iface", iface);
						firewallObj.put("protocol", protocol);
						firewallObj.put("macAddress", macAddress);
						firewallObj.put("portNum", portNum);
						firewallObj.put("ipAddress", ipAddress);
						firewallObj.put("action", action);
						firewallObj.put("type", type);

						resJsonArray.put(firewallObj);
						// firewallObj.put("lastName", "");
					} catch (JSONException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}

				}
				
				
				logger.info("JSON ARRAY :" + resJsonArray.length() + " " + resJsonArray.toString());
				// Set the response content type to JSON
				response.setContentType("application/json");

				// Write the JSON data to the response
				response.getWriter().print(resJsonArray.toString());
		
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else{
			try {
				JSONObject userObj = new JSONObject();
				userObj.put("msg", "Your session is timeout. Please login again");
				userObj.put("status", "fail");
				
				System.out.println(">>" +userObj);
				
				// Set the response content type to JSON
				response.setContentType("application/json");

				// Write the JSON data to the response
				response.getWriter().print(userObj.toString());
				
			} catch (Exception e) {
				e.printStackTrace();
			}
			
		}
			
		}else {
			System.out.println("Login first");
			response.sendRedirect("login.jsp");
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		// doGet(request, response);

		HttpSession session = request.getSession(false);

		String check_username = (String) session.getAttribute("username");
		if (check_username != null) {
			

			String name = request.getParameter("name");
			String iface = request.getParameter("iface");
			String portNumber = request.getParameter("portNumber");
			String macAddress = request.getParameter("macAddress");
			String protocol = request.getParameter("protocol");
			String ip_addr = request.getParameter("ip_addr");
			String type = request.getParameter("type");
			String action = request.getParameter("action");
			

			System.out.println(portNumber + " " + protocol + " " + ip_addr);
			

			try {
				TCPClient client = new TCPClient();
				JSONObject json = new JSONObject();

				json.put("operation", "ip_tables");
				json.put("operation_type", "add_ip");
				json.put("user", check_username);
				json.put("name", name);
				json.put("interface", iface);
				json.put("protocol", protocol);
				json.put("ipAddress", ip_addr);
				json.put("macAddress", macAddress);
				json.put("portNum", portNumber);
				json.put("action", action);
				json.put("type", type);
				

				String respStr = client.sendMessage(json.toString());

				System.out.println("res " + new JSONObject(respStr).getString("msg"));
				logger.info("res " + new JSONObject(respStr).getString("msg"));

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
