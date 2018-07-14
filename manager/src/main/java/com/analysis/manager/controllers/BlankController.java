package com.analysis.manager.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class BlankController {

    @RequestMapping("blank")
    public String index(Model m) {
        return "blank";
    }
}
