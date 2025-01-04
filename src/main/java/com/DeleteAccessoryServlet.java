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
@WebServlet("/admin-profile/DeleteAccessoryServlet")
public class DeleteAccessoryServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String accessoryId = request.getParameter("accessoryId");
		System.out.println("testing : delete accessory servlet");
		JSONParser parser = new JSONParser();
		JSONArray accessoryArray = new JSONArray();
		
		String filePath = Config.DATA_FOLDER_PATH;
		
		try(FileReader fReader = new FileReader(filePath+"/Accessory.json")) {
			accessoryArray = (JSONArray) parser.parse(fReader);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		for(int i = 0; i < accessoryArray.size(); i++) {
			JSONObject accessory = (JSONObject) accessoryArray.get(i);
			if(accessory.containsKey("accessoryId")) {
				if(accessoryId.equals(accessory.get("accessoryId").toString())) {
					accessoryArray.remove(i);
					break;
				}				
			}
		}
		try(FileWriter fWriter = new FileWriter(filePath + "/Accessory.json")) {
			fWriter.write(accessoryArray.toJSONString());
			fWriter.flush();
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		response.setContentType("application/json");
        response.getWriter().write("{\"status\":\"success\"}");
	}

}
