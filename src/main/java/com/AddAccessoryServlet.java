package com;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.concurrent.CountDownLatch;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.util.Config;

@WebServlet("/admin-profile/AddAccessoryServlet")
public class AddAccessoryServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String accessory = request.getParameter("accessoryType");
		String wired = request.getParameter("wired");
		String empId = "";
		
		JSONParser parser = new JSONParser();
		JSONArray accessoryArray = new JSONArray();
		
		String filePath = Config.DATA_FOLDER_PATH;
		
		try(FileReader fReader = new FileReader(filePath+"/Accessory.json")) {
			accessoryArray = (JSONArray) parser.parse(fReader);
		} catch (Exception e) {
			e.printStackTrace();
		}
		int count = accessoryArray.size();
		JSONObject newAccessory = new JSONObject();
		newAccessory.put("accessoryId", count + 1);
		newAccessory.put("accessory", accessory);
		newAccessory.put("wired", wired);
		newAccessory.put("status", "Not Allocated");
		newAccessory.put("empId", empId);
		
		accessoryArray.add(newAccessory);
		
		try(FileWriter fWriter = new FileWriter(filePath+"/Accessory.json")) {
			fWriter.write(accessoryArray.toJSONString());
			fWriter.flush();
		}catch (Exception e) {
			e.printStackTrace();
		}
		response.setContentType("application/json");
        response.getWriter().write("{\"status\":\"success\"}");
		
	}

}
