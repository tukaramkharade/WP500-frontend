package com.tas.wp500;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
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
 * Servlet implementation class MQTTData
 */
@WebServlet("/mqttData")
public class MQTTData extends HttpServlet {
	private static final long serialVersionUID = 1L;
	final static Logger logger = Logger.getLogger(MQTTData.class);
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public MQTTData() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	//	response.getWriter().append("Served at: ").append(request.getContextPath());
		
		HttpSession session = request.getSession(false);

		//if (session != null) {
			String check_username = (String) session.getAttribute("username");
		
		TCPClient client = new TCPClient();
		JSONObject json = new JSONObject();
		
		if (check_username != null) {
			
			try{
				
				json.put("operation", "protocol");
				json.put("protocol_type", "mqtt");
				json.put("operation_type", "get_query");
				json.put("user", check_username);

				String respStr = client.sendMessage(json.toString());
				
				JSONObject respJson = new JSONObject(respStr);
				
				System.out.println("res " + respJson.toString());

				JSONArray resJsonArray = new JSONArray();

				logger.info("MQTT response : " + respJson.toString());

				JSONArray resultArr = respJson.getJSONArray("result");
							
				System.out.println("Result : "+resultArr.toString());
				
				for(int i = 0; i < resultArr.length() ; i++){
					JSONObject jsObj = resultArr.getJSONObject(i);
							
					String broker_ip_address = jsObj.getString("broker_ip_address");
					logger.info("broker_ip_address : " + broker_ip_address);
					
					String port_number = jsObj.getString("port_number");
					logger.info("port_number : " + port_number);
					
					String username = jsObj.getString("username");
					logger.info("username : " + username);
					
					String password = jsObj.getString("password");
					logger.info("password : " + password);
					
					String publish_topic = jsObj.getString("publish_topic");
					logger.info("publish_topic : " + publish_topic);
					
					String subscribe_topic = jsObj.getString("subscribe_topic");
					logger.info("subscribe_topic : " + subscribe_topic);
					
					String prefix = jsObj.getString("prefix");
					logger.info("prefix : " + prefix);
					
					String file_type = jsObj.getString("file_type");
					logger.info("file_type : " + file_type);
					
					String file_name = jsObj.getString("file_name");
					logger.info("file_name : " + file_name);
					
					String enable = jsObj.getString("enable");
					logger.info("enable : " + enable);
					
					JSONObject mqttObj = new JSONObject();
					
					try {

						mqttObj.put("broker_ip_address", broker_ip_address);
						mqttObj.put("port_number", port_number);
						mqttObj.put("username", username);
						mqttObj.put("password", password);
						mqttObj.put("publish_topic", publish_topic);
						mqttObj.put("subscribe_topic", subscribe_topic);
						mqttObj.put("prefix", prefix);
						mqttObj.put("file_type", file_type);
						mqttObj.put("file_name", file_name);
						mqttObj.put("enable", enable);
						

						resJsonArray.put(mqttObj);
						// firewallObj.put("lastName", "");
					} catch (JSONException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
				
				logger.info("JSON ARRAY :" + resJsonArray.length() + " " + resJsonArray.toString());
				
				response.setContentType("application/json");

				// Write the JSON data to the response
				response.getWriter().print(resJsonArray.toString());
				
				
			}catch(Exception e){
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
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
