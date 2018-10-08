package com.analysis.manager;

import com.analysis.manager.Dao.ExperimentEventsDao;
import com.analysis.manager.Dao.ExperimentInjectionsDao;
import com.analysis.manager.Dao.ExperimentPelletPertubationDao;
import com.analysis.manager.Dao.ExperimentTypeDao;
import com.analysis.manager.modle.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import java.io.File;
import java.util.LinkedList;
import java.util.List;

public class XmlCreator {
    private static final Logger logger = LoggerFactory.getLogger(XmlCreator.class);


    @Autowired
    private ExperimentTypeDao experimentTypeDao;

    @Autowired
    private ExperimentPelletPertubationDao experimentPelletPertubationDao;

    @Autowired
    private ExperimentInjectionsDao experimentInjectionsDao;

    @Autowired
    private ExperimentEventsDao experimentEventsDao;

    @Value("${analysis.results.location}")
    private String pathAnalysis;

    public boolean createXml(Analysis analysis, double font_size, List<String> neurons_forAnalysis, List<String> neurons_toPlot, LinkedList<ExperimentEvents> experimentEvents, double startTime2plot, double time2startCountGrabs, double time2endCountGrabs, double startBehaveTime4trajectory, double endBehaveTime4trajectory, double foldsNum, String linearSVN, double slidingWinLen, double slidingWinHop, double conf_percent4acc, double time4confplot, double time4confplotNext, String includeO, String determineSucFailBy, List<String> labels, double bestpcatrajectories2plot) throws Exception {
        boolean results = true;

        Project project = analysis.getExperiment().getProject();
        for (AnalysisType type : analysis.getAnalysisType())
        {
            String path = pathAnalysis + File.separator + project.getUser().getName() + "_" + project.getUser().getLastName() + File.separator + project.getName() + File.separator + analysis.getName();

            path = path.toLowerCase();

            File xml_folder = new File(path);
            if (!xml_folder.exists()) {
                if (!xml_folder.mkdirs()) {
                    results = false;
                    logger.error("Failed to create xml folder for analysis " + analysis.getName());
                    break;
                }
            }

            File type_folder = new File(path + File.separator + type.getName().toLowerCase());
            if (!type_folder.exists()) {
                if (!type_folder.mkdirs()) {
                    results = false;
                    logger.error("Failed to create folder for analysis type " + analysis.getName() + "/" + type.getName());
                    break;

                }
            }

            File xml = new File(xml_folder.getAbsolutePath() + File.separator + "XmlAnalysis.xml");
            if (!xml.exists())
            {
                results = createXmlDoc(analysis.getExperiment(), xml_folder, neurons_forAnalysis, neurons_toPlot, experimentEvents, startTime2plot, time2endCountGrabs, time2startCountGrabs, startBehaveTime4trajectory, endBehaveTime4trajectory, foldsNum, font_size, linearSVN, slidingWinLen, slidingWinHop, conf_percent4acc, time4confplot, time4confplotNext, includeO, determineSucFailBy, labels, bestpcatrajectories2plot);

                if (!results)
                {
                    logger.error("Failed to create xml file for analysis " + analysis.getName());
                    break;
                }
            }
        }

        return results;
    }

