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

/**
 * Servlet implementation class WithdrawRequestServlet
 */
@WebServlet("/profile/WithdrawRequestServlet")
public class WithdrawRequestServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
 
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String reqId = request.getParameter("reqId");
		log(reqId);
		
		JSONArray requestArray = new JSONArray();
		JSONParser parser = new JSONParser();
		
		String filePath = Config.DATA_FOLDER_PATH;
		
		try(FileReader fReader = new FileReader(filePath + "/Request.json")) {
			requestArray = (JSONArray) parser.parse(fReader);
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		
		for(int i = 0; i < requestArray.size(); i++ ) {
			Object requestObject = requestArray.get(i);
			JSONObject requestJson = (JSONObject) requestObject;
			if(requestJson.get("reqId").toString().equals(reqId)) {
				requestArray.remove(i);
				break;
			}
		}
		
		try (FileWriter fWriter = new FileWriter(filePath + "/Request.json")) {
			fWriter.write(requestArray.toJSONString());
			fWriter.flush();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}

}
