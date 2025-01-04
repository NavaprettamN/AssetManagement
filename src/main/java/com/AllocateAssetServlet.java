package com;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.StringTokenizer;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.util.Config;

@WebServlet("/admin-profile/AllocateAssetServlet")
public class AllocateAssetServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String reqId = request.getParameter("reqId");
		String assetNo = request.getParameter("assetNo");
		String status = request.getParameter("status");
		String resMsg = request.getParameter("resMsg");
		log("request Id " +  reqId);
		log(assetNo);
		JSONParser parser = new JSONParser();
		JSONArray requestArray = new JSONArray();
		String filePath = Config.DATA_FOLDER_PATH;
		
		try (FileReader fReader = new FileReader(filePath+"/Request.json")) {
			requestArray = (JSONArray) parser.parse(fReader);
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		
		if(status.equals("Cancelled")) {
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
			try(FileWriter fWriter = new FileWriter(filePath+"/Request.json")) {
				fWriter.write(requestArray.toJSONString());
				fWriter.flush();
				
			}
			catch (Exception e) {
				e.printStackTrace();
			}
			return;
		}
		
		
		
		JSONArray assetArray = new JSONArray();
		String empId = null;
		try (FileReader fReader = new FileReader(filePath + "/Asset.json")) {
			assetArray = (JSONArray) parser.parse(fReader);
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		if(status.equals("Allocated")) {
			for(Object requestObject: requestArray) {
				JSONObject requestJson = (JSONObject) requestObject;
				if(requestJson.get("reqId").toString().equals(reqId)) {
					requestJson.put("status", status);
					empId = (String) requestJson.get("empId");
					requestJson.put("assetNo", assetNo);
					LocalDateTime currentDateTime = LocalDateTime.now();
			        DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
				    String currentTime = currentDateTime.format(dateTimeFormatter);
			          		 
				    requestJson.put("adminTime", currentTime);
					
					break;
				}
			}
			for(Object assetObject: assetArray) {
				JSONObject assetJson = (JSONObject) assetObject;
				if(assetJson.get("assetNo").toString().equals(assetNo)) {
					assetJson.put("empId", empId);
					assetJson.put("status", status);
					break;
				}
			}
		}
		try(FileWriter fWriter = new FileWriter(filePath+"/Request.json")) {
			fWriter.write(requestArray.toJSONString());
			fWriter.flush();
		}
		
		try(FileWriter fWriter = new FileWriter(filePath+"/Asset.json")) {
			fWriter.write(assetArray.toJSONString());
			fWriter.flush();
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		
	}

}