    private boolean createXmlDoc(Experiment experiment, File type_folder, List<String> neurons_forAnalysis, List<String> neurons_toPlot, LinkedList<ExperimentEvents> experimentEvents, double startTime2plot, double time2endCountGrabs, double time2startCountGrabs, double startBehaveTime4trajectory, double endBehaveTime4trajectory, double foldsNum, double font_size, String linearSVN, double slidingWinLen, double slidingWinHop, double conf_percent4acc, double time4confplot, double time4confplotNext, String includeO, String determineSucFailBy, List<String> labels, double bestpcatrajectories2plot){


        try {
            DocumentBuilderFactory dbFactory =
                    DocumentBuilderFactory.newInstance();
            DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
            Document doc = dBuilder.newDocument();

            // root element
            Element rootElement = doc.createElement("GeneralProperty");
            doc.appendChild(rootElement);

            Element experimentElement = doc.createElement("Experiment");
            rootElement.appendChild(experimentElement);
            Element experimentName = doc.createElement("name");
            experimentName.appendChild(doc.createTextNode(experiment.getName()));

            experimentElement.appendChild(experimentName);
            Element experimentCondition = doc.createElement("Condition");


            Element typeE = doc.createElement("Type");
            for (ExperimentType experimentType : experimentTypeDao.findAll()) {
                Element obj = doc.createElement(experimentType.getName());
                String value = experiment.getExperimentCondition().getExperimentType().getId() == experimentType.getId() ? "True" : "False";
                obj.setAttribute("is_active", value);
                typeE.appendChild(obj);
            }
            experimentCondition.appendChild(typeE);

            Element injectionE = doc.createElement("Injection");
            for (ExperimentInjections experimentIn : experimentInjectionsDao.findAll()) {
                Element obj = doc.createElement(experimentIn.getName());
                String value = experiment.getExperimentCondition().getExperimentInjections().getId() == experimentIn.getId() ? "True" : "False";
                obj.setAttribute("is_active", value);
                injectionE.appendChild(obj);
            }
            experimentCondition.appendChild(injectionE);

            Element pelletPertubationE = doc.createElement("PelletPertubation");
            for (ExperimentPelletPertubation experimentP : experimentPelletPertubationDao.findAll()) {
                Element obj = doc.createElement(experimentP.getName());
                String value = experiment.getExperimentCondition().getExperimentPelletPertubation().getId() == experimentP.getId() ? "True" : "False";
                obj.setAttribute("is_active", value);
                pelletPertubationE.appendChild(obj);
            }
            experimentCondition.appendChild(pelletPertubationE);

            Element depth = doc.createElement("Depth");
            depth.appendChild(doc.createTextNode(String.valueOf(experiment.getExperimentCondition().getDepth())));
            experimentCondition.appendChild(depth);

            Element behavioral_delay = doc.createElement("BehavioralDelay");
            behavioral_delay.appendChild(doc.createTextNode(String.valueOf(experiment.getExperimentCondition().getBehavioral_delay())));
            experimentCondition.appendChild(behavioral_delay);

            Element tone_time = doc.createElement("ToneTime");
            tone_time.appendChild(doc.createTextNode(String.valueOf(experiment.getExperimentCondition().getTone_time())));
            experimentCondition.appendChild(tone_time);

            Element imagingSamplingRate = doc.createElement("ImagingSamplingRate");
            imagingSamplingRate.appendChild(doc.createTextNode(String.valueOf(experiment.getExperimentCondition().getImaging_sampling_rate())));
            experimentCondition.appendChild(imagingSamplingRate);

            Element behavioral_sampling_rate = doc.createElement("BehavioralSamplingRate");
            behavioral_sampling_rate.appendChild(doc.createTextNode(String.valueOf(experiment.getExperimentCondition().getBehavioral_sampling_rate())));
            experimentCondition.appendChild(behavioral_sampling_rate);


            Element duration = doc.createElement("Duration");
            duration.appendChild(doc.createTextNode(String.valueOf(experiment.getExperimentCondition().getDuration())));
            experimentCondition.appendChild(duration);

            experimentElement.appendChild(experimentCondition);

            Element NeuronesToPut = doc.createElement("NeuronesToPut");

            for (String name : neurons_forAnalysis) {
                Element neuron = doc.createElement("Neuron");
                Element nameE = doc.createElement("name");
                nameE.appendChild(doc.createTextNode(name));
                neuron.appendChild(nameE);
                NeuronesToPut.appendChild(neuron);
            }

            experimentElement.appendChild(NeuronesToPut);

            Element analysisParams = doc.createElement("analysisParams");


            Element indicativeNrns_maxbinnum = doc.createElement("indicativeNrns_maxbinnum");
            indicativeNrns_maxbinnum.appendChild(doc.createTextNode("2"));
            analysisParams.appendChild(indicativeNrns_maxbinnum);

            Element indicativeNrnsMeanStartTime = doc.createElement("indicativeNrnsMeanStartTime");
            indicativeNrnsMeanStartTime.appendChild(doc.createTextNode("0"));
            analysisParams.appendChild(indicativeNrnsMeanStartTime);

            Element indicativeNrnsMeanEndTime = doc.createElement("indicativeNrnsMeanEndTime");
            indicativeNrnsMeanEndTime.appendChild(doc.createTextNode("8"));
            analysisParams.appendChild(indicativeNrnsMeanEndTime);

            Element time2startCountGrabsE = doc.createElement("time2startCountGrabs");
            time2startCountGrabsE.appendChild(doc.createTextNode(String.valueOf(time2startCountGrabs)));
            analysisParams.appendChild(time2startCountGrabsE);

            Element time2endCountGrabsE = doc.createElement("time2endCountGrabs");
            time2endCountGrabsE.appendChild(doc.createTextNode(String.valueOf(time2endCountGrabs)));
            analysisParams.appendChild(time2endCountGrabsE);

            Element slidingWinLenE = doc.createElement("slidingWinLen");
            slidingWinLenE.appendChild(doc.createTextNode(String.valueOf(slidingWinLen)));
            analysisParams.appendChild(slidingWinLenE);

            Element slidingWinHopE = doc.createElement("slidingWinHop");
            slidingWinHopE.appendChild(doc.createTextNode(String.valueOf(slidingWinHop)));
            analysisParams.appendChild(slidingWinHopE);

            Element linearSVNE = doc.createElement("linearSVN");
            linearSVNE.setAttribute("is_active", linearSVN);
            analysisParams.appendChild(linearSVNE);

            Element includeOmissions = doc.createElement("includeOmissions");
            includeOmissions.setAttribute("is_active", includeO);
            analysisParams.appendChild(includeOmissions);


            Element DetermineSucFailBy = doc.createElement("DetermineSucFailBy");
            Element bySuc = doc.createElement("BySuc");

            if (determineSucFailBy.equals("BySuc")) {
                bySuc.setAttribute("is_active", "True");
            } else {
                bySuc.setAttribute("is_active", "False");
            }
            DetermineSucFailBy.appendChild(bySuc);

            Element ByFail = doc.createElement("ByFail");

            if (determineSucFailBy.equals("ByFail")) {
                ByFail.setAttribute("is_active", "True");
            } else {
                ByFail.setAttribute("is_active", "False");
            }
            DetermineSucFailBy.appendChild(ByFail);

            Element Both = doc.createElement("Both");

            if (determineSucFailBy.equals("Both")) {
                Both.setAttribute("is_active", "True");
            } else {
                Both.setAttribute("is_active", "False");
            }
            DetermineSucFailBy.appendChild(Both);


            analysisParams.appendChild(DetermineSucFailBy);

            Element successLabel = doc.createElement("successLabel");
            successLabel.appendChild(doc.createTextNode(labels.get(0)));
            analysisParams.appendChild(successLabel);

            Element failureLabel = doc.createElement("failureLabel");
            failureLabel.appendChild(doc.createTextNode(labels.get(1)));
            analysisParams.appendChild(failureLabel);

            Element prevcurrlabels2cluster = doc.createElement("prevcurrlabels2cluster");

            Element lb1 = doc.createElement("cluster");
            Element nameLabel = doc.createElement("name");
            nameLabel.appendChild(doc.createTextNode(labels.get(0)));
            Element color1 = doc.createElement("color");
            color1.appendChild(doc.createTextNode("blue"));
            Element color2 = doc.createElement("color");
            color2.appendChild(doc.createTextNode("cyan"));
            lb1.appendChild(nameLabel);
            lb1.appendChild(color1);
            lb1.appendChild(color2);

            Element lb2 = doc.createElement("cluster");
            Element nameLabe2 = doc.createElement("name");
            nameLabe2.appendChild(doc.createTextNode(labels.get(1)));
            Element color3 = doc.createElement("color");
            color3.appendChild(doc.createTextNode("purpule"));
            Element color4 = doc.createElement("color");
            color4.appendChild(doc.createTextNode("red"));
            lb2.appendChild(nameLabe2);
            lb2.appendChild(color3);
            lb2.appendChild(color4);


            prevcurrlabels2cluster.appendChild(lb1);
            prevcurrlabels2cluster.appendChild(lb2);

            analysisParams.appendChild(prevcurrlabels2cluster);



            Element labels2cluster = doc.createElement("labels2cluster");

            Element lb3 = doc.createElement("cluster");
            Element nameLabe3 = doc.createElement("name");
            nameLabe3.appendChild(doc.createTextNode(labels.get(0)));
            Element color5 = doc.createElement("color");
            color5.appendChild(doc.createTextNode("blue"));
            lb3.appendChild(nameLabe3);
            lb3.appendChild(color5);

            Element lb4 = doc.createElement("cluster");
            Element nameLabe4 = doc.createElement("name");
            nameLabe4.appendChild(doc.createTextNode(labels.get(1)));
            Element color6 = doc.createElement("color");
            color6.appendChild(doc.createTextNode("red"));
            lb4.appendChild(nameLabe4);
            lb4.appendChild(color6);


            labels2cluster.appendChild(lb3);
            labels2cluster.appendChild(lb4);

            analysisParams.appendChild(labels2cluster);

            Element startBehaveTime4trajectoryE = doc.createElement("startBehaveTime4trajectory");
            startBehaveTime4trajectoryE.appendChild(doc.createTextNode(String.valueOf(startBehaveTime4trajectory)));
            analysisParams.appendChild(startBehaveTime4trajectoryE);

            Element endBehaveTime4trajectoryE = doc.createElement("endBehaveTime4trajectory");
            endBehaveTime4trajectoryE.appendChild(doc.createTextNode(String.valueOf(endBehaveTime4trajectory)));
            analysisParams.appendChild(endBehaveTime4trajectoryE);

            Element foldsNumE = doc.createElement("foldsNum");
            foldsNumE.appendChild(doc.createTextNode(String.valueOf(foldsNum)));
            analysisParams.appendChild(foldsNumE);

            Element NeuronesToPlot = doc.createElement("NeuronesToPlot");

            for (String name : neurons_toPlot) {
                Element neuron = doc.createElement("Neuron");
                Element nameE = doc.createElement("name");
                nameE.appendChild(doc.createTextNode(name));
                neuron.appendChild(nameE);
                NeuronesToPlot.appendChild(neuron);
            }

            analysisParams.appendChild(NeuronesToPlot);

            experimentElement.appendChild(analysisParams);

            Element visualization = doc.createElement("visualization");

            Element legend = doc.createElement("legend");
            legend.setAttribute("Location", "Best");
            visualization.appendChild(legend);

            Element viewP1 = doc.createElement("viewparams1");
            viewP1.appendChild(doc.createTextNode("0"));
            visualization.appendChild(viewP1);


            Element viewP2 = doc.createElement("viewparams2");
            viewP2.appendChild(doc.createTextNode("0"));
            visualization.appendChild(viewP2);

            Element labelsFontSize = doc.createElement("labelsFontSize");
            labelsFontSize.appendChild(doc.createTextNode(String.valueOf(font_size)));
            visualization.appendChild(labelsFontSize);

            Element visualization_time4confplot = doc.createElement("visualization_time4confplot");
            Element time_stamp = doc.createElement("time_stamp");
            time_stamp.appendChild(doc.createTextNode(String.valueOf(time4confplot)));
            visualization_time4confplot.appendChild(time_stamp);
            visualization.appendChild(visualization_time4confplot);

            Element visualization_time4confplotNext = doc.createElement("visualization_time4confplotNext");
            Element time_stamp2 = doc.createElement("time_stamp");
            time_stamp2.appendChild(doc.createTextNode(String.valueOf(time4confplotNext)));
            visualization_time4confplotNext.appendChild(time_stamp2);
            visualization.appendChild(visualization_time4confplotNext);

            Element visualization_conf_percent4acc = doc.createElement("visualization_conf_percent4acc");
            visualization_conf_percent4acc.appendChild(doc.createTextNode(String.valueOf(conf_percent4acc)));
            visualization.appendChild(visualization_conf_percent4acc);

            Element startTime2plotE = doc.createElement("startTime2plot");
            startTime2plotE.appendChild(doc.createTextNode(String.valueOf(startTime2plot)));
            visualization.appendChild(startTime2plotE);


            Element bestpcatrajectories2plotE = doc.createElement("bestpcatrajectories2plot");
            bestpcatrajectories2plotE.appendChild(doc.createTextNode(String.valueOf(bestpcatrajectories2plot)));
            visualization.appendChild(bestpcatrajectories2plotE);

            Element eventsElement = doc.createElement("Events2plot");

            for (ExperimentEvents event : experimentEventsDao.findAll()) {
                Element obj = doc.createElement(event.getName());

                String value = "False";
                for (ExperimentEvents eventExist : experimentEvents) {
                    if (eventExist.getId() == event.getId())
                    {
                        value = "True";
                        break;
                    }
                }

                obj.setAttribute("is_active", value);
                eventsElement.appendChild(obj);
            }

            visualization.appendChild(eventsElement);



            experimentElement.appendChild(visualization);

            // write the content into xml file
            TransformerFactory transformerFactory = TransformerFactory.newInstance();
            Transformer transformer = transformerFactory.newTransformer();
            DOMSource source = new DOMSource(doc);
            StreamResult result = new StreamResult(new File(type_folder.getAbsolutePath() + File.separator + "XmlAnalysis.xml"));
            transformer.transform(source, result);
            return true;
        }
        catch (Exception e)
        {
            logger.error(e.getMessage());
            return false;
        }
    }
}
