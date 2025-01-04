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

@WebServlet("/admin-profile/EditAssetServlet")
public class EditAssetServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String assetNo = request.getParameter("assetNo");
		String empId = request.getParameter("allocation");
		String model = request.getParameter("model");
		String make = request.getParameter("make");
		String processor = request.getParameter("processor");
		String ram = request.getParameter("ram");
		String os = request.getParameter("os");
		String hdd = request.getParameter("hdd");
		String graphics = request.getParameter("graphics");
		
		log(assetNo);
		
		JSONParser parser = new JSONParser();
		JSONArray assetArray = new JSONArray();
		
		String filePath = Config.DATA_FOLDER_PATH;
		try(FileReader fReader = new FileReader(filePath+"/Asset.json")) {
			assetArray = (JSONArray) parser.parse(fReader);
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		
		for(Object assetObject: assetArray) {
			JSONObject assetJson = (JSONObject) assetObject;
			if(assetJson.get("assetNo").equals(assetNo)) {
				assetJson.put("empId", empId);
				assetJson.put("make", make);
				assetJson.put("model", model);
				assetJson.put("os", os);
				assetJson.put("ram", ram);
				assetJson.put("processor", processor);
				assetJson.put("hdd", hdd);
				assetJson.put("graphics", graphics);
				if(empId == "") {
					assetJson.put("status", "Not Allocated");
				}
				else if(empId != "") {
					assetJson.put("status", "Allocated");
				}
				break;
			}
		}
		
		try(FileWriter fWriter = new FileWriter(filePath+"/Asset.json")) {
			fWriter.write(assetArray.toJSONString());
			fWriter.flush();
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		
		response.getWriter().write("success");
	}

}
