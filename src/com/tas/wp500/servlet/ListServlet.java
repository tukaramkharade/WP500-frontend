package com.tas.wp500.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/getList")
public class ListServlet extends HttpServlet {
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
//		StringBuilder itemListHtml = new StringBuilder();
//        itemListHtml.append("<li>Item 1</li>");
//        itemListHtml.append("<li>Item 2</li>");
//        itemListHtml.append("<li>Item 3</li>");
//
//        response.setContentType("text/html");
//        response.getWriter().write(itemListHtml.toString());

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}

}
