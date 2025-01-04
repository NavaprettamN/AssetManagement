package com;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.util.Config;

@WebServlet("/admin-profile/AssignAdminServlet")
public class AssignAdminServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
   
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String empId = request.getParameter("empId");
		String role = request.getParameter("role");
		
		JSONArray userArray = new JSONArray();
		JSONParser parser = new JSONParser();
		
		String filePath = Config.DATA_FOLDER_PATH;
		try(FileReader fReader = new FileReader(filePath + "/User.json")) {
			userArray = (JSONArray) parser.parse(fReader);
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		
		if(role == null) {
			for(Object userObject: userArray) {
				JSONObject userJson = (JSONObject) userObject;
				if(userJson.get("empId").equals(empId)) {
					userJson.put("isManager", "false");
					if(userJson.containsKey("isAdmin")) {
						userJson.remove("isAdmin");
					}
					break;
				}
			}
		}
		
		else {			
			for(Object userObject: userArray) {
				JSONObject userJson = (JSONObject) userObject;
				if(userJson.get("empId").equals(empId)) {
					userJson.put("isAdmin", role.equals("Admin")? "admin": "superAdmin");
					if(userJson.containsKey("isManager")) {
						userJson.remove("isManager");
					}
					break;
				}
			}
		}
		
		try(FileWriter fWriter = new FileWriter(filePath + "/User.json")) {
			fWriter.write(userArray.toJSONString());
			fWriter.flush();
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		
	}

}
