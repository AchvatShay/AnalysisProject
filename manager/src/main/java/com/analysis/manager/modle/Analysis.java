package com.analysis.manager.modle;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.io.File;
import java.io.FilenameFilter;

@Entity
@Table(name = "analysis")
public class Analysis {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @NotNull
    private String name;

    @NotNull
    private String description;

    @ManyToOne
    private Project project;

    @ManyToOne
    private AnalysisType analysisType;

    public Analysis() {
    }

    public Analysis(@NotNull String name, @NotNull String description, Project project, AnalysisType analysisType) {
        this.name = name;
        this.description = description;
        this.project = project;
        this.analysisType = analysisType;
    }

    public Project getProject() {
        return project;
    }

    public void setProject(Project project) {
        this.project = project;
    }

    public AnalysisType getAnalysisType() {
        return analysisType;
    }

    public void setAnalysisType(AnalysisType analysisType) {
        this.analysisType = analysisType;
    }

    public long getId() {
        return id;
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

    public File[] getAllTifResults()
    {

        File file = new File( "src\\main\\webapp\\resources\\analysis_results_folder" + File.separator + project.getName() + "_" + getName() + "_" + getAnalysisType().getName());
        File[] tifFiles = file.listFiles(new FilenameFilter() {

            @Override
            public boolean accept(File dir, String name) {
                if(name.toLowerCase().endsWith(".tif")){
                    return true;
                } else {
                    return false;
                }
            }
        });

        return tifFiles;
    }
}
