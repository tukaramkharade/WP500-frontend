package com.tas.wp500.servlet;

import java.io.BufferedReader;
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

@WebServlet("/wireguardServlet")
public class WireguardServlet extends HttpServlet {
	final static Logger logger = Logger.getLogger(WireguardServlet.class);

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);

		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		String check_role = (String) session.getAttribute("role");
		
		String csrfTokenFromRequest = request.getParameter("csrfToken");

		// Retrieve CSRF token from the session
		String csrfTokenFromSession = (String) session.getAttribute("csrfToken");

		if (check_username != null) {

			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();
			JSONObject jsonObject = new JSONObject();

			try {
				if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
				json.put("operation", "read_wireguard_file");
				json.put("user", check_username);
				json.put("token", check_token);
				json.put("role", check_role);
				
				String respStr = client.sendMessage(json.toString());

				logger.info("res " + new JSONObject(respStr));

				JSONObject result = new JSONObject(respStr);

				String status = result.getString("status");
				String message = result.getString("msg");

				JSONObject finalJsonObj = new JSONObject();
				if(status.equals("success")){
					JSONArray wireguard_file_data = result.getJSONArray("data");
					finalJsonObj.put("status", status);
				    finalJsonObj.put("wireguard_file_data", wireguard_file_data);
				}else if(status.equals("fail")){
					finalJsonObj.put("status", status);
				    finalJsonObj.put("message", message);
				}

			    // Set the response content type to JSON
			    response.setContentType("application/json");
			    response.setHeader("X-Content-Type-Options", "nosniff");

			    // Write the JSON data to the response
			    response.getWriter().print(finalJsonObj.toString());
				}else {
					logger.error("CSRF token validation failed");	
				}
				
			} catch (Exception e) {
				e.printStackTrace();
			}

		} 
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		HttpSession session = request.getSession(false);

		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");
		String check_role = (String) session.getAttribute("role");
		
		String csrfTokenFromRequest = request.getParameter("csrfToken");

		// Retrieve CSRF token from the session
		String csrfTokenFromSession = (String) session.getAttribute("csrfToken");
		
		if (check_username != null) {

			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();
			try{
			
//				BufferedReader reader = request.getReader();
//	            StringBuilder stringBuilder = new StringBuilder();
//	            String line;
//	            while ((line = reader.readLine()) != null) {
//	                stringBuilder.append(line);
//	            }
//	            String linesJson = stringBuilder.toString();
//
//	            // Extract the "lines" property from the JSON object
//	           JSONObject jsonObj = new JSONObject(linesJson);
//	         //   String linesJson = request.getParameter("lines");
//	            System.out.println("lines json: "+linesJson);
//	            
//	            JSONArray linesArray = new JSONArray(jsonObj.getString("lines"));
//	            
//	            System.out.println("lines array: " + linesArray);
				if (csrfTokenFromRequest != null && csrfTokenFromRequest.equals(csrfTokenFromSession)) {
					
				
				String linesJson = request.getParameter("lines");
                System.out.println("lines json: " + linesJson);

                JSONArray linesArray = new JSONArray(linesJson);
                System.out.println("lines array: " + linesArray);
                
                System.out.println("lines array: " + linesArray);

				
				json.put("operation", "write_wireguard_file");
				json.put("user", check_username);
				json.put("data", linesArray);
				json.put("token", check_token);
				json.put("role", check_role);
				
				String respStr = client.sendMessage(json.toString());
				System.out.println(respStr);

				logger.info("res " + new JSONObject(respStr));

				String message = new JSONObject(respStr).getString("msg");
				String status = new JSONObject(respStr).getString("status");
				
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("message", message);
				jsonObject.put("status", status);
				

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
