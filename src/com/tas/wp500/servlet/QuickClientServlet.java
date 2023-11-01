package com.tas.wp500.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

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

@WebServlet("/QuickClientServlet")
public class QuickClientServlet extends HttpServlet {
	final static Logger logger = Logger.getLogger(QuickClientServlet.class);
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
		HttpSession session = request.getSession(false);

		String check_username = (String) session.getAttribute("username");

		TCPClient client = new TCPClient();
		JSONObject json = new JSONObject();
		
		if (check_username != null) {
			
			try {
				
				json.put("operation", "get_opc_client_list");
				json.put("user", check_username);
				
				String respStr = client.sendMessage(json.toString());

				JSONObject respJson = new JSONObject(respStr);
				
				logger.info("OPCUA client list response : " + respJson.toString());
				
				JSONArray dataArr = respJson.getJSONArray("data");
				
				System.out.println("data array : "+dataArr);
				
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("data", dataArr);

				// Set the content type of the response to application/json
				response.setContentType("application/json");

				// Get the response PrintWriter
				PrintWriter out = response.getWriter();

				// Write the JSON object to the response
				out.print(jsonObject.toString());
				out.flush();
				
			}catch(Exception e){
				e.printStackTrace();
				logger.error("Error in getting opcua client list: "+e);
			}
			
		}else{
			try {
				JSONObject userObj = new JSONObject();
				userObj.put("msg", "Your session is timeout. Please login again");
				userObj.put("status", "fail");

				// Set the response content type to JSON
				response.setContentType("application/json");

				// Write the JSON data to the response
				response.getWriter().print(userObj.toString());

			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error in session timeout : " + e);
			}
		}
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		HttpSession session = request.getSession(false);

		String check_username = (String) session.getAttribute("username");

		TCPClient client = new TCPClient();
		JSONObject json = new JSONObject();
		
		if (check_username != null) {
			
			try {
				
				String opcname = request.getParameter("opcname");
				
				json.put("operation", "get_opc_nodes");
				json.put("user", check_username);
				
				JSONObject json_opc_node = new JSONObject();
				
				json_opc_node.put("dataType", "string");
				json_opc_node.put("nodeid", "Objects");
				json_opc_node.put("opcname", opcname);
				JSONObject json_value = new JSONObject();
				
				
				json_opc_node.put("value", json_value);
				
				json.put("opc_node", json_opc_node);
				
				String respStr = client.sendMessage(json.toString());
				JSONObject respJson = new JSONObject(respStr);
				
				JSONArray dataArr = respJson.getJSONArray("data");
				
				System.out.println("data array : "+dataArr);
				
//				for (int i = 0; i < dataArr.length(); i++) {
//				    String nodeDataString = dataArr.getString(i);
//
//				    // Split the nodeDataString based on commas
//				    String[] parts = nodeDataString.split(",");
//
//				    String displayName = null;
//				    
//				    // Iterate through the parts to find the one containing 'displayName'
//				    for (String part : parts) {
//				        if (part.contains("displayName")) {
//				            // Extract the displayName value
//				            displayName = part.trim().replace("displayName=", "");
//				            // Remove the trailing ']' using replaceAll
//				            displayName = displayName.replaceAll("\\]$", "");
//				            break;
//				        }
//				    }
//
//				    if (displayName != null) {
//				        System.out.println("displayName: " + displayName);
//				        // You can use the 'displayName' value as needed in your servlet code.
//				    }
//				}
//
//				
//				JSONObject jsonObject = new JSONObject();
//
//				// Set the content type of the response to application/json
//				response.setContentType("application/json");
//
//				// Get the response PrintWriter
//				PrintWriter out = response.getWriter();
//
//				// Write the JSON object to the response
//				out.print(jsonObject.toString());
//				out.flush();
				
				
				 List<String> displayNamesList = new ArrayList<>();

				    for (int i = 0; i < dataArr.length(); i++) {
				        String nodeDataString = dataArr.getString(i);

				        // Split the nodeDataString based on commas
				        String[] parts = nodeDataString.split(",");

				        String displayName = null;

				        // Iterate through the parts to find the one containing 'displayName'
				        for (String part : parts) {
				            if (part.contains("displayName")) {
				                // Extract the displayName value
				                displayName = part.trim().replace("displayName=", "");
				                // Remove the trailing ']' using replaceAll
				                displayName = displayName.replaceAll("\\]$", "");
				                break;
				            }
				        }

				        if (displayName != null) {
				            displayNamesList.add(displayName);
				        }
				    }

				    // Create a JSON object to hold the displayNames
				    JSONObject jsonResponse = new JSONObject();
				    jsonResponse.put("displayNames", displayNamesList);

				    // Set the content type of the response to application/json
				    response.setContentType("application/json");

				    // Get the response PrintWriter
				    PrintWriter out = response.getWriter();

				    // Write the JSON object to the response
				    out.print(jsonResponse.toString());
				    out.flush();
			
				
				
			}catch(Exception e){
				e.printStackTrace();
				logger.error("Error in getting opc nodes list: "+e);
			}
			
			
		}else{
			try {
				JSONObject userObj = new JSONObject();
				userObj.put("msg", "Your session is timeout. Please login again");
				userObj.put("status", "fail");

				// Set the response content type to JSON
				response.setContentType("application/json");

				// Write the JSON data to the response
				response.getWriter().print(userObj.toString());

			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Error in session timeout : " + e);
			}
		}
		
	}

}
