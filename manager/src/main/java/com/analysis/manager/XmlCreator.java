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
import java.util.List;

public class XmlCreator {

    @Autowired
    private ExperimentTypeDao experimentTypeDao;

    @Autowired
    private ExperimentPelletPertubationDao experimentPelletPertubationDao;

    @Autowired
    private ExperimentInjectionsDao experimentInjectionsDao;

    @Autowired
    private Environment environment;

    public boolean createXml(Analysis analysis, double font_size) throws Exception {
        String dropboxPathLocal = environment.getProperty("dropbox.local.location");
        boolean results = true;

        for (AnalysisType type : analysis.getAnalysisType())
        {
            String path = dropboxPathLocal + File.separator + analysis.getProject().getName() + File.separator + analysis.getName() +
                    File.separator + type.getName();
            File type_folder = new File(path);
            if (!type_folder.exists()) {
                if (!type_folder.mkdirs()) {
                    results = false;
                    break;
                }
            }

            File xml = new File(type_folder.getAbsolutePath() + File.separator + "XmlAnalysis.xml");
            if (!xml.exists())
            {
                results = createXmlDoc(analysis.getExperiment(), type_folder, font_size);

                if (!results)
                {
                    break;
                }
            }
        }

        return results;
    }

    private boolean createXmlDoc(Experiment experiment, File type_folder, double font_size){


        try {

            List<ExperimentInjections> experimentInjections = experimentInjectionsDao.getAll();
            List<ExperimentPelletPertubation> experimentPelletPertubations = experimentPelletPertubationDao.getAll();
            List<ExperimentType> experimentTypes = experimentTypeDao.getAll();

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
            for (ExperimentType experimentType : experimentTypes) {
                Element obj = doc.createElement(experimentType.getName());
                String value = experiment.getExperimentCondition().getExperimentType().getId() == experimentType.getId() ? "True" : "False";
                obj.setAttribute("is_active", value);
                typeE.appendChild(obj);
            }
            experimentCondition.appendChild(typeE);

            Element injectionE = doc.createElement("Injection");
            for (ExperimentInjections experimentIn : experimentInjections) {
                Element obj = doc.createElement(experimentIn.getName());
                String value = experiment.getExperimentCondition().getExperimentInjections().getId() == experimentIn.getId() ? "True" : "False";
                obj.setAttribute("is_active", value);
                injectionE.appendChild(obj);
            }
            experimentCondition.appendChild(injectionE);

            Element pelletPertubationE = doc.createElement("PelletPertubation");
            for (ExperimentPelletPertubation experimentP : experimentPelletPertubations) {
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

            for (Neuron name : experiment.getNeurons_names()) {
                Element neuron = doc.createElement("Neuron");
                Element nameE = doc.createElement("name");
                nameE.appendChild(doc.createTextNode(name.getName()));
                neuron.appendChild(nameE);
                NeuronesToPut.appendChild(neuron);
            }

            experimentElement.appendChild(NeuronesToPut);


            Element visualization = doc.createElement("visualization");

            Element legend = doc.createElement("legend");
            legend.setAttribute("Location", "Best");
            visualization.appendChild(legend);

            Element labelsFontSize = doc.createElement("labelsFontSize");
            labelsFontSize.appendChild(doc.createTextNode(String.valueOf(font_size)));
            visualization.appendChild(labelsFontSize);

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
