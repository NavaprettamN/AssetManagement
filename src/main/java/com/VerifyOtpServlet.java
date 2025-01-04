package com;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


import java.io.FileReader;
import java.io.IOException;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.util.Config;

/**
 * Servlet implementation class VerifyOtpServlet
 */
@WebServlet("/VerifyOtpServlet")
public class VerifyOtpServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String empId = request.getParameter("empId");
		String otp = request.getParameter("otp");
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		JSONArray userArray = new JSONArray();
		JSONParser parser = new JSONParser();
		
		HttpSession session = request.getSession();
		
		String filePath = Config.DATA_FOLDER_PATH;
		try(FileReader fReader = new FileReader(filePath+"/User.json")) {
			userArray = (JSONArray) parser.parse(fReader);
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		
		for(Object userObject: userArray) {
			JSONObject userJson = (JSONObject) userObject;
			
			if(userJson.get("empId").equals(empId)) {
				if(userJson.get("password").equals(otp)) {
					session.setAttribute("empId", empId);
					log("OTP successfully entered");
					log(empId);
					
					response.getWriter().write("{\"status\":\"success\"}");
					return;
				}
				else {
					log("OTP wrongfully entered");
	                response.getWriter().write("{\"status\":\"error\", \"message\":\"OTP entered is wrong\"}");
					return;
				}
			}
		}
		
	}

}
