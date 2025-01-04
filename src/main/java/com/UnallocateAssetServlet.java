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

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.util.Config;

@WebServlet("/admin-profile/UnallocateAssetServlet")
public class UnallocateAssetServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
     
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String reqId = request.getParameter("reqId");

		JSONArray requestArray = new JSONArray();
        JSONParser parser = new JSONParser();

        String filePath = Config.DATA_FOLDER_PATH;
        try (FileReader fReader = new FileReader(filePath+"/Request.json")) {
            requestArray = (JSONArray) parser.parse(fReader);
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        JSONArray assetArray = new JSONArray();
        try (FileReader fReader = new FileReader(filePath+"/Asset.json")) {
            assetArray = (JSONArray) parser.parse(fReader);
        } catch (Exception e) {
            e.printStackTrace();
        }
        JSONArray accessoryArray = new JSONArray();
        try (FileReader fReader = new FileReader(filePath+"/Accessory.json")) {
        	accessoryArray = (JSONArray) parser.parse(fReader);
        } catch (Exception e) {
        	e.printStackTrace();
        }
        
        String assetNo = null;
        String accessoryId = null;
        for(Object requestObject: requestArray) {
        	JSONObject requestJson = (JSONObject) requestObject;
        	if(requestJson.get("reqId").toString().equals(reqId)) {
        		requestJson.put("status", "Unallocated");
        		
        		LocalDateTime currentDateTime = LocalDateTime.now();
                DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        	    String currentTime = currentDateTime.format(dateTimeFormatter);
                  		 
        	    requestJson.put("adminTime", currentTime);
        		
        		if(requestJson.containsKey("assetNo"))
        			assetNo = (String) requestJson.get("assetNo");
        		if(requestJson.containsKey("accessoryId"))
        			accessoryId = (String) requestJson.get("accessoryId");
        		log(assetNo);
        		break;
        	}
        }
        
        if(assetNo != null) {        	
        	for(Object assetObject: assetArray) {
        		JSONObject assetJson = (JSONObject) assetObject;
        		if(assetJson.get("assetNo").equals(assetNo)) {
        			assetJson.put("status", "Not Allocated");
        			assetJson.put("empId", "");
        			
        			break;
        		}
        	}
        }
        if (accessoryId != null) {
        	for(Object accessoryObject: accessoryArray) {
        		JSONObject accessoryJson = (JSONObject) accessoryObject;
        		if(accessoryJson.get("accessoryId").toString().equals(accessoryId)) {
        			accessoryJson.put("status", "Not Allocated");
        			accessoryJson.put("empId", "");
        			break;
        		}
        	}
		}
        
        
        try (FileWriter fWriter = new FileWriter(filePath+"/Request.json")) {
            fWriter.write(requestArray.toJSONString());
            fWriter.flush();
        } catch (Exception e) {
            e.printStackTrace();
            return;
        }
        
        try (FileWriter fWriter = new FileWriter(filePath+"/Asset.json")) {
            fWriter.write(assetArray.toJSONString());
            fWriter.flush();
        } catch (Exception e) {
            e.printStackTrace();
            return;
        }
        
        try (FileWriter fWriter = new FileWriter(filePath+"/Accessory.json")) {
        	fWriter.write(accessoryArray.toJSONString());
        	fWriter.flush();
        } catch (Exception e) {
        	e.printStackTrace();
        	return;
        }
        
	}

}
