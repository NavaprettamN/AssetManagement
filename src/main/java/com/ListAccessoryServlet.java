package com;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;

import org.json.simple.JSONArray;
import org.json.simple.parser.JSONParser;


import com.util.Config;
@WebServlet(urlPatterns = {"/admin-profile/ListAccessoryServlet", "/profile/ListAccessoryServlet"})
public class ListAccessoryServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		JSONParser parser = new JSONParser();
		JSONArray accessoryArray = new JSONArray();
		String filePath = Config.DATA_FOLDER_PATH;
		try(FileReader fReader = new FileReader(filePath+"/Accessory.json")) {
			accessoryArray = (JSONArray) parser.parse(fReader);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print(accessoryArray.toJSONString());
	}


}
