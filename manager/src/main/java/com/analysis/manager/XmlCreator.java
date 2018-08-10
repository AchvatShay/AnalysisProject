package com.analysis.manager;

import com.analysis.manager.modle.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import java.io.File;
import java.util.LinkedList;
import java.util.List;

public class XmlCreator {

    @Autowired
    private ExperimentTypeDao experimentTypeDao;

    @Autowired
    private ExperimentPelletPertubationDao experimentPelletPertubationDao;

    @Autowired
    private ExperimentInjectionsDao experimentInjectionsDao;

    @Autowired
    private ExperimentEventsDao experimentEventsDao;

    @Autowired
    private Environment environment;

    public boolean createXml(Analysis analysis, double font_size, List<String> neurons_forAnalysis, List<String> neurons_toPlot, LinkedList<ExperimentEvents> experimentEvents, double startTime2plot, double time2startCountGrabs, double time2endCountGrabs) throws Exception {
        String dropboxPathLocal = environment.getProperty("dropbox.local.location");
        boolean results = true;

        for (AnalysisType type : analysis.getAnalysisType())
        {
            String path = dropboxPathLocal + File.separator + analysis.getProject().getName() + File.separator + analysis.getName();

            File xml_folder = new File(path);
            if (!xml_folder.exists()) {
                if (!xml_folder.mkdirs()) {
                    results = false;
                    break;
                }
            }

            File type_folder = new File(path + File.separator + type.getName());
            if (!type_folder.exists()) {
                if (!type_folder.mkdirs()) {
                    results = false;
                    break;

                }
            }

            File xml = new File(xml_folder.getAbsolutePath() + File.separator + "XmlAnalysis.xml");
            if (!xml.exists())
            {
                results = createXmlDoc(analysis.getExperiment(), xml_folder, neurons_forAnalysis, neurons_toPlot, experimentEvents, startTime2plot, time2endCountGrabs, time2startCountGrabs, font_size);

                if (!results)
                {
                    break;
                }
            }
        }

        return results;
    }

    private boolean createXmlDoc(Experiment experiment, File type_folder, List<String> neurons_forAnalysis, List<String> neurons_toPlot, LinkedList<ExperimentEvents> experimentEvents, double startTime2plot, double time2endCountGrabs, double time2startCountGrabs, double font_size){


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
            for (ExperimentType experimentType : experimentTypeDao.getAll()) {
                Element obj = doc.createElement(experimentType.getName());
                String value = experiment.getExperimentCondition().getExperimentType().getId() == experimentType.getId() ? "True" : "False";
                obj.setAttribute("is_active", value);
                typeE.appendChild(obj);
            }
            experimentCondition.appendChild(typeE);

            Element injectionE = doc.createElement("Injection");
            for (ExperimentInjections experimentIn : experimentInjectionsDao.getAll()) {
                Element obj = doc.createElement(experimentIn.getName());
                String value = experiment.getExperimentCondition().getExperimentInjections().getId() == experimentIn.getId() ? "True" : "False";
                obj.setAttribute("is_active", value);
                injectionE.appendChild(obj);
            }
            experimentCondition.appendChild(injectionE);

            Element pelletPertubationE = doc.createElement("PelletPertubation");
            for (ExperimentPelletPertubation experimentP : experimentPelletPertubationDao.getAll()) {
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

            Element time2startCountGrabsE = doc.createElement("time2startCountGrabs");
            time2startCountGrabsE.appendChild(doc.createTextNode(String.valueOf(time2startCountGrabs)));
            analysisParams.appendChild(time2startCountGrabsE);


            Element time2endCountGrabsE = doc.createElement("time2endCountGrabs");
            time2endCountGrabsE.appendChild(doc.createTextNode(String.valueOf(time2endCountGrabs)));
            analysisParams.appendChild(time2endCountGrabsE);

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

            Element labelsFontSize = doc.createElement("labelsFontSize");
            labelsFontSize.appendChild(doc.createTextNode(String.valueOf(font_size)));
            visualization.appendChild(labelsFontSize);

            Element startTime2plotE = doc.createElement("startTime2plot");
            startTime2plotE.appendChild(doc.createTextNode(String.valueOf(startTime2plot)));
            visualization.appendChild(startTime2plotE);

            Element eventsElement = doc.createElement("Events2plot");

            for (ExperimentEvents event : experimentEventsDao.getAll()) {
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
            return false;
        }
    }

}
