package com.example.k8s;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import java.net.InetAddress;

@SpringBootApplication
public class K8sApplication {

	public static void main(String[] args) {
		SpringApplication.run(K8sApplication.class, args);
	}

}

@RestController
class HelloController {

	@Autowired
	private Environment env;

	@GetMapping("/")
	public String home() {
		return "Welcome to Spring Boot on Kubernetes! 🚀";
	}

	@GetMapping("/hello")
	public String hello() {
		return "Hello from Kubernetes!";
	}

	@GetMapping("/info")
	public String info() throws Exception {
		String hostname = InetAddress.getLocalHost().getHostName();
		String port = env.getProperty("server.port", "8080");
		return String.format("Pod: %s, Port: %s", hostname, port);
	}

	@GetMapping("/health")
	public String health() {
		return "{\"status\": \"UP\"}";
	}
}
