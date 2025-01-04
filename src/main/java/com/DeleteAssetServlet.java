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

@WebServlet(name = "DeleteAssetServlet", urlPatterns = "/admin-profile/DeleteAssetServlet")
public class DeleteAssetServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String assetNo = request.getParameter("assetNo");

        JSONParser parser = new JSONParser();
        JSONArray assetArray = new JSONArray();

        String filePath = Config.DATA_FOLDER_PATH;
        try (FileReader fReader = new FileReader(filePath+"/Asset.json")) {
            assetArray = (JSONArray) parser.parse(fReader);
        } catch (Exception e) {
            System.out.println("Error in reading: " + e.getMessage());
        }

        JSONArray updatedAssetArray = new JSONArray();
        boolean assetFound = false;

        for (Object obj : assetArray) {
            JSONObject asset = (JSONObject) obj;
            if (!asset.get("assetNo").equals(assetNo)) {
                updatedAssetArray.add(asset);
            } else {
                assetFound = true;
            }
        }

        if (assetFound) {
            try (FileWriter fWriter = new FileWriter(filePath+"/Asset.json")) {
                fWriter.write(updatedAssetArray.toJSONString());
                fWriter.flush();
            } catch (Exception e) {
                System.out.println("Error in writing the file: " + e.getMessage());
            }
            response.setContentType("application/json");
            response.getWriter().write("{\"status\":\"success\"}");
        } else {
            response.setContentType("application/json");
            response.getWriter().write("{\"status\":\"error\", \"message\":\"Asset not found\"}");
        }
    }
}
