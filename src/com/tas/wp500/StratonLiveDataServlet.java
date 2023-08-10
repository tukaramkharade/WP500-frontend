package com.tas.wp500;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

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

				System.out.println("Result before sorting: " + resultArr.toString());
				
				String result_arr = resultArr.toString();
				
				System.out.println("result array in string : "+result_arr);
				
				 	JSONArray jsonArr = new JSONArray(result_arr);
				 //   JSONArray sortedJsonArray = new JSONArray();
				    
				    List<JSONObject> jsonValues = new ArrayList<JSONObject>();
				    for (int i = 0; i < jsonArr.length(); i++) {
				        jsonValues.add(jsonArr.getJSONObject(i));
				    }
				    Collections.sort( jsonValues, new Comparator<JSONObject>() {
				        //You can change "Name" with "ID" if you want to sort by ID
				        private static final String KEY_NAME = "tag_name";

				        @Override
				        public int compare(JSONObject a, JSONObject b) {
				            String valA = new String();
				            String valB = new String();

				            try {
				                valA = (String) a.get(KEY_NAME);
				                valB = (String) b.get(KEY_NAME);
				            } 
				            catch (JSONException e) {
				               e.printStackTrace();
				            }

				            return valA.compareTo(valB);
				            //if you want to change the sort order, simply use the following:
				            //return -valA.compareTo(valB);
				        }
				    });
				    
				 // Convert the sorted list back to JSONArray
			        JSONArray sortedJsonArray = new JSONArray(jsonValues);

			        // Print the sorted JSONArray
			        System.out.println("sorted json array:" + sortedJsonArray);
				    

				for (int i = 0; i < sortedJsonArray.length(); i++) {
					JSONObject jsObj = sortedJsonArray.getJSONObject(i);

					String extError = jsObj.getString("extError");
					//logger.info("extError : " + extError);

					String access = jsObj.getString("access");
				//	logger.info("access : " + access);

					String tag_name = jsObj.getString("tag_name");
				//	logger.info("tag_name : " + tag_name);

					String error = jsObj.getString("error");
			//		logger.info("error : " + error);

					String value = jsObj.getString("value");
			//		logger.info("value : " + value);

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
