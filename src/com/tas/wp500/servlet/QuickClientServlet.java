package com.tas.wp500.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
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

import com.tas.wp500.entity.NodeData;
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
		JSONArray displayNamesArray = new JSONArray();
		JSONObject json = new JSONObject();
		String nodeid = null;
		 HashMap<String, String> nodeidMap = new HashMap<>();
		
		if (check_username != null) {
			
			try {
				
				
				// display name 
				
				String opcname = request.getParameter("opcname");
				System.out.println("opcname : "+opcname);
				
				
				if(!opcname.equals("Objects") && !opcname.equals("Types") && !opcname.equals("Views")){
					
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
					System.out.println(respJson.toString());
					
					String dataString = respJson.getString("data");
		            JSONArray dataArr = new JSONArray(dataString);
				
					// Parse the JSON data into an array of NodeData objects
	                List<NodeData> nodeDataList = new ArrayList<>();
	                for (int i = 0; i < dataArr.length(); i++) {
	                    JSONObject nodeJson = dataArr.getJSONObject(i);
	                    NodeData nodeData = new NodeData();
	                    nodeData.setType(nodeJson.getString("type"));
	                    nodeData.setNodeid(nodeJson.getString("nodeid"));
	                    nodeData.setBrowsename(nodeJson.getString("browsename"));
	                    nodeData.setOpcname(nodeJson.getString("opcname"));
	                    nodeData.setDisplayName(nodeJson.getString("displayName"));
	                    nodeDataList.add(nodeData);
	                    
	                    nodeid = nodeJson.getString("nodeid");
	                }
				
	               
	                for (NodeData nodeData : nodeDataList) {
	                    nodeidMap.put(nodeData.getBrowsename(), nodeData.getNodeid());
	                    
	                }
                
	                System.out.println("node id : "+nodeid);
	                
	                for (NodeData nodeData : nodeDataList) {
	                    displayNamesArray.put(nodeData.getDisplayName());
	                }

	                // Include the displayNamesArray in the JSON response
	                JSONObject jsonResponse = new JSONObject();
	                jsonResponse.put("data", displayNamesArray);

	                // Set the response content type to JSON
	                response.setContentType("application/json");

	                // Write the JSON data to the response
	                PrintWriter out = response.getWriter();
	                out.print(jsonResponse.toString());
	                out.flush();
					
				}
	                else if(opcname.equals("Objects")){
	                	
	                	if (nodeidMap.containsKey(opcname)) {
	                        nodeid = nodeidMap.get(opcname);
	                        System.out.println("objects nodeid: " + nodeid);
	                    }
	                   // System.out.println("objects nodeid: "+nodeid);
	                    
	                	json.put("operation", "get_opc_nodes");
						json.put("user", check_username);
						
						JSONObject json_opc_node = new JSONObject();
						
						json_opc_node.put("dataType", "string");
						json_opc_node.put("nodeid", nodeid);
						json_opc_node.put("opcname", opcname);
						JSONObject json_value = new JSONObject();
						
						
						json_opc_node.put("value", json_value);
						
						json.put("opc_node", json_opc_node);
						
						String respStr = client.sendMessage(json.toString());
						JSONObject respJson = new JSONObject(respStr);
						System.out.println(respJson.toString());
						
						String dataString = respJson.getString("data");
			            JSONArray dataArr = new JSONArray(dataString);
					
						// Parse the JSON data into an array of NodeData objects
		                List<NodeData> nodeDataList = new ArrayList<>();
		                for (int i = 0; i < dataArr.length(); i++) {
		                    JSONObject nodeJson = dataArr.getJSONObject(i);
		                    NodeData nodeData = new NodeData();
		                    nodeData.setType(nodeJson.getString("type"));
		                    nodeData.setNodeid(nodeJson.getString("nodeid"));
		                    nodeData.setBrowsename(nodeJson.getString("browsename"));
		                    nodeData.setOpcname(nodeJson.getString("opcname"));
		                    nodeData.setDisplayName(nodeJson.getString("displayName"));
		                    nodeDataList.add(nodeData);
		                }
					
		                //HashMap<String, String> nodeidMap = new HashMap<>();
		                for (NodeData nodeData : nodeDataList) {
		                    nodeidMap.put(nodeData.getBrowsename(), nodeData.getNodeid());
		                }
//		                
		             
		                
		                for (NodeData nodeData : nodeDataList) {
		                    displayNamesArray.put(nodeData.getDisplayName());
		                }

		                // Include the displayNamesArray in the JSON response
		                JSONObject jsonResponse = new JSONObject();
		                jsonResponse.put("data", displayNamesArray);

		                // Set the response content type to JSON
		                response.setContentType("application/json");

		                // Write the JSON data to the response
		                PrintWriter out = response.getWriter();
		                out.print(jsonResponse.toString());
		                out.flush();

					
				}
	         //       else if(){
//					
//				}else if(){
//					
//				}
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
