package com;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;


import com.util.Config;

@WebServlet(name = "AddUserServlet", urlPatterns = "/AddUserServlet")
@MultipartConfig
public class AddUserServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String confirmPassword = request.getParameter("confirmPassword");
		String department = request.getParameter("department");
		String location = request.getParameter("location");	
		HttpSession session = request.getSession();
		String empId = (String) session.getAttribute("empId");
		
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		
		Pattern passwordPattern = Pattern.compile("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$");
		Matcher matcher = passwordPattern.matcher(password);
		if(!matcher.matches()) {
			response.getWriter().write("{\"status\":\"error\", \"message\":\"weak Password\"}");
			return;
		}
		
		if(!confirmPassword.equals(password)) {
			response.getWriter().write("{\"status\":\"error\", \"message\":\"Passwords Dont match\"}");
			return;
		}
		
	 
		JSONParser parser = new JSONParser();
		JSONArray userArray = new JSONArray();
		
		Part filePart = request.getPart("profilePic"); 

        String uploadPathAbsolute = "D:\\Navaprettam - I113\\OneDrive - EDS Technologies Pvt Ltd\\Desktop\\Practice\\AssetManagement\\AssetManagement_v007\\src\\main\\webapp\\images\\profilepic\\"+empId+".png";
        String uploadPathRelative = getServletContext().getRealPath("/images/profilepic/") + empId + ".png";
 
		 if (filePart != null && filePart.getSize() > 0) {
		        try (InputStream fileContent = filePart.getInputStream()) {
		            File tempFile = File.createTempFile("profile-pic", ".tmp");
		            Files.copy(fileContent, tempFile.toPath(), java.nio.file.StandardCopyOption.REPLACE_EXISTING);

		            Files.copy(tempFile.toPath(), Paths.get(uploadPathAbsolute), java.nio.file.StandardCopyOption.REPLACE_EXISTING);
		            Files.copy(tempFile.toPath(), Paths.get(uploadPathRelative), java.nio.file.StandardCopyOption.REPLACE_EXISTING);
		            
		            tempFile.delete();
		        } catch (IOException e) {
		            e.printStackTrace();
		            log("Error while processing the profile picture upload.");
		        }
	    } else {
	    	log("the user has not given the profile pic");
	        String defaultProfilePicPath = "D:\\Navaprettam - I113\\OneDrive - EDS Technologies Pvt Ltd\\Desktop\\Practice\\AssetManagement\\AssetManagement_v007\\src\\main\\webapp\\images\\profilepic\\default.png";
	        Files.copy(Paths.get(defaultProfilePicPath), Paths.get(uploadPathRelative), java.nio.file.StandardCopyOption.REPLACE_EXISTING);
	    }
		 
		
		String filePath = Config.DATA_FOLDER_PATH + "/User.json";
		try (FileReader fReader = new FileReader(filePath)) {
			userArray = (JSONArray) parser.parse(fReader);
			for(Object user : userArray) {
				JSONObject userJson = (JSONObject) user;
				if(userJson.get("empId").equals(empId)) {
					userJson.put("username", username);
					userJson.put("password", password);
					userJson.put("department", department);
					userJson.put("location", location);
					userJson.put("manager", "");
					userJson.put("isManager", "false");
					userJson.put("profilePic", "images/profilepic/" + empId + ".png");
					userJson.put("active", "Yes");
					userJson.remove("userCreated");
					break;
				}
			}
		} catch (Exception e) {
			System.out.println(e);
		}
		
		
//		JSONObject newUser = new JSONObject();
//		newUser.put("empId", empId);
//		newUser.put("username", username);
//		newUser.put("password", password);
//		newUser.put("department", department);
//		newUser.put("location", location);
//		newUser.put("manager", "");
//		newUser.put("isManager", "false");
//		
//		userArray.add(newUser);
		
		
		try(FileWriter fWriter = new FileWriter(filePath)) {
            fWriter.write(userArray.toJSONString());
            fWriter.flush();
            
		} catch (Exception e) {
			System.out.println("error in writing the file");
		}
		session.removeAttribute("empId");
		response.getWriter().write("{\"status\":\"success\", \"redirect\":\"./index\"}");
	}
}

//[{"empId":"I113","password":"Nava@123","manager":"","isManager":"false","location":"Bangalore","department":"Consultancy","username":"Navaprettam"}, {"empId":"superAdmin","password":"superAdmin","username":"superAdmin", "isAdmin": "superAdmin"}, {"empId": "admin", "username": "admin", "password": "admin", "isAdmin": "admin"}]
