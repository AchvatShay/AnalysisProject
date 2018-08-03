package com.analysis.manager.controllers;

import com.analysis.manager.modle.Analysis;
import com.analysis.manager.modle.AnalysisDao;
import com.analysis.manager.modle.BDA;
import com.analysis.manager.modle.TPA;
import com.mathworks.toolbox.javabuilder.MWClassID;
import com.mathworks.toolbox.javabuilder.MWNumericArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import runAnalysis.Class1;

import java.io.File;
import java.util.ArrayList;

@Controller
public class AnalysisController {
    @Autowired
    private AnalysisDao analysisDao;

    @RequestMapping(value = "analysis/{id}")
    public String view(@PathVariable long id, Model m)
    {
        Analysis analysis = analysisDao.getById(id);

        File[] results = analysis.getAllTifResults();
        m.addAttribute("analysis", analysis);
        m.addAttribute("tif", results);

        Class1 class1 = null;
        try {
            class1 = new Class1();

            MWNumericArray  n2 = new MWNumericArray(5, MWClassID.DOUBLE);
            MWNumericArray n1 = new MWNumericArray(String.valueOf("src\\main\\webapp\\resources\\analysis_results_folder\\testshaymatlab"), MWClassID.CHAR);

            Object[] resultsrt = class1.runAnalysis(1, n2);

            int n = 0;

        } catch (Exception e) {
            e.printStackTrace();
        }finally {
            class1.dispose();

        }



//         //Test
//
////        Class1 class1 = null;
//        try {
////            class1 = new Class1();
//
//            MWNumericArray n1 = new MWNumericArray(String.valueOf("src\\main\\webapp\\resources\\analysis_results_folder\\testshaymatlab"), MWClassID.CHAR);
//
//            MWNumericArray  n2 = new MWNumericArray("blab", MWClassID.CHAR);
//
//            MWNumericArray  n3 = new MWNumericArray(new ArrayList<BDA>(), MWClassID.STRUCT);
//
//            MWNumericArray  n4 = new MWNumericArray(new ArrayList<TPA>(), MWClassID.OBJECT);
//
////            class1.runAnalysis(1, n1, n2, n3, n4);
//
////        } catch (MWException e) {
////            e.printStackTrace();
//        }finally {
//           // class1.dispose();
//
//        }


        return "analysis";
    }
}
