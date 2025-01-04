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
import java.io.ObjectInputFilter.Config;
import java.nio.file.Files;
import java.nio.file.Paths;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
 

@WebServlet(urlPatterns = {"/admin-profile/EditProfilePicServlet","/profile/EditProfilePicServlet"})
@MultipartConfig
public class EditProfilePicServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		String empId = (String)session.getAttribute("empId");
		Part filePart = request.getPart("profilePic"); 
 
	        
        String uploadPath = getServletContext().getRealPath("/images/profilepic/") + empId + ".png";
        
        if (filePart != null && filePart.getSize() > 0) {
	        InputStream fileContent = filePart.getInputStream();
	        File file = new File(uploadPath);
	        Files.copy(fileContent, file.toPath(), java.nio.file.StandardCopyOption.REPLACE_EXISTING);
	    } else {
	        String defaultProfilePicPath = "D:\\Navaprettam - I113\\OneDrive - EDS Technologies Pvt Ltd\\Desktop\\Practice\\AssetManagement\\AssetManagement_v007\\src\\main\\webapp\\images\\profilepic\\default.png";
	        Files.copy(Paths.get(defaultProfilePicPath), Paths.get(uploadPath), java.nio.file.StandardCopyOption.REPLACE_EXISTING);
	    }
        
	    String filePath = com.util.Config.DATA_FOLDER_PATH;
	    JSONArray userArray = new JSONArray();
	    JSONParser parser = new JSONParser();
	    
	    try(FileReader fReader = new FileReader(filePath + "/User.json")) {
	    	userArray = (JSONArray) parser.parse(fReader);
	    }
	    catch (Exception e) {
	    	e.printStackTrace();
	    }
	    
	    for(Object userObject: userArray) {
	    	JSONObject userJson = (JSONObject) userObject;
	    	if(userJson.get("empId").equals(empId)) {
	    		userJson.put("profilePic", "images/profilepic/" + empId + ".png");
	    		break;
	    	}
	    }
	   
	    try(FileWriter fWriter = new FileWriter(filePath + "/User.json")) {
	    	fWriter.write(userArray.toJSONString());
	    	fWriter.flush();
	    }
	    catch (Exception e) {
	    	e.printStackTrace();
	    }
	    
	    response.setContentType("application/json");
	    response.setCharacterEncoding("UTF-8");
	    response.getWriter().write("{\"status\":\"success\", \"redirect\":\"user-profile\"}");
	}
 
}