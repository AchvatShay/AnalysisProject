package com.analysis.manager.modle;

public class FilesManager {
    private String file_name;
    private String analysis_name;
    private String analysis_type;
    private String project_name;
    private String user_name;
    private String file_end;

    public FilesManager(String file_name, String analysis_name, String analysis_type, String project_name, String user_name, String file_end) {
        this.file_name = file_name;
        this.analysis_name = analysis_name;
        this.analysis_type = analysis_type;
        this.project_name = project_name;
        this.user_name = user_name;
        this.file_end = file_end;
    }

    public String getFileName() {
        return file_name;
    }

    public void setFileName(String file_name) {
        this.file_name = file_name;
    }

    public String getAnalysisName() {
        return analysis_name;
    }

    public void setAnalysisName(String analysis_name) {
        this.analysis_name = analysis_name;
    }

    public String getAnalysisType() {
        return analysis_type;
    }

    public void setAnalysisType(String analysis_type) {
        this.analysis_type = analysis_type;
    }

    public String getProjectName() {
        return project_name;
    }

    public void setProjectName(String project_name) {
        this.project_name = project_name;
    }

    public String getUserName() {
        return user_name;
    }

    public void setUserName(String user_name) {
        this.user_name = user_name;
    }

    public String getFileEnd() {
        return file_end;
    }

    public void setFileEnd(String file_end) {
        this.file_end = file_end;
    }
}
