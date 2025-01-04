package com;
 
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.util.Config;
import com.util.MailUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.sql.Date;
import java.util.Properties;
import java.util.Random;

//import javax.mail.Authenticator;
//import javax.mail.Message;
//import javax.mail.MessagingException;
//import javax.mail.PasswordAuthentication;
//import javax.mail.Session;
//import javax.mail.Transport;
//import javax.mail.internet.InternetAddress;
//import javax.mail.internet.MimeMessage;
 
import javax.mail.*;
import javax.mail.internet.*;
import javax.xml.stream.events.StartDocument;

import java.io.FileReader;
import java.io.FileWriter;
import java.util.Properties;
import java.util.Random;
 
import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;


@WebServlet("/SendOtpServlet")
public class SendOtpServlet extends HttpServlet {
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
        String recipientEmail = request.getParameter("empMail");
        String empId = request.getParameter("empId");
        HttpSession session = request.getSession();
        JSONParser parser = new JSONParser();
        JSONArray userArray = new JSONArray();
        String filePath = Config.DATA_FOLDER_PATH;
        try(FileReader fReader = new FileReader(filePath+"/User.json")) {
        	userArray = (JSONArray) parser.parse(fReader);
        }
        catch (Exception e) {
        	e.printStackTrace();
        }
        
        for(Object userObject: userArray) {
        	JSONObject userJson = (JSONObject) userObject;
        	if(userJson.get("empId").equals(empId)) {
        		log("testing error Msg");
        		response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"status\":\"error\", \"message\":\"Existing Employee ID\"}");
                return;
        	}
        }
        
        String otp = generateOTP(6);
        
        String subject = "Your OTP Code";
        String content = "<html><body><h2>Your OTP Code</h2><p>OTP: <strong>" + otp + "</strong></p></body></html>";
        
        sendMailAsync(recipientEmail, subject, content);
        
    	
        session.setAttribute("otpStatus", "sent");
        log("testing : sendOtpServlet");
        
        
        JSONObject newUser = new JSONObject();
        
        newUser.put("empId", empId);
        newUser.put("password", otp);
        newUser.put("empMail", recipientEmail);
        newUser.put("userCreated", "false");
        
        userArray.add(newUser);
        try(FileWriter fWriter = new FileWriter(filePath+"/User.json")) {
        	fWriter.write(userArray.toJSONString());
        	fWriter.flush();
        	
        }
        catch (Exception e) {
        	e.printStackTrace();
        }
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"status\":\"success\"}");
	}

    
    private void sendMailAsync(String empMail, String subject, String content) {
    	new Thread(() ->  {
    		boolean otpSent = MailUtil.sendMail(empMail, subject, content);
    		log(otpSent? "Otp sent": "otp not sent");
    	}).start();
    }
}