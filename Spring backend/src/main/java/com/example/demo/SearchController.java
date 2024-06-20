package com.example.demo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class SearchController {

    @Autowired
    private GoogleSearchService searchService;

    @GetMapping("/search")
    public List<String> search(@RequestParam String query) {
        return searchService.search(query);
    }
}
