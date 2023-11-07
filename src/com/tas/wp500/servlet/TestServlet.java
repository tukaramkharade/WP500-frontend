package com.tas.wp500.servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet("/TestServlet")
public class TestServlet extends HttpServlet {
	
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String jsonData = "[{\"name\": \"Root\",\"children\": [" +
            "{\"name\": \"Node 1\",\"children\": [" +
                "{\"name\": \"Node 1.1\"}," +
                "{\"name\": \"Node 1.2\"}" +
            "]}," +
            "{\"name\": \"Node 2\",\"children\": [" +
                "{\"name\": \"Node 2.1\"}," +
                "{\"name\": \"Node 2.2\"}" +
            "]}]}]";

        PrintWriter out = response.getWriter();
        out.print(jsonData);
        out.flush();
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
