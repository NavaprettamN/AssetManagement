package com;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.util.Config;
@WebServlet(name = "ListAssetServlet", urlPatterns = {"/admin-profile/ListAssetServlet", "/profile/ListAssetServlet"})
public class ListAssetServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        JSONParser parser = new JSONParser();
        JSONArray assetArray = new JSONArray();
        String filePath = Config.DATA_FOLDER_PATH;
        try (FileReader fReader = new FileReader(filePath+"/Asset.json")) {
            assetArray = (JSONArray) parser.parse(fReader);
        } catch (Exception e) {
            System.out.println("Error in reading: " + e.getMessage());
        }

        response.setContentType("application/json");
        response.getWriter().write(assetArray.toJSONString());
    }
}
