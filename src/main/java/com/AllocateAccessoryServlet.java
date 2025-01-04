package com;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.channels.NonReadableChannelException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.util.Config;

@WebServlet("/admin-profile/AllocateAccessoryServlet")
public class AllocateAccessoryServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String accessoryId = request.getParameter("accessoryId");
		String status = request.getParameter("status");
		String reqId = request.getParameter("reqId");
		String resMsg = request.getParameter("resMsg");
		
		log(reqId + " " + accessoryId + " " + status + " " + resMsg);
		JSONArray accessoryArray = new JSONArray();
		JSONArray requestArray = new JSONArray();
		JSONParser parser = new JSONParser();
		
		String filePath = Config.DATA_FOLDER_PATH;
		
		try(FileReader fReader = new FileReader(filePath + "/Request.json")) {
			requestArray = (JSONArray) parser.parse(fReader);
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		
		if(status == "Cancelled") {
			for(Object requestObject: requestArray) {
				JSONObject requestJson = (JSONObject) requestObject;
				if(requestJson.get("reqId").toString().equals(reqId)) {
					requestJson.put("status", status);
					requestJson.put("resMsg", resMsg);
					
					LocalDateTime currentDateTime = LocalDateTime.now();
			        DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
				    String currentTime = currentDateTime.format(dateTimeFormatter);
			          		 
				    requestJson.put("adminTime", currentTime);
					
					break;
				}
			}
			
			try {
				FileWriter fWriter = new FileWriter(filePath + "/Request.json");
				fWriter.write(requestArray.toJSONString());
				fWriter.flush();
				return;
			} catch (Exception e) {
				e.printStackTrace();
			}
			return;
		}
		
		
		try(FileReader fReader = new FileReader(filePath + "/Accessory.json")) {
			accessoryArray = (JSONArray) parser.parse(fReader);
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		
		String empId = null;
		
		for(Object requestObject: requestArray) {
			JSONObject requestJson = (JSONObject) requestObject;
			log(requestJson.toString());
			if(requestJson.get("reqId").toString().equals(reqId)) {
				requestJson.put("status", status);
				empId = (String) requestJson.get("empId");
				requestJson.put("accessoryId", accessoryId);
				LocalDateTime currentDateTime = LocalDateTime.now();
		        DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
			    String currentTime = currentDateTime.format(dateTimeFormatter);
		          		 
			    requestJson.put("adminTime", currentTime);
				
				break;
			}
		}
		
		
		for(Object accessoryObject: accessoryArray) {
			JSONObject accessoryJson = (JSONObject) accessoryObject;
			if(accessoryJson.get("accessoryId").toString().equals(accessoryId)) {
				accessoryJson.put("status", status);
				accessoryJson.put("empId", empId);
				break;
			}
		}
		
		try {
			FileWriter fWriter = new FileWriter(filePath + "/Request.json");
			fWriter.write(requestArray.toJSONString());
			fWriter.flush();
		} catch (Exception e) {
			e.printStackTrace();
		}
		try {
			FileWriter fWriter = new FileWriter(filePath + "/Accessory.json");
			fWriter.write(accessoryArray.toJSONString());
			fWriter.flush();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		log("success");
	}
}
