package com;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.util.Config;


@WebServlet(urlPatterns = {"/profile/ChangePasswordServlet", "/admin-profile/ChangePasswordServlet"})
public class ChangePasswordServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String currentPassword = request.getParameter("currentPassword");
		String newPassword = request.getParameter("newPassword");
		String confirmPassword = request.getParameter("confirmPassword");
		String empId = (String) request.getSession().getAttribute("empId");
		JSONParser parser = new JSONParser();
		JSONArray userArray = new JSONArray();
		
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		
		Pattern passwordPattern = Pattern.compile("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$");
		Matcher matcher = passwordPattern.matcher(newPassword);
		if(!matcher.matches()) {
			response.getWriter().write("{\"status\":\"error\", \"message\":\"weak Password\"}");
			return;
		}
		
		if(!confirmPassword.equals(newPassword)) {
			response.getWriter().write("{\"status\":\"error\", \"message\":\"Passwords Dont match\"}");
			return;
		}
		String filePath = Config.DATA_FOLDER_PATH;
		try(FileReader fReader = new FileReader(filePath + "/User.json")) {
			userArray = (JSONArray) parser.parse(fReader);
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		
		for(Object userObject: userArray) {
			JSONObject userJson = (JSONObject) userObject;
			if(userJson.get("empId").equals(empId) && userJson.get("password").equals(currentPassword)) {
				userJson.put("password", newPassword);
				break;
			}
			else if(userJson.get("empId").equals(empId) && !userJson.get("password").equals(currentPassword)) {
				response.getWriter().write("{\"status\":\"error\", \"message\":\"Old Password Dont match\"}");
				return;
			}
		}
		
		try(FileWriter fWriter = new FileWriter(filePath + "/User.json")) {
			fWriter.write(userArray.toJSONString());
			fWriter.flush();
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		
		response.getWriter().write("{\"status\":\"success\"}");
	}

}
