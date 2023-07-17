package com.tas.wp500;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.tas.utils.TCPClient;

/**
 * Servlet implementation class Firewall
 */
@WebServlet("/firewallData")
public class FirewallData extends HttpServlet {
	private static final long serialVersionUID = 1L;
	final static Logger logger = Logger.getLogger(FirewallData.class);

	public FirewallData() {
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

		TCPClient client = new TCPClient();
		JSONObject json = new JSONObject();

		

		try {
			json.put("operation", "get_ip_tables");

			String respStr = client.sendMessage(json.toString());

		//	String var = "{\"msg\":\"successfully fetched list of ip Tables !!!\",\"result\":\"[{\\\"lineNumber\\\": \\\"1\\\", \\\"target\\\": \\\"ACCEPT\\\", \\\"protocol\\\": \\\"tcp\\\", \\\"opt\\\": \\\"--\\\", \\\"source\\\": \\\"0.0.0.0/0\\\", \\\"destination\\\": \\\"0.0.0.0/0\\\"},{\\\"lineNumber\\\": \\\"2\\\", \\\"target\\\": \\\"ACCEPT\\\", \\\"protocol\\\": \\\"tcp\\\", \\\"opt\\\": \\\"--\\\", \\\"source\\\": \\\"0.0.0.0/0\\\", \\\"destination\\\": \\\"0.0.0.0/0\\\"},{\\\"lineNumber\\\": \\\"3\\\", \\\"target\\\": \\\"ACCEPT\\\", \\\"protocol\\\": \\\"tcp\\\", \\\"opt\\\": \\\"--\\\", \\\"source\\\": \\\"192.168.1.100\\\", \\\"destination\\\": \\\"0.0.0.0/0\\\"}]\",\"operation\":\"get_ip_tables\",\"status\":\"success\"}\r\n";

			 JSONObject respJson = new JSONObject(respStr);
		//	JSONObject respJson = new JSONObject(var);

			System.out.println("res " + respJson.toString());

			JSONArray resJsonArray = new JSONArray();

			logger.info("Firewall response : " + respJson.toString());

			String result = respJson.getString("result");

			logger.info("Result : " + result);

			JSONArray jsArr = new JSONArray(result);

			for (int i = 0; i < jsArr.length(); i++) {

				JSONObject jsObj = jsArr.getJSONObject(i);
				String lineNumber = jsObj.getString("lineNumber");
				logger.info("line num : " + lineNumber);

				String target = jsObj.getString("target");
				logger.info("target : " + target);

				String protocol = jsObj.getString("protocol");
				logger.info("protocol : " + protocol);

				String opt = jsObj.getString("opt");
				logger.info("opt : " + opt);

				String source = jsObj.getString("source");
				logger.info("source : " + source);

				String destination = jsObj.getString("destination");
				logger.info("destination : " + destination);

				JSONObject firewallObj = new JSONObject();
				try {

					firewallObj.put("lineNumber", lineNumber);
					firewallObj.put("target", target);
					firewallObj.put("protocol", protocol);
					firewallObj.put("opt", opt);
					firewallObj.put("source", source);
					firewallObj.put("destination", destination);

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
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		// doGet(request, response);

		int portNumber = Integer.parseInt(request.getParameter("portNumber"));
		String protocol = request.getParameter("protocol");
		String ip_addr = request.getParameter("ip_addr");

		System.out.println(portNumber + " " + protocol + " " + ip_addr);
		logger.info(portNumber + " " + protocol + " " + ip_addr);

		try {
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();

			json.put("operation", "add_firewall_setting");
			json.put("port_num", portNumber);
			json.put("protocol", protocol);
			json.put("ip_address", ip_addr);

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
	}

}
