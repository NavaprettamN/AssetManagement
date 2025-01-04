package com;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.util.Config;

@WebServlet("/profile/AddUnallocationRequestServlet")
public class AddUnallocationRequestServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String assetNo = request.getParameter("assetNo");
		String empId = request.getParameter("empId");
		String accessoryId = request.getParameter("accessoryId");
		
		JSONArray requestArray = new JSONArray();
		JSONParser parser = new JSONParser();
		
		String filePath = Config.DATA_FOLDER_PATH;
		try (FileReader fReader = new FileReader(filePath+"/Request.json")) {
			requestArray = (JSONArray) parser.parse(fReader);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		if(assetNo != null ) {
			JSONObject newRequest = new JSONObject();
			int lastReqId = 0;
			if (!requestArray.isEmpty()) {
			    JSONObject lastRequest = (JSONObject) requestArray.get(requestArray.size() - 1);
			    lastReqId = ((Long) lastRequest.get("reqId")).intValue();
			}
			newRequest.put("reqId", lastReqId + 1);
			newRequest.put("assetNo", assetNo);
			newRequest.put("status", "Unallocation Requested");
			
			LocalDateTime currentDateTime = LocalDateTime.now();
			
			// Format date and time into a single string
			DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
			String currentTime = currentDateTime.format(dateTimeFormatter);
			
			newRequest.put("requestTime", currentTime);
			newRequest.put("empId", empId);
			
			requestArray.add(newRequest);
		}
		
		else if(accessoryId != null) {
			JSONObject newRequest = new JSONObject();
			int lastReqId = 0;
			if (!requestArray.isEmpty()) {
			    JSONObject lastRequest = (JSONObject) requestArray.get(requestArray.size() - 1);
			    lastReqId = ((Long) lastRequest.get("reqId")).intValue();
			}
			newRequest.put("reqId", lastReqId + 1);
			newRequest.put("accessoryId", accessoryId);
			newRequest.put("status", "Unallocation Requested");
			
			LocalDateTime currentDateTime = LocalDateTime.now();
			
			// Format date and time into a single string
			DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
			String currentTime = currentDateTime.format(dateTimeFormatter);
			
			newRequest.put("requestTime", currentTime);
			newRequest.put("empId", empId);
			
			requestArray.add(newRequest);
		}
		
        
        
        try (FileWriter fWriter = new FileWriter(filePath+"/Request.json")) {
            fWriter.write(requestArray.toJSONString());
            fWriter.flush();
        } catch (Exception e) {
            e.printStackTrace();
            return;
        }
        response.setContentType("application/json");
        response.getWriter().write("{\"status\":\"success\"}");
	}

}
