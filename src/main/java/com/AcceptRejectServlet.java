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
import com.util.MailUtil;

@WebServlet("/profile/AcceptRejectServlet")
public class AcceptRejectServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
   
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String reqId = request.getParameter("reqId");
		String status = request.getParameter("status");
		String resMsg = request.getParameter("resMsg");
		String reqMsg = request.getParameter("reqMsg");
		String priority = request.getParameter("priority");
		if(status.equals("Accepted") && priority.equals("High") && priority != null) { 
			sendMail(reqMsg);
		}
		
		JSONParser parser = new JSONParser();
		JSONArray requestArray = new JSONArray();
		String filePath = Config.DATA_FOLDER_PATH;
		try ( FileReader fReader = new FileReader(filePath+"/Request.json")) {
			requestArray = (JSONArray) parser.parse(fReader);
		}
		 catch (Exception e) {
			 e.printStackTrace();
		 }
		
		for(Object requestObject: requestArray) {
			JSONObject requestJson = (JSONObject) requestObject;
			if(reqId.equals(requestJson.get("reqId").toString())) { 
				log(requestJson.toJSONString());
				requestJson.put("status", status);
				requestJson.put("resMsg", resMsg);
				LocalDateTime currentDateTime = LocalDateTime.now();
		        DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
			    String currentTime = currentDateTime.format(dateTimeFormatter);
		          		 
			    requestJson.put("managerTime", currentTime);
				break;
			}
		}
		
		try(FileWriter fWriter = new FileWriter(filePath+"/Request.json")) {
			fWriter.write(requestArray.toJSONString());
			fWriter.flush();
		}catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	private void sendMail(String reqMsg) {
		String mailId = null;
		JSONParser parser = new JSONParser();
		String filePath = Config.DATA_FOLDER_PATH;
		try (FileReader reader = new FileReader(filePath+"/User.json")) {
			JSONArray usersArray = (JSONArray) parser.parse(reader);
			for (Object obj : usersArray) {
				JSONObject user = (JSONObject) obj;
				if(user.containsKey("isAdmin")) {					
					if (user.get("isAdmin").equals("admin")) {
						mailId = (String) user.get("empMail");
						log("empMail : " + mailId);
						break;                
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		sendMailAsync(mailId, "Request", "<p>"+ reqMsg + "<p>");
		return;
	}
	
	private void sendMailAsync(String empMail, String subject, String content) {
    	new Thread(() ->  {
    		boolean otpSent = MailUtil.sendMail(empMail, subject, content);
    		log(otpSent? "Otp sent": "otp not sent");
    	}).start();
    }

}
