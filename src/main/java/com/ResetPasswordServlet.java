package com;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.net.Authenticator.RequestorType;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.util.Config;

/**
 * Servlet implementation class ResetPasswordServlet
 */
@WebServlet("/resetpassword")
public class ResetPasswordServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.getRequestDispatcher("resetpassword.jsp").forward(request, response);
	}
	
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String empId = request.getParameter("empId");
		String password = request.getParameter("password");
		String confirmPassword = request.getParameter("confirmPassword");
		
		JSONArray userArray = new JSONArray();
		JSONParser parser = new JSONParser();
		
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		
		Pattern passwordPattern = Pattern.compile("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$");
		Matcher matcher = passwordPattern.matcher(password);
		if(!matcher.matches()) {
			response.getWriter().write("{\"status\":\"error\", \"message\":\"weak Password\"}");
			return;
		}
		
		if(!confirmPassword.equals(password)) {
			response.getWriter().write("{\"status\":\"error\", \"message\":\"Passwords Dont match\"}");
			return;
		}
		
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
				userJson.put("password", password);
				
				break;
			}
		}
		
		try(FileWriter fWriter = new FileWriter(filePath+"/User.json")) {
			fWriter.write(userArray.toJSONString());
			fWriter.flush();
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		
		response.getWriter().write("{\"status\":\"success\",\"redirect\":\"./index\"}");
	}
}
