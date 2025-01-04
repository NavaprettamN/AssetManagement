package com;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.FileReader;
import java.io.IOException;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import com.util.Config;
@WebServlet("/AuthServlet")
public class AuthServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		boolean isAuthenticated = false;
		boolean isAdmin = false;
		boolean isSuperAdmin = false;
		boolean isManager = false;
		String empId = request.getParameter("empId");
		String password= request.getParameter("password");
		String username = null;
		HttpSession session = request.getSession();
		
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		
		JSONParser parser = new JSONParser();	
		String filePath = Config.DATA_FOLDER_PATH;
		try(FileReader fReader = new FileReader(filePath+"/User.json");) {
			JSONArray array = (JSONArray) parser.parse(fReader);
			for(Object obj: array) {
				JSONObject userObject = (JSONObject) obj;
				if(userObject.get("empId").equals(empId) && userObject.get("password").equals(password)) {
					if(userObject.containsKey("isAdmin")) {
						if(userObject.get("isAdmin").equals("superAdmin")) {
							isSuperAdmin = true;
							isAuthenticated = true;
							username = (String) userObject.get("username"); 
							break;
						}
						else if(userObject.get("isAdmin").equals("admin")) {
							isAuthenticated = true;
							isAdmin = true;
							username = (String) userObject.get("username"); 
							break;
						}
					}
					else if(userObject.get("isManager").equals("true") && userObject.get("active").equals("Yes")) {
						isManager = true;
						isAuthenticated = true;
						username = (String) userObject.get("username");
						break;
					}
					else if(userObject.get("isManager").equals("false") && userObject.get("active").equals("Yes")) {
						username = (String) userObject.get("username");
						isAuthenticated = true;
						break;
					}
				}
			}
			if(isAdmin && isAuthenticated) {
				session.setAttribute("username", username);
				session.setAttribute("empId", empId);
				session.setAttribute("isAdmin", "admin");
				response.getWriter().write("{\"status\":\"success\", \"redirect\":\"admin-profile/dashboard\"}");
				return;
			}
			else if(isSuperAdmin && isAuthenticated) {
				session.setAttribute("username", username);
				session.setAttribute("empId", empId);
				session.setAttribute("isAdmin", "superAdmin");
				response.getWriter().write("{\"status\":\"success\", \"redirect\":\"admin-profile/dashboard\"}");
				return;
			}
			else if(isAuthenticated && isManager) {
				session.setAttribute("username", username);
				session.setAttribute("empId", empId);
				log("testing backend : ismanager");
				session.setAttribute("isManager", "true");
				response.getWriter().write("{\"status\":\"success\", \"redirect\":\"profile/dashboard\"}");
				return;
			}
			else if(isAuthenticated) {
				session.setAttribute("username", username);
				session.setAttribute("empId", empId);
				session.setAttribute("isManager", "false");
				response.getWriter().write("{\"status\":\"success\", \"redirect\":\"profile/dashboard\"}");
				return;
			}
			else {
				response.getWriter().write("{\"status\":\"error\", \"errorMsg\":\"Incorrect Employee ID or Password\"}");
				return;
			}			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
