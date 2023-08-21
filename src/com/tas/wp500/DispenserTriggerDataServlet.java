package com.tas.wp500;

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

import com.tas.utils.TCPClient;

/**
 * Servlet implementation class DispenserTriggerDataServlet
 */
@WebServlet("/dispenserTriggerDataServlet")
public class DispenserTriggerDataServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	final static Logger logger = Logger.getLogger(DispenserTriggerDataServlet.class);

       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DispenserTriggerDataServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	//	doGet(request, response);
		
		HttpSession session = request.getSession(false);

		if (session != null) {
			String check_username = (String) session.getAttribute("username");
		
		String broker_name = request.getParameter("broker_name");
		String station_name = request.getParameter("station_name");
		String serial_number = request.getParameter("serial_number");
		String side = request.getParameter("side");
		String trigger_tag = request.getParameter("trigger_tag");
		String trigger_value = request.getParameter("trigger_value");
		String start_pressure = request.getParameter("start_pressure");
		String end_pressure = request.getParameter("end_pressure");
		String temperature = request.getParameter("temperature");
		String total = request.getParameter("total");
		String quantity = request.getParameter("quantity");
		String unit_price = request.getParameter("unit_price");
		String status = request.getParameter("status");
		String unit_id = request.getParameter("unit_id");
		

		// System.out.println(firstName + " " + password);

		try {

			System.out.println("In dispenser trigger ...");
			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();

			//System.out.println("broker ip addr :" + broker_ip_address);
			json.put("operation", "protocol");
			json.put("protocol_type", "dispenser");
			json.put("operation_type", "add_query");
			json.put("user", check_username);
			
			json.put("station_name", station_name);
			json.put("serial_number", serial_number);
			json.put("side", side);
			json.put("trigger_tag", trigger_tag);
			json.put("trigger_value", trigger_value);
			json.put("status", status);
			json.put("start_pressesure", start_pressure);
			json.put("end_pressure", end_pressure);
			json.put("tempreture", temperature);
			json.put("total", total);
			json.put("quantity", quantity);
			json.put("unit_price", unit_price);
			json.put("broker_ip_address", broker_name);
			json.put("unit_id", unit_id);

			String respStr = client.sendMessage(json.toString());

			System.out.println("res " + new JSONObject(respStr).getString("msg"));

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
		}else{
			System.out.println("Login first");
			response.sendRedirect("login.jsp");
		}
		// doGet(request, response);
	}

}
