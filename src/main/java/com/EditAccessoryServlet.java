package com;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.util.Config;

@WebServlet("/admin-profile/EditAccessoryServlet")
public class EditAccessoryServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
  
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String accessoryId = request.getParameter("accessoryId");
		String empId = request.getParameter("allocation");
		log(accessoryId);
		log(empId);
		
		JSONArray accessoryArray = new JSONArray();
		JSONParser parser = new JSONParser();
		
		String filePath = Config.DATA_FOLDER_PATH;
		try(FileReader fReader = new FileReader(filePath+"/Accessory.json")) {
			accessoryArray = (JSONArray) parser.parse(fReader);
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		
		for(Object accessoryObject: accessoryArray) {
			JSONObject accessoryJson = (JSONObject) accessoryObject;
			if(accessoryJson.get("accessoryId").toString().equals(accessoryId)) {
				accessoryJson.put("empId", empId);
				if(empId.equals("")) {
					accessoryJson.put("status", "Not Allocated");
					break;
				}
				accessoryJson.put("status", "Allocated");
				break;
			}
		}
		try(FileWriter fWriter = new FileWriter(filePath+"/Accessory.json")) {
			fWriter.write(accessoryArray.toJSONString());
			fWriter.flush();
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		
	}

}
