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


@WebServlet(urlPatterns = {"/AssignManagerServlet", "/admin-profile/AssignManagerServlet"})
public class AssignManagerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String empId = request.getParameter("empId");
        String managerId = request.getParameter("managerId");
        
        log(empId);
        String[] userIdArray = null;
        if (empId != null && !empId.isEmpty()) { 
        	userIdArray = empId.split(",");
        }
        log(userIdArray.toString());
        
        JSONArray userArray = new JSONArray();
        JSONParser parser = new JSONParser();
        
        String filePath = Config.DATA_FOLDER_PATH;
        
        try (FileReader fReader = new FileReader(filePath+"/User.json")) {
            userArray = (JSONArray) parser.parse(fReader);
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        JSONArray requestArray = new JSONArray();
        
        try (FileReader fReader = new FileReader(filePath + "/Request.json")) {
        	requestArray = (JSONArray) parser.parse(fReader);
        }
        catch (Exception e) {
        	e.printStackTrace();
        }
  
        if (userIdArray != null && userIdArray.length > 0) {
            for (String userId : userIdArray) {
                for (Object obj : userArray) {
                    JSONObject userJson = (JSONObject) obj;
                    if (userJson.get("empId").equals(userId)) {
                        userJson.put("manager", managerId);
                    }
                }

                for (Object reqObj : requestArray) {
                    JSONObject requestJson = (JSONObject) reqObj;
                    if (requestJson.get("empId").equals(userId) && "Requested".equals(requestJson.get("status"))) {
                    	log("request empId: " + empId + "manager ID: " + managerId);
                        requestJson.put("managerId", managerId);
                    }
                }
            }
        }
        
        

        for (int i = 0; i < userArray.size(); i++) {
            JSONObject userJson = (JSONObject) userArray.get(i);
            String currentManagerId = (String) userJson.get("empId");
            boolean isManager = false;

            for (int j = 0; j < userArray.size(); j++) {
                JSONObject otherUserJson = (JSONObject) userArray.get(j);
                if (currentManagerId.equals(otherUserJson.get("manager"))) {
                    isManager = true;
                    break;
                }
            }

            userJson.put("isManager", isManager ? "true" : "false");
        }

        
        try (FileWriter fWriter = new FileWriter(filePath + "/User.json")) {
            fWriter.write(userArray.toJSONString());
            fWriter.flush();
        } catch (Exception e) {
            e.printStackTrace();
        }
        try (FileWriter fWriter = new FileWriter(filePath + "/Request.json")) {
        	fWriter.write(requestArray.toJSONString());
        	fWriter.flush();
        } catch (Exception e) {
        	e.printStackTrace();
        }
    }
}
