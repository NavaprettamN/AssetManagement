package com;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.FileReader;
import java.io.IOException;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.util.Config;


@WebServlet("/ResetPasswordOtpVerifyServlet")
public class ResetPasswordOtpVerifyServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String empId = request.getParameter("empId");
		String otp = request.getParameter("otp");
		
		JSONArray userArray = new JSONArray();
		JSONParser parser = new JSONParser();
		
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");

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
				if(userJson.containsKey("otp")) {
					if(userJson.get("otp").equals(otp)) {
						response.getWriter().write("{\"status\":\"success\"}");
						userJson.remove("otp");
						return;
					}
					else {
						response.getWriter().write("{\"status\":\"error\", \"message\":\"incorrect otp\"}");
						log("otp was wrong");
						return;
					}
				}
			}
		}
	}

}
