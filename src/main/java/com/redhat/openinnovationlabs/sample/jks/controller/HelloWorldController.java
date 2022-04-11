package com.redhat.openinnovationlabs.sample.jks.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

/**
 * @author Muhammad Edwin < edwin at redhat dot com >
 * 11 Apr 2022 19:20
 */
@RestController
public class HelloWorldController {
    @GetMapping("/")
    public Map index() {
        return new HashMap() {{
            put("hello", "world");
        }};
    }
}
