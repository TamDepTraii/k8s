package com.example.k8s.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import java.net.InetAddress;

@RestController
public class TestController {

    @GetMapping("/helloWorld")
    public String helloWorld() {
        try {
            String hostname = InetAddress.getLocalHost().getHostName();
            return "Hello World!! from " + hostname;
        } catch (Exception e) {
            return "Hello World!!";
        }
    }

    @GetMapping("/name")
    public String name() {
        try {
            String hostname = InetAddress.getLocalHost().getHostName();
            return "World from " + hostname;
        } catch (Exception e) {
            return "World";
        }
    }

    @GetMapping("/api/test")
    public String test() {
        // Simulate CPU load
        int result = 0;
        for(int i = 0; i < 1000000; i++) {
            result += Math.sqrt(i);
        }
        return "Test completed with result: " + result;
    }
}
