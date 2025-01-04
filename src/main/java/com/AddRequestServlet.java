package com;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.util.Config;
import com.util.MailUtil;

import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@WebServlet("/profile/AddRequestServlet")
public class AddRequestServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String empId = (String) session.getAttribute("empId"); 
        String managerId = getManagerId(empId);
        
        log("Manager ID  : " + managerId);
        String type = request.getParameter("type");
        String os = request.getParameter("os");
        String make = request.getParameter("make");
        String model = request.getParameter("model");
        String hdd = request.getParameter("hdd");
        String ram = request.getParameter("ram");
        String graphics = request.getParameter("graphics");
        String priority = request.getParameter("priority");
        String reqMsg = request.getParameter("reqMsg");
        String accessory = null;
        String wired = null;
        if(type.equals("Accessories")) {
        	accessory = request.getParameter("accessoryType");
        	wired = request.getParameter("wired");        	
        }
        else {
        	accessory = "";
        	wired = "";
        }
        log("priority : " + priority);

        JSONArray requestArray = new JSONArray();
        JSONParser parser = new JSONParser();

        String filePath = Config.DATA_FOLDER_PATH;
        try (FileReader fReader = new FileReader(filePath+"/Request.json")) {
            requestArray = (JSONArray) parser.parse(fReader);
        } catch (Exception e) {
            e.printStackTrace();
        }

        JSONObject newRequest = new JSONObject();
        newRequest.put("reqId", requestArray.size() + 1);
        newRequest.put("empId", empId);
        newRequest.put("managerId", managerId);
        newRequest.put("type", type);
        newRequest.put("os", os);
        newRequest.put("make", make);
        newRequest.put("model", model);
        newRequest.put("hdd", hdd);
        newRequest.put("ram", ram);
        newRequest.put("graphics", graphics);
        newRequest.put("priority", priority);
        newRequest.put("reqMsg", reqMsg);
        newRequest.put("accessories", accessory);
        newRequest.put("wired", wired);
        
        LocalDateTime currentDateTime = LocalDateTime.now();
        DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
	    String currentTime = currentDateTime.format(dateTimeFormatter);
          		 
	    newRequest.put("requestTime", currentTime);
        
        if(managerId == "pass") {
        	newRequest.put("status", "Accepted");
        	newRequest.put("managerTime", currentTime);
        	if(priority.equals("High"))
        		sendMailAsync(reqMsg);
        }
        else {
        	newRequest.put("status", "Requested");        	
        }
        newRequest.put("resMsg", "");

        requestArray.add(newRequest);

        try (FileWriter fWriter = new FileWriter(filePath+"/Request.json")) {
            fWriter.write(requestArray.toJSONString());
            fWriter.flush();
        } catch (Exception e) {
            e.printStackTrace();
            return;
        }
        response.setContentType("application/json");
        response.getWriter().write("{\"status\":\"success\"}");

    }

    private String getManagerId(String empId) {
        String managerId = null;
        String isManager = null;
        JSONParser parser = new JSONParser();
        String filePath = Config.DATA_FOLDER_PATH;
        try (FileReader reader = new FileReader(filePath+"/User.json")) {
            JSONArray usersArray = (JSONArray) parser.parse(reader);
            for (Object obj : usersArray) {
                JSONObject user = (JSONObject) obj;
                if (user.get("empId").equals(empId)) {
                	isManager = (String) user.get("isManager");
                    managerId = (String) user.get("manager");
                    log(isManager);
                    log(managerId);
                   	break;                
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        if(isManager.equals("true") && managerId.equals("")) {
        	return "pass";
        }
        
        else {
        	return managerId;
        }
    }
    
//    private void sendMail(String empId, String reqMsg) {
//        String mailId = null;
//        JSONParser parser = new JSONParser();
//        String filePath = Config.DATA_FOLDER_PATH;
//        try (FileReader reader = new FileReader(filePath+"/User.json")) {
//            JSONArray usersArray = (JSONArray) parser.parse(reader);
//            for (Object obj : usersArray) {
//                JSONObject user = (JSONObject) obj;
//                if (user.get("empId").equals(empId)) {
//                	mailId = (String) user.get("empMail");
//                	log("empMail : " + mailId);
//                   	break;                
//                }
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//    	boolean isMailSent = MailUtil.sendMail(mailId, "Request", "<p>Something<p>");
//    	if(isMailSent)
//    		log("mail sent");
//        return;
//    }
    
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
		boolean isMailSent = MailUtil.sendMail(mailId, "Request", "<p>"+ reqMsg + "<p>");
		if(isMailSent)
			log("mail sent");
		return;
	}
    
    private void sendMailAsync(String reqMsg) {
        new Thread(() -> {
            sendMail(reqMsg);
        }).start();
    }
}
