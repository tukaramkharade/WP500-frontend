package com.tas.wp500.servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;

import com.tas.wp500.utils.TCPClient;

@WebServlet("/upadateLan1")
public class Lan1UpdateServlet extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);

		String check_username = (String) session.getAttribute("username");
		String check_token = (String) session.getAttribute("token");

		if (check_username != null) {

			String lan1_ipaddr = request.getParameter("lan1_ipaddr");
			String lan1_subnet = request.getParameter("lan1_subnet");
			String lan1_type = request.getParameter("lan1_type");
			String lan1_dhcp = request.getParameter("lan1_dhcp1");
			String lan1_gateway = request.getParameter("lan1_gateway");
			String lan1_dns = request.getParameter("lan1_dns");
			String toggle_enable_lan1 = request.getParameter("toggle_enable_lan1");

			try {

				TCPClient client = new TCPClient();
				JSONObject json = new JSONObject();

				json.put("operation", "update_lan_setting");
				json.put("user", check_username);
				json.put("token", check_token);
//				json.put("lan_type", lan1_type);
//				json.put("lan1_dhcp", lan1_dhcp);
//				json.put("lan1_ipaddr", lan1_ipaddr);
//				json.put("lan1_subnet", lan1_subnet);
//				json.put("lan1_gateway", lan1_gateway);
//				json.put("lan1_dns", lan1_dns);
//				json.put("lan1_enable", toggle_enable_lan1);
				if (!lan1_type.isEmpty()) {
				    json.put("lan_type", lan1_type);
				}

				if (!lan1_dhcp.isEmpty()) {
				    json.put("lan1_dhcp", lan1_dhcp);
				}

				if (!lan1_ipaddr.isEmpty()) {
				    json.put("lan1_ipaddr", lan1_ipaddr);
				}

				if (!lan1_subnet.isEmpty()) {
				    json.put("lan1_subnet", lan1_subnet);
				}

				if (!lan1_gateway.isEmpty()) {
				    json.put("lan1_gateway", lan1_gateway);
				}

				if (!lan1_dns.isEmpty()) {
				    json.put("lan1_dns", lan1_dns);
				}

				if (!toggle_enable_lan1.isEmpty()) {
				    json.put("lan1_enable", toggle_enable_lan1);
				}

				System.out.println("lan1-->" + json);
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
		} else {

		}
	}

}
