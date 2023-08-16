package com.tas.wp500;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import com.tas.utils.TCPClient;

/**
 * Servlet implementation class LanUpdateServlet
 */
@WebServlet("/lanUpdateServlet")
public class LanUpdateServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public LanUpdateServlet() {
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
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		// doGet(request, response);

		String eth1_ipaddr = request.getParameter("ip_addr_0");
		String eth1_subnet = request.getParameter("subnet_mask_0");
		String eth1_type = request.getParameter("lan_type");
		String eth1_dhcp = request.getParameter("eth1_dhcp");

		try {

			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();

			json.put("operation", "update_lan_setting");
			json.put("lan_type", eth1_type);
			json.put("eth1_dhcp", eth1_dhcp);
			json.put("eth1_ipaddr", eth1_ipaddr);
			json.put("eth1_subnet", eth1_subnet);

			String respStr = client.sendMessage(json.toString());

			System.out.println("response : " + respStr);

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
		}
	}

}
