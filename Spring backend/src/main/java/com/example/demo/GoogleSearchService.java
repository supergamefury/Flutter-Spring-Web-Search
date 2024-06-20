package com.example.demo;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.ArrayList;
import java.util.List;

@Service
public class GoogleSearchService {

    private static final String API_KEY = "Your search engine api";
    private static final String CUSTOM_SEARCH_ENGINE_KEY = "custome search engine key ";
    private static final String API_URL = "https://www.googleapis.com/customsearch/v1";

    public List<String> search(String query) {
        String apiUrl = API_URL + "?key=" + API_KEY + "&cx=" + CUSTOM_SEARCH_ENGINE_KEY + "&q=" + query + "&num=10";

        RestTemplate restTemplate = new RestTemplate();
        String jsonResponse = restTemplate.getForObject(apiUrl, String.class);

        List<String> links = new ArrayList<>();

        if (jsonResponse != null) {
            JsonObject jsonObject = JsonParser.parseString(jsonResponse).getAsJsonObject();
            JsonArray items = jsonObject.getAsJsonArray("items");

            for (JsonElement item : items) {
                JsonObject itemObject = item.getAsJsonObject();
                String link = itemObject.get("link").getAsString();
                links.add(link);
            }
        }

        return links;
    }
}
