package com;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.FileReader;
import java.io.IOException;


import org.json.simple.JSONArray;
import org.json.simple.parser.JSONParser;

import com.util.Config;


@WebServlet("/admin-profile/GetNumberServlet")
public class GetNumberServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		
		JSONArray assetArray = new JSONArray();
		JSONArray accessoryArray = new JSONArray();
		JSONArray userArray = new JSONArray();
		JSONParser parser = new JSONParser();
		String filePath = Config.DATA_FOLDER_PATH;
		try(FileReader fReader = new FileReader(filePath + "/Asset.json")) {
			assetArray = (JSONArray) parser.parse(fReader);
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		try(FileReader fReader = new FileReader(filePath + "/Accessory.json")) {
			accessoryArray = (JSONArray) parser.parse(fReader);
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		try(FileReader fReader = new FileReader(filePath + "/User.json")) {
			userArray = (JSONArray) parser.parse(fReader);
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		
		response.getWriter().write("{\"assetNumber\":\"" + assetArray.size() + "\",\"accessoryNumber\":\""+ accessoryArray.size() + "\"}");
		
	}

}
