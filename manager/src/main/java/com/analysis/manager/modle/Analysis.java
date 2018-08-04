package com.analysis.manager.modle;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.io.File;
import java.io.FilenameFilter;
import java.util.LinkedList;
import java.util.List;

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

    public List<String> getAllTifResults(String resultsLocation)
    {

        File file = new File( resultsLocation + File.separator + project.getName() + File.separator + getName() + File.separator + getAnalysisType().getName());
        File[] tifFiles = file.listFiles((dir, name) -> name.toLowerCase().endsWith(".tif"));
        LinkedList<String> results = new LinkedList<>();

        for (File f: tifFiles != null ? tifFiles : new File[0]) {
            results.add(f.getPath().replace(resultsLocation, ""));
        }

        return results;
    }
}
