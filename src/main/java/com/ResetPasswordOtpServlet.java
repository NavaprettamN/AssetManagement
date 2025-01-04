package com;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Properties;
import java.util.Random;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.util.Config;
import com.util.MailUtil;


@WebServlet("/ResetPasswordOtpServlet")
public class ResetPasswordOtpServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
     
	private String generateOTP(int length) {
        Random random = new Random();
        StringBuilder otp = new StringBuilder();
        for (int i = 0; i < length; i++) {
            otp.append(random.nextInt(10));
        }
        return otp.toString();
    }
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String empId = request.getParameter("empId");
		String empMail = null;
		boolean userFound = false;
		JSONArray userArray = new JSONArray();
		JSONParser parser = new JSONParser();
		JSONObject userJson = new JSONObject();
		
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		
		HttpSession httpSession = request.getSession();
		
		String filePath = Config.DATA_FOLDER_PATH;
		try(FileReader fReader = new FileReader(filePath+"/User.json")) {
			userArray = (JSONArray) parser.parse(fReader);
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		
		for(Object userObject: userArray) {
			userJson = (JSONObject) userObject;
			if(userJson.get("empId").equals(empId)) {
				empMail = (String) userJson.get("empMail");
				userFound = true;
				break;
			}
		}
		
		if (!userFound) {
			response.getWriter().write("{\"status\":\"error\", \"message\":\"The EmpId Does Not Exist\"}");
			return;
		}
		
		String otp = generateOTP(6);
        
            
        String subject = "Your OTP Code";
        String content = "<html><body><h2>Your OTP Code</h2><p>OTP: <strong>" + otp + "</strong></p></body></html>";
        
        sendMailAsync(empMail, subject, content);
        
        userJson.put("otp", otp);
        
        try(FileWriter fWriter = new FileWriter(filePath+"/User.json")) {
        	fWriter.write(userArray.toJSONString());
        	fWriter.flush();
        }
        catch (Exception e) {
        	e.printStackTrace();
        }
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        String empMailShow = empMail.length() >= 4 ? empMail.substring(0, 4) : empMail;
        response.getWriter().write("{\"status\":\"success\", \"message\":\""+ empMailShow +"\"}");
           
	}
	
	private void sendMailAsync(String empMail,String subject, String content) {
        new Thread(() -> {
            boolean otpMail =  MailUtil.sendMail(empMail, subject, content);
            log(otpMail? "Otp sent": "Otp not sent");
        }).start();
    }

}
 