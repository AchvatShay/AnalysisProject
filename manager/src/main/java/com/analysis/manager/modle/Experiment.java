package com.analysis.manager.modle;

import javafx.collections.transformation.SortedList;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.io.File;
import java.util.LinkedList;
import java.util.List;

@Entity
@Table(name = "experiment")
public class Experiment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @NotNull
    private String name;

    @NotNull
    private String description;

    @Lob
    private String neurons_name;

    @Lob
    private String labels_name;

    @OneToOne
    private ExperimentCondition experimentCondition;

    @OneToMany(targetEntity = Trial.class)
    private List trials;

    @ManyToOne
    private Animal animal;

    @ManyToOne
    private Project project;

    public Experiment(){
    }

    public Experiment(String description, String name, ExperimentCondition experimentCondition, List<Trial> trials, Animal animal, Project project, String neurons_name, String labels_name)
    {
        this.description = description;
        this.labels_name = labels_name;
        this.project = project;
        this.name = name;
        this.experimentCondition = experimentCondition;
        this.trials = trials;
        this.animal = animal;
        this.neurons_name = neurons_name;
    }

    public String getLabelsName() {
        return labels_name;
    }

    public void setLabelsName(String labels_name) {
        this.labels_name = labels_name;
    }

    public String getNeuronsName() {
        return neurons_name;
    }

    public void setNeuronsName(String neurons_name) {
        this.neurons_name = neurons_name;
    }

    public Project getProject() {
        return project;
    }

    public void setProject(Project project) {
        this.project = project;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public ExperimentCondition getExperimentCondition() {
        return experimentCondition;
    }

    public void setExperimentCondition(ExperimentCondition experimentCondition) {
        this.experimentCondition = experimentCondition;
    }

    public List<Trial> getTrials() {
        return trials;
    }

    public void setTrials(List trials) {
        this.trials = trials;
    }

    public Animal getAnimal() {
        return animal;
    }

    public void setAnimal(Animal animal) {
        this.animal = animal;
    }

    public List<Trial> createTrailsListFromFolder(String filesLocation) {
        File file = new File(filesLocation);
        LinkedList<Trial> trials = new LinkedList<>();

        if (file.exists() & file.isDirectory()) {
            File[] filesBDA = file.listFiles((dir, name) -> (name.contains("BDA") && name.endsWith(".mat")));

            File[] filesTPA = file.listFiles((dir, name) -> (name.contains("TPA") && name.endsWith(".mat")));

            for (File f_BDA : filesBDA != null ? filesBDA : new File[0]) {
                for (File f_TPA : filesTPA != null ? filesTPA : new File[0]) {
                    if (f_BDA.getName().replace("BDA", "TPA").equals(f_TPA.getName())) {
                        trials.add(new Trial(f_TPA.getName().replace("TPA", ""), f_TPA.getPath(), "", f_BDA.getPath(), "", this));
                    }
                }
            }
        }

        return trials;
    }

    public void AddTrials(List<Trial> trailsListFromFolder) {
        if (this.trials == null)
        {
            setTrials(trailsListFromFolder);
        } else {
            this.trials.addAll(trailsListFromFolder);
        }
    }

    public void AddTrial(Trial trial) {
        if (this.trials == null)
        {
            this.trials = new LinkedList();
        }

        this.trials.add(trial);
    }

    public List<Long> getTrialsID() {
        LinkedList<Long> trialsID = new LinkedList<>();

        if (getTrials() != null)
        {
            for(Trial trial : getTrials())
            {
                trialsID.add(trial.getId());
            }
        }

        return trialsID;
    }

    @Override
    public boolean equals(Object o) {
        if (o == null) {
            return false;
        }

        /* Check if o is an instance of Complex or not
          "null instanceof [type]" also returns false */
        if (!(o instanceof Experiment)) {
            return false;
        }

        return ((Experiment)o).getId() == this.getId();
    }

    public void deleteTrial(Trial trial) {
        if (this.getTrials() != null) {
            this.trials.remove(trial);
        }
    }
}
