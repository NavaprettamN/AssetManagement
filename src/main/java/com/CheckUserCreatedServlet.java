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

@WebServlet("/CheckUserCreatedServlet")
public class CheckUserCreatedServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		JSONArray userArray = new JSONArray();
		JSONParser parser = new JSONParser();

		String filePath = Config.DATA_FOLDER_PATH;
		try (FileReader fReader = new FileReader(filePath + "/User.json")) {
			userArray = (JSONArray) parser.parse(fReader);
		} catch (Exception e) {
			e.printStackTrace();
		}

		for (int i = 0; i < userArray.size(); i++) {
			JSONObject userJson = (JSONObject) userArray.get(i);
			if (userJson.containsKey("otp")) {
				userJson.remove("otp");
			}
			if (userJson.containsKey("userCreated")) {
				if (userJson.get("userCreated").equals("false")) {
					userArray.remove(i);
				}
			}
		}

		try (FileWriter fWriter = new FileWriter(filePath + "/User.json")) {
			fWriter.write(userArray.toJSONString());
			fWriter.flush();
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

}
