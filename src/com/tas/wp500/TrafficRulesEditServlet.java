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
import org.json.JSONObject;

import com.tas.utils.TCPClient;

@WebServlet("/trafficRulesEditServlet")
public class TrafficRulesEditServlet extends HttpServlet {
	final static Logger logger = Logger.getLogger(TrafficRulesEditServlet.class);

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		HttpSession session = request.getSession(false);

		String check_username = (String) session.getAttribute("username");
		if (check_username != null) {			
			try{
				
				TCPClient client = new TCPClient();
				JSONObject json = new JSONObject();

				json.put("operation", "ip_tables");
				json.put("operation_type", "apply_command");
				
				String respStr = client.sendMessage(json.toString());

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
				
			}catch(Exception e){
				e.printStackTrace();
				logger.error("Error in applying traffic rules : "+e);
			}	
		}	
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
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
			
			try {
				TCPClient client = new TCPClient();
				JSONObject json = new JSONObject();

				json.put("operation", "ip_tables");
				json.put("operation_type", "update_ip");
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
				e.printStackTrace();
				logger.error("Error in updating traffic rules : "+e);
			}
		} else {
			
		}		
	}
}
