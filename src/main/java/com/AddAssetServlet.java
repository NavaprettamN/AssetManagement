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
 * Servlet implementation class AddAssetServlet
 */
@WebServlet(urlPatterns = {"/AddAssetServlet", "/admin-profile/AddAssetServlet"})
public class AddAssetServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String assetNo = request.getParameter("assetNo");
        String serialNo = request.getParameter("serialNo");
        String type = request.getParameter("type");
        String make = request.getParameter("make");
        String model = request.getParameter("model");
        String processor = request.getParameter("processor");
        String ram = request.getParameter("ram");
        String hdd = request.getParameter("hdd");
        String graphics = request.getParameter("graphics");
        String os = request.getParameter("os");

        JSONParser parser = new JSONParser();
        JSONArray assetArray = new JSONArray();

        String filePath = Config.DATA_FOLDER_PATH;
        try (FileReader fReader = new FileReader(filePath+"/Asset.json")) {
            assetArray = (JSONArray) parser.parse(fReader);
        } catch (Exception e) {
            System.out.println("Error in reading: " + e.getMessage());
        }

        JSONObject newAsset = new JSONObject();
        newAsset.put("assetNo", assetNo);
        newAsset.put("serialNo", serialNo);
        newAsset.put("type", type);
        newAsset.put("make", make);
        newAsset.put("model", model);
        newAsset.put("processor", processor);
        newAsset.put("ram", ram);
        newAsset.put("hdd", hdd);
        newAsset.put("graphics", graphics);
        newAsset.put("os", os);
        newAsset.put("status", "Not Allocated");
        newAsset.put("empId", "");
        assetArray.add(newAsset);

        try (FileWriter fWriter = new FileWriter(filePath+"/Asset.json")) {
            fWriter.write(assetArray.toJSONString());
            fWriter.flush();
        } catch (Exception e) {
            System.out.println("Error in writing the file: " + e.getMessage());
        }

        response.setContentType("application/json");
        response.getWriter().write("{\"status\":\"success\"}");
    }

}
