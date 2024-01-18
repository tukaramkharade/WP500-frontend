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
		String check_token = (String) session.getAttribute("token");
		String check_role = (String) session.getAttribute("role");
		
		if (check_username != null) {
			
			try{
				json.put("operation", "apply_certificate");		
				json.put("user", check_username);
				json.put("token", check_token);
				json.put("role", check_role);
				
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
				
				response.setHeader("X-Content-Type-Options", "nosniff");
				
				// Get the response PrintWriter
				PrintWriter out = response.getWriter();

				// Write the JSON object to the response
				out.print(jsonObject.toString());
				out.flush();
				
			}catch(Exception e){
				e.printStackTrace();
			}
			
		}
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		HttpSession session = request.getSession(true);

		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		String check_role = (String) session.getAttribute("role");
		
		String csrfTokenFromRequest = request.getParameter("csrfToken");

		// Retrieve CSRF token from the session
		String csrfTokenFromSession = (String) session.getAttribute("csrfToken");
		
		if (check_username != null) {
			try{
				if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
					
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
	            json.put("token", check_token);
	            json.put("commonName", commonName);
	            json.put("organization", organization);
	            json.put("organizationalUnit", organizationalUnit);
	            json.put("location", location);
	            json.put("state", state);
	            json.put("country", country);
	            json.put("validity", validity);
	            json.put("role", check_role);
	            
	            
	            if (dnsNames.length() > 0) {
	            	json.put("dnsNames", dnsNames);
	            } else if(ipAddresses.length() > 0) {	              
	            	json.put("ipAddresses", ipAddresses);
	            }

	            String respStr = client.sendMessage(json.toString());

				logger.info("res " + new JSONObject(respStr));

				String message = new JSONObject(respStr).getString("message");
				System.out.println("message: "+message);
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("message", message);

				// Set the content type of the response to application/json
				response.setContentType("application/json");
				response.setHeader("X-Content-Type-Options", "nosniff");
				// Get the response PrintWriter
				PrintWriter out = response.getWriter();

				// Write the JSON object to the response
				out.print(jsonObject.toString());
				out.flush();
				
				}else {
					logger.error("CSRF token validation failed");	
				}
			}catch(Exception e){
				
			}
			
		}
	}

}
