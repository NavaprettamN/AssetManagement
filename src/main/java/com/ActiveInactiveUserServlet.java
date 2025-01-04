package com;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Iterator;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.util.Config;

@WebServlet("/admin-profile/ActiveInactiveUserServlet")
public class ActiveInactiveUserServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String empId = request.getParameter("empId");
		
		JSONArray userArray = new JSONArray();
		JSONParser parser = new JSONParser();
		
		String filePath = Config.DATA_FOLDER_PATH;
		try(FileReader fReader = new FileReader(filePath + "/User.json")) {
			userArray = (JSONArray) parser.parse(fReader);
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		
		JSONArray requestArray = new JSONArray();
		
		try(FileReader fReader = new FileReader(filePath + "/Request.json")) {
			requestArray = (JSONArray) parser.parse(fReader);
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		
		JSONArray assetArray = new JSONArray();
		
		try(FileReader fReader = new FileReader(filePath + "/Asset.json")) {
			assetArray = (JSONArray) parser.parse(fReader);
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		
		JSONArray accessoryArray = new JSONArray();
		
		try(FileReader fReader = new FileReader(filePath + "/Accessory.json")) {
			accessoryArray = (JSONArray) parser.parse(fReader);
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		
		
		
		
		boolean setInactive = false;
		for(Object userObject: userArray) {
			JSONObject userJson = (JSONObject) userObject;
			if(userJson.get("empId").equals(empId) && userJson.containsKey("active")) {
				if(userJson.get("active").equals("Yes")) {
					for(Object assetObject: assetArray) {
						JSONObject assetJson = (JSONObject) assetObject;
						if(assetJson.get("empId").equals(empId)) {
							response.getWriter().write("{\"status\":\"error\", \"error\":\"Unallocation Required\"}");
							return;
						}
					}
					
					for(Object accessoryObject: accessoryArray) {
						JSONObject accessoryJson = (JSONObject) accessoryObject;
						if(accessoryJson.get("empId").equals(empId)) {
							response.getWriter().write("{\"status\":\"error\", \"error\":\"Unallocation Required\"}");
							return;
						}
					}
					
					userJson.put("active", "No");
					userJson.put("isManager", "false");
					userJson.put("manager", "");
					for(Object managerObject: userArray) {
						JSONObject managerJson = (JSONObject) managerObject;
						if(managerJson.get("manager").equals(empId)) {
							managerJson.put("manager", "");
						}
					}
					
					for(Object requestObject: requestArray) {
						JSONObject requestJson = (JSONObject) requestObject;
						if(requestJson.get("empId").equals(empId)) {
							requestJson.put("status", "Requested");
							requestJson.put("managerId", "");
						}
					}
					
					setInactive = true;
					break;
					
				}
				else if (userJson.get("active").equals("No")) {
					userJson.put("active", "Yes");
					break;
				}
			}
		}
		if(setInactive) {			
			for(Object requestObject: requestArray) {
				JSONObject requestJson = (JSONObject) requestObject;
				if(requestJson.containsKey("managerId")) {					
					if(requestJson.get("managerId").equals(empId) && requestJson.get("status").equals("Requested")) {
						requestJson.put("managerId", "");
					}
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
		
		try(FileWriter fWriter = new FileWriter(filePath + "/Request.json")) {
			fWriter.write(requestArray.toJSONString());
			fWriter.flush();
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write("{\"status\":\"success\"}");
	}

}
