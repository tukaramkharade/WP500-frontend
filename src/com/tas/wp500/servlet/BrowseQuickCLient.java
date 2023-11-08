package com.tas.wp500.servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;

import com.tas.wp500.utils.TCPClient;

import jdk.management.resource.internal.inst.SocketOutputStreamRMHooks;

/**
 * Servlet implementation class BrowseQuickCLient
 */
@WebServlet("/BrowseQuickCLient")
public class BrowseQuickCLient extends HttpServlet {
	private static final long serialVersionUID = 1L;
	final static Logger logger = Logger.getLogger(BrowseQuickCLient.class);

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public BrowseQuickCLient() {
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
		try {

			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();

			json.put("operation", "get_opc_client_list");
			json.put("user", "amol");

			String respStr = client.sendMessage(json.toString());

			JSONObject respJson = new JSONObject(respStr);

			logger.info("OPCUA client list response : " + respJson.toString());

			JSONArray dataArr = respJson.getJSONArray("data");

			System.out.println("data array : " + dataArr);

			JSONObject jsonObject = new JSONObject();
			jsonObject.put("data", dataArr);

			// Set the content type of the response to application/json
			response.setContentType("application/json");

			// Get the response PrintWriter
			PrintWriter out = response.getWriter();

			// Write the JSON object to the response
			out.print(jsonObject.toString());
			out.flush();
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("Error in getting opcua client list: " + e);
		}

	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		try {
			String node = request.getParameter("node");
			String opcname = request.getParameter("opcname");
			String type = request.getParameter("type");
			String browsename = request.getParameter("browsename");

			logger.error("opcname " + opcname);
			logger.error("node " + node);
			logger.error("browsename " + browsename);
			logger.error("type " + type);

			if (type.equalsIgnoreCase("server")) {

				TCPClient client = new TCPClient();
				JSONObject json = new JSONObject();
				json.put("operation", "get_opc_nodes");

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

				JSONObject jsonResponse = new JSONObject();
				jsonResponse.put("data", dataArr);

				// Set the response content type to JSON
				response.setContentType("application/json");

				System.out.println("--" + dataArr.toString());

				// Write the JSON data to the response
				PrintWriter out = response.getWriter();
				out.print(jsonResponse.toString());
				out.flush();
			} else if (type.equalsIgnoreCase("Object")) {
				TCPClient client = new TCPClient();
				JSONObject json = new JSONObject();
				json.put("operation", "get_opc_nodes");

				JSONObject json_opc_node = new JSONObject();

				json_opc_node.put("dataType", type);
				json_opc_node.put("nodeid", node);
				json_opc_node.put("opcname", opcname);
				JSONObject json_value = new JSONObject();

				json_opc_node.put("value", json_value);

				json.put("opc_node", json_opc_node);

				String respStr = client.sendMessage(json.toString());
				JSONObject respJson = new JSONObject(respStr);
				System.out.println(respJson.toString());

				String dataString = respJson.getString("data");
				JSONArray dataArr = new JSONArray(dataString);

				JSONObject jsonResponse = new JSONObject();
				jsonResponse.put("data", dataArr);

				// Set the response content type to JSON
				response.setContentType("application/json");

				System.out.println("--" + dataArr.toString());

				// Write the JSON data to the response
				PrintWriter out = response.getWriter();
				out.print(jsonResponse.toString());
				out.flush();
			} else if (type.equalsIgnoreCase("Variable")) {
				TCPClient client = new TCPClient();
				JSONObject json = new JSONObject();
				json.put("operation", "get_opc_node_value");

				JSONObject json_opc_node = new JSONObject();

				json_opc_node.put("dataType", type);
				json_opc_node.put("nodeid", node);
				json_opc_node.put("opcname", opcname);
				JSONObject json_value = new JSONObject();

				json_opc_node.put("value", json_value);

				json.put("opc_node", json_opc_node);

				String respStr = client.sendMessage(json.toString());
				JSONObject respJson = new JSONObject(respStr);
				System.out.println(respJson.toString());

//				String dataString = respJson.getString("data");
//				JSONArray dataArr = new JSONArray(dataString);
//
//				JSONObject jsonResponse = new JSONObject();
//				jsonResponse.put("data", dataArr);
//
//				// Set the response content type to JSON
//				response.setContentType("application/json");
//
//				System.out.println("--" + dataArr.toString());
//
//				// Write the JSON data to the response
//				PrintWriter out = response.getWriter();
//				out.print(jsonResponse.toString());
//				out.flush();
			}

		} catch (Exception e) {
			e.printStackTrace();
			logger.error("Error in getting opcua client list: " + e);
		}

	}

}
