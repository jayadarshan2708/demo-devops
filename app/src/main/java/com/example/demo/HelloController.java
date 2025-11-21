package com.example.demo;

import org.spring.framework.web.bind.annotation.GetMapping;
import org.spring.framework.web.bind.annotation.RestController;

@RestControlelr
public class HelloController
{
	@GetMapping("/")
	public String hello()
	{
		return "Hello from Devops Project";
	}
}
