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

@WebServlet("/CertificateServlet")
public class CertificateServlet extends HttpServlet {
	final static Logger logger = Logger.getLogger(CertificateServlet.class);
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		

		TCPClient client = new TCPClient();
		JSONObject json = new JSONObject();
		
		JSONObject jsonObject = new JSONObject();
		
		HttpSession session = request.getSession(true);

		String check_username = (String) session.getAttribute("username");
		
		if (check_username != null) {
			
			try{
				json.put("operation", "apply_certificate");		
				json.put("user", check_username);
				
				String respStr = client.sendMessage(json.toString());

				JSONObject respJson = new JSONObject(respStr);

				logger.info("res " + respJson.toString());
				
				for (int i = 0; i < respJson.length(); i++) {
					String message = respJson.getString("message");
					
					try{
						
						jsonObject.put("message", message);
						
					}catch(Exception e){
						e.printStackTrace();
						logger.error("Error in putting totp details in json object :"+e);
					}
				}
				
				// Get the response PrintWriter
				PrintWriter out = response.getWriter();

				// Write the JSON object to the response
				out.print(jsonObject.toString());
				out.flush();
				
			}catch(Exception e){
				e.printStackTrace();
			}
			
		}else{
			try {
				JSONObject userObj = new JSONObject();
				userObj.put("msg", "Your session is timeout. Please login again");
				userObj.put("status", "fail");

				System.out.println(">>" + userObj);

				// Set the response content type to JSON
				response.setContentType("application/json");

				// Write the JSON data to the response
				response.getWriter().print(userObj.toString());

			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error in session timeout: " + e);
			}
		}
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		HttpSession session = request.getSession(true);

		String check_username = (String) session.getAttribute("username");
		
		if (check_username != null) {
			try{
				
				TCPClient client = new TCPClient();
				JSONObject json = new JSONObject();
				
				String commonName = request.getParameter("common_name");
				String organization = request.getParameter("organization");
				String organizationalUnit = request.getParameter("organizational_unit");
				String location = request.getParameter("location");
				String state = request.getParameter("state");
				String country = request.getParameter("country");
				String validityParameter = request.getParameter("validity");
				
				int validity = 0; // Default value in case the parameter is missing or cannot be parsed
				try {
				    if (validityParameter != null) {
				        validity = Integer.parseInt(validityParameter);
				    }
				} catch (NumberFormatException e) {
				    // Handle the case where the parameter cannot be parsed as an integer
				}
				
				String ipAddressesJson = request.getParameter("ipAddresses");
				String dnsNamesJson = request.getParameter("dnsNames");

				JSONArray ipAddresses = new JSONArray(ipAddressesJson);
				JSONArray dnsNames = new JSONArray(dnsNamesJson);
	            
	            json.put("operation", "generate_certificate");
	            json.put("user", check_username);
	            json.put("commonName", commonName);
	            json.put("organization", organization);
	            json.put("organizationalUnit", organizationalUnit);
	            json.put("location", location);
	            json.put("state", state);
	            json.put("country", country);
	            json.put("validity", validity);
	            json.put("ipAddresses", ipAddresses);
	            json.put("dnsNames", dnsNames);

	            String respStr = client.sendMessage(json.toString());

	          //  System.out.println("res " + new JSONObject(respStr));
				logger.info("res " + new JSONObject(respStr).getString("message"));

				String message = new JSONObject(respStr).getString("message");
				System.out.println("message: "+message);
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
				
			}
			
		}else{
			try {
				JSONObject userObj = new JSONObject();
				userObj.put("msg", "Your session is timeout. Please login again");
				userObj.put("status", "fail");

				System.out.println(">>" + userObj);

				// Set the response content type to JSON
				response.setContentType("application/json");

				// Write the JSON data to the response
				response.getWriter().print(userObj.toString());

			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error in session timeout: " + e);
			}
		}
	}

}