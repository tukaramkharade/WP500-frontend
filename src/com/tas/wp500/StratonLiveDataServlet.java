package com.tas.wp500;

import java.io.IOException;
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
 * Servlet implementation class StratonLiveDataServlet
 */
@WebServlet("/stratonLiveDataServlet")
public class StratonLiveDataServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	final static Logger logger = Logger.getLogger(StratonLiveDataServlet.class);

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public StratonLiveDataServlet() {
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

		HttpSession session = request.getSession(false);

		if (session != null) {
			String check_username = (String) session.getAttribute("username");

			TCPClient client = new TCPClient();
			JSONObject json = new JSONObject();

			try {

				json.put("operation", "get_live_data");
				json.put("user", check_username);

				String respStr = client.sendMessage(json.toString());

				JSONObject respJson = new JSONObject(respStr);

				System.out.println("res " + respJson.toString());

				JSONArray resJsonArray = new JSONArray();

				logger.info("Straton live value response : " + respJson.toString());

				JSONArray resultArr = respJson.getJSONArray("result");

				System.out.println("Result : " + resultArr.toString());

				for (int i = 0; i < resultArr.length(); i++) {
					JSONObject jsObj = resultArr.getJSONObject(i);

					String extError = jsObj.getString("extError");
					logger.info("extError : " + extError);

					String access = jsObj.getString("access");
					logger.info("access : " + access);

					String tag_name = jsObj.getString("tag_name");
					logger.info("tag_name : " + tag_name);

					String error = jsObj.getString("error");
					logger.info("error : " + error);

					String value = jsObj.getString("value");
					logger.info("value : " + value);

					JSONObject stratonObj = new JSONObject();

					try {

						stratonObj.put("extError", extError);
						stratonObj.put("access", access);
						stratonObj.put("tag_name", tag_name);
						stratonObj.put("error", error);
						stratonObj.put("value", value);

						resJsonArray.put(stratonObj);
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

			} catch (Exception e) {
				e.printStackTrace();
			}
		} else {
			System.out.println("Login first");
			response.sendRedirect("login.jsp");
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		// doGet(request, response);
	}

}
