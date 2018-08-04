package com.analysis.manager.controllers;

import com.analysis.manager.modle.Analysis;
import com.analysis.manager.modle.AnalysisDao;
//import com.analysis.manager.modle.BDA;
//import com.analysis.manager.modle.TPA;
//import com.mathworks.toolbox.javabuilder.MWClassID;
//import com.mathworks.toolbox.javabuilder.MWNumericArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
//import runAnalysis.Class1;
//
//import java.io.File;
//import java.util.ArrayList;
//import java.util.LinkedList;
import java.util.List;

@Controller
public class AnalysisController {
    @Autowired
    private AnalysisDao analysisDao;

    @Autowired
    private Environment environment;

    @RequestMapping(value = "analysis/{id}")
    public String view(@PathVariable long id, Model m)
    {
        Analysis analysis = analysisDao.getById(id);

        List<String> results = analysis.getAllTifResults(environment.getProperty("analysis.results.location"));
        m.addAttribute("analysis", analysis);
        m.addAttribute("tif", results);

        return "analysis";
    }

//    Class1 class1 = null;
//        try {
//        class1 = new Class1();
//
//        MWCharArray  n2 = new MWCharArray(String.valueOf("D:\\Shay\\work\\AnalysisProject\\MatlabAnalysis\\XmlPT3.xml"));
//
//        MWCharArray n1 = new MWCharArray(String.valueOf("src\\main\\webapp\\resources\\analysis_results_folder\\testshaymatlab"));
//        MWStructArray n3 = new MWStructArray(1, 3, new String[] {"BDA", "TPA"});
//
//        n3.set("BDA", new int[] {1, 1}, "C:\\Users\\shaya\\Dropbox\\PT3\\3_13_18\\3_13_18_1\\BDA_TSeries_03132018_0944_001_Cycle00001_Ch2_000001_ome.mat");
//        n3.set("BDA", new int[] {1, 2}, "C:\\Users\\shaya\\Dropbox\\PT3\\3_13_18\\3_13_18_1\\BDA_TSeries_03132018_0944_002_Cycle00001_Ch2_000001_ome.mat");
//        n3.set("BDA", new int[] {1, 3}, "C:\\Users\\shaya\\Dropbox\\PT3\\3_13_18\\3_13_18_1\\BDA_TSeries_03132018_0944_003_Cycle00001_Ch2_000001_ome.mat");
//
//
//        n3.set("TPA", new int[] {1, 1}, "C:\\Users\\shaya\\Dropbox\\PT3\\3_13_18\\3_13_18_1\\TPA_TSeries_03132018_0944_001_Cycle00001_Ch2_000001_ome.mat");
//        n3.set("TPA", new int[] {1, 2}, "C:\\Users\\shaya\\Dropbox\\PT3\\3_13_18\\3_13_18_1\\TPA_TSeries_03132018_0944_002_Cycle00001_Ch2_000001_ome.mat");
//        n3.set("TPA", new int[] {1, 3}, "C:\\Users\\shaya\\Dropbox\\PT3\\3_13_18\\3_13_18_1\\TPA_TSeries_03132018_0944_003_Cycle00001_Ch2_000001_ome.mat");
//
//        Object[] results = class1.runAnalysis(1, n1, n2, n3);
//
//        int n = 0;
//
//    } catch (Exception e) {
//        e.printStackTrace();
//    }finally {
//        class1.dispose();
//
//    }
}
