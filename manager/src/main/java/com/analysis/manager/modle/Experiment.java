package com.analysis.manager.modle;


import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.io.File;
import java.io.FilenameFilter;
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

    public Experiment(String description, String name, ExperimentCondition experimentCondition, List<Trial> trials, Animal animal, Project project)
    {
        this.description = description;
        this.project = project;
        this.name = name;
        this.experimentCondition = experimentCondition;
        this.trials = trials;
        this.animal = animal;
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

    public List getTrials() {
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

    public List<Trial> createTrailsListFromFolder(String fileslocation) {
        File file = new File(fileslocation);
        LinkedList<Trial> trials = new LinkedList<Trial>();

        if (file.exists() & file.isDirectory()) {
            File[] filesBDA = file.listFiles((dir, name) -> name.contains("BDA"));

            File[] filesTPA = file.listFiles((dir, name) -> name.contains("TPA"));

            for (File f_BDA : filesBDA != null ? filesBDA : new File[0]) {
                for (File f_TPA : filesTPA != null ? filesTPA : new File[0]) {
                    if (f_BDA.getName().replace("BDA", "TPA").equals(f_TPA.getName())) {
                        trials.add(new Trial(new TPA(f_TPA.getPath()), null, new BDA(f_BDA.getPath()), null, this));
                    }
                }
            }
        }

        return trials;
    }
}
