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
import org.json.simple.parser.JSONParser;

import com.util.Config;

@WebServlet(urlPatterns = {"/GetRequestServlet", "/admin-profile/GetRequestServlet", "/profile/GetRequestServlet"})
public class GetRequestServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        JSONArray requestArray = new JSONArray();
        JSONParser parser = new JSONParser();
        String filePath = Config.DATA_FOLDER_PATH;
        
        try(FileReader fReader = new FileReader(filePath+"/Request.json")) {
        	requestArray = (JSONArray) parser.parse(fReader);
        }
        catch (Exception e) {
        	e.printStackTrace();
        }
        
        response.setContentType("application/json");
        response.getWriter().write(requestArray.toJSONString());
    }
}
