<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="input" uri="http://www.springframework.org/tags/form" %>
<html lang="en">

<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="">
  <meta name="author" content="">
  <title>SB Admin - Start Bootstrap Template</title>
  <!-- Bootstrap core CSS-->
  <link href="${pageContext.request.contextPath}/resources/vendor/bootstrap-4.0.0/css/bootstrap.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/resources/vendor/bootstrap-4.0.0/css/bootstrap-reboot.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/resources/vendor/bootstrap-4.0.0/css/bootstrap-grid.min.css" rel="stylesheet">
  <!-- Custom fonts for this template-->
  <link href="${pageContext.request.contextPath}/resources/vendor/fontawesome-5.2.0/css/fontawesome.min.css" rel="stylesheet" type="text/css">

  <link href="${pageContext.request.contextPath}/resources/vendor/fontawesome-5.2.0/css/solid.min.css" rel="stylesheet" type="text/css">

  <link href="${pageContext.request.contextPath}/resources/vendor/fontawesome-5.2.0/css/v4-shims.min.css" rel="stylesheet" type="text/css">
  <!-- Page level plugin CSS-->
  <link href="${pageContext.request.contextPath}/resources/vendor/datatables/dataTables.bootstrap4.css" rel="stylesheet">

  <link href="${pageContext.request.contextPath}/resources/vendor/bootstrap-4.0.0/css/bootstrap-treeview.css" rel="stylesheet">

  <link href="${pageContext.request.contextPath}/resources/css/dataTables.checkboxes.css" rel="stylesheet">
  <!-- Custom styles for this template-->
  <link href="${pageContext.request.contextPath}/resources/css/sb-admin.css" rel="stylesheet">
</head>

<body class="fixed-nav sticky-footer bg-dark" id="page-top">
  <!-- Navigation-->
  <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top" id="mainNav">
    <a class="navbar-brand" href="projects">Analysis System</a>
    <button class="navbar-toggler navbar-toggler-right" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarResponsive">
      <ul class="navbar-nav navbar-sidenav" id="exampleAccordion">
        <li class="nav-item" data-toggle="tooltip" data-placement="right" title="Charts">
          <a class="nav-link" href="analysis">
            <i class="fa fa-fw fa-area-chart"></i>
            <span class="nav-link-text">Analysis</span>
          </a>
        </li>
        <li class="nav-item" data-toggle="tooltip" data-placement="right" title="Tables">
          <a class="nav-link" href="projects">
            <i class="fa fa-fw fa-line-chart"></i>
            <span class="nav-link-text">Projects</span>
          </a>
        </li>
        <li class="nav-item" data-toggle="tooltip" data-placement="right" title="Components">
          <a class="nav-link" href="users">
            <i class="fa fa-fw fa-users"></i>
            <span class="nav-link-text">Users</span>
          </a>
        </li>
      </ul>
      <ul class="navbar-nav sidenav-toggler">
        <li class="nav-item">
          <a class="nav-link text-center" id="sidenavToggler">
            <i class="fa fa-fw fa-angle-left"></i>
          </a>
        </li>
      </ul>
      <ul class="navbar-nav ml-auto">
        <li class="nav-item">
          <a class="nav-link" data-toggle="modal" data-target="#exampleModal">
            <i class="fa fa-fw fa-sign-out"></i>Logout</a>
        </li>
      </ul>
    </div>
  </nav>
  <div class="content-wrapper">
    <div class="container-fluid">

      <c:if test="${not empty error_massage}">
        <div class="alert alert-danger">
          <strong>Error!</strong> ${error_massage}
          <button type="button" class="close" data-dismiss="alert" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
      </c:if>

      <!-- Breadcrumbs-->
      <ol class="breadcrumb">
        <li class="breadcrumb-item">
          <a href="${pageContext.request.contextPath}/" class="elements">Analysis System</a>
        </li>
        <li class="breadcrumb-item active">
          <a href="${pageContext.request.contextPath}/projects">My Projects</a>
        </li>
        <li class="breadcrumb-item active">
          ${project.getName()}
        </li>
      </ol>


      <div class="card mb-3">
        <div class="card-header">
          <i class="fa fa-flask"></i> All Experiments</div>
        <div class="card-body">
          <c:if test="${!project.getExperiments().isEmpty() and project.getExperiments() != null}">
          <div class="table-responsive">
            <table class="table table-bordered" id="dataTableExperiment" width="100%" cellspacing="0">
              <thead>
              <tr>
                <th>Id</th>
                <th>Name</th>
                <th>Description</th>
                <th>Animal</th>
                <th></th>
              </tr>
              </thead>
              <tbody>
                <c:forEach var="experiment" items="${project.getExperiments()}">
                  <tr>
                    <td>${experiment.getId()}</td>
                    <td>${experiment.getName()}</td>
                    <td>${experiment.getDescription()}</td>
                    <td>${experiment.getAnimal().getName()}</td>
                    <td>
                       <a href="${pageContext.request.contextPath}/projects/${project.getId()}/experiments/${experiment.getId()}/delete">
                        <i id="experiments-delete-${experiment.getId()}" class="fa fa-trash"></i>
                      </a>
                      <a href="${pageContext.request.contextPath}/projects/${project.getId()}/experiments/${experiment.getId()}">
                        <i id="experiments-open-${experiment.getId()}" class="fa fa-arrow-circle-right"></i>
                      </a>
                    </td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </div>
          </c:if>

          <c:if test="${(experiment_type != null and !experiment_type.isEmpty())
        and (experimentInjections != null and !experimentInjections.isEmpty())
        and (pelletPertubations != null and !pelletPertubations.isEmpty())}">
            <button id="createProjectExperimentsBtn" data-toggle="collapse" href="#collapseExperiments" type="button" class="btn btn-info" aria-expanded="true">
              <i id="createProjectExperimentsIcon" class="fa fa-plus-circle"></i> Create New Experiment
            </button>

            <div id="collapseExperiments" class="collapse col-md-6" style="padding-top:1%;">
              <div class="card md-3">
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/projects/${project.getId()}/experiments" method="post">
                      <div class="row">
                      <div class="col-md-6">
                        <div class="form-group">
                          <label for="experimentsName">Name</label>
                          <input type="text" name="name" required="required" data-error="Experiment name is required" class="form-control" id="experimentsName" placeholder="Enter Name">
                        </div>
                        <div class="form-group">
                          <label for="experimentsDescription">Description</label>
                          <textarea name="description" required="required" data-error="Experiment description is required" class="form-control" id="experimentsDescription" placeholder="Enter Description"></textarea>
                        </div>
                        <div class="form-group">
                          <label for="experimentsDepth">Depth</label>
                          <input type="number" name="depth" required="required" data-error="Experiment depth is required" class="form-control" id="experimentsDepth" placeholder="Enter Depth">
                        </div>
                        <div class="form-group">
                          <label for="imaging_sampling_rate">Imaging Sampling Rate</label>
                          <input type="number" name="imaging_sampling_rate" required="required" data-error="Experiment imaging sampling rate is required" class="form-control" id="imaging_sampling_rate" placeholder="Enter Imaging sampling rate">
                        </div>
                        <div class="form-group">
                          <label for="behavioral_sampling_rate">Behavioral Sampling Rate</label>
                          <input type="number" name="behavioral_sampling_rate" required="required" data-error="Experiment behavioral sampling rate is required" class="form-control" id="behavioral_sampling_rate" placeholder="Enter behavioral sampling rate">
                        </div>
                        <div class="form-group">
                          <label for="tone_time">Tone Time</label>
                          <input type="number" name="tone_time" required="required" data-error="Experiment tone time is required" class="form-control" id="tone_time" placeholder="Enter tone time">
                        </div>
                      </div>

                      <div class="col-md-6">
                        <div class="form-group">
                          <label for="duration">Duration</label>
                          <input type="number" name="duration" required="required" data-error="Experiment duration is required" class="form-control" id="duration" placeholder="Enter duration">
                        </div>
                        <div class="form-group">
                          <label for="behavioral_delay">Behavioral Delay</label>
                          <input type="number" name="behavioral_delay" required="required" data-error="Experiment behavioral delay is required" class="form-control" id="behavioral_delay" placeholder="Enter behavioral delay">
                        </div>
                        <div class="form-group">
                          <label for="experimentAnimal">Animal</label>
                          <select id="experimentAnimal" name="experiment_animal" class="form-control">
                            <c:forEach var="animal" items="${project.getAnimals()}">
                              <option value="${animal.getId()}">${animal.getName()}</option>
                            </c:forEach>
                          </select>
                        </div>

                        <div class="form-group">
                          <label for="experimentType">Type</label>
                          <select id="experimentType" name="experiment_type" class="form-control">
                            <c:forEach var="type" items="${experiment_type}">
                              <option value="${type.getId()}">${type.getName()}</option>
                            </c:forEach>
                          </select>
                        </div>

                        <div class="form-group">
                          <label for="experimentInjections">Injection</label>
                          <select id="experimentInjections" name="experiment_injection" class="form-control">
                            <c:forEach var="injection" items="${experimentInjections}">
                              <option value="${injection.getId()}">${injection.getName()}</option>
                            </c:forEach>
                          </select>
                        </div>

                        <div class="form-group">
                          <label for="experimentPelletPertubation">Pellet Pertubation</label>
                          <select id="experimentPelletPertubation" name="experiment_pelletPertubation" class="form-control">
                            <c:forEach var="PelletPertubation" items="${pelletPertubations}">
                              <option value="${PelletPertubation.getId()}">${PelletPertubation.getName()}</option>
                            </c:forEach>
                          </select>
                        </div>
                      </div>
                      </div>

                      <button type="submit" class="btn btn-primary">Save</button>
                    </form>
                </div>

              </div>
            </div>
          </c:if>


        </div>

      </div>

      <div class="card mb-3">
        <div class="card-header">
          <i class="fa fa-frog"></i> All Animals</div>
        <div class="card-body">
        <c:if test="${!project.getAnimals().isEmpty() and project.getAnimals() != null}">
          <div class="table-responsive">
            <table class="table table-bordered" id="dataTableAnimals" width="100%" cellspacing="0">
              <thead>
              <tr>
                <th>Id</th>
                <th>Name</th>
                <th>Description</th>
                <th></th>
              </tr>
              </thead>
              <tbody>
              <c:forEach var="animal" items="${project.getAnimals()}">
                <tr>
                  <td>${animal.getId()}</td>
                  <td>${animal.getName()}</td>
                  <td>${animal.getDescription()}</td>
                  <td>
                    <a href="${pageContext.request.contextPath}/projects/${project.getId()}/animals/${animal.getId()}/delete">
                      <i id="animals-delete-${animal.getId()}" class="fa fa-trash"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/projects/${project.getId()}/animals/${animal.getId()}">
                      <i id="animals-open-${animal.getId()}" class="fa fa-arrow-circle-right"></i>
                    </a>
                  </td>
                </tr>
              </c:forEach>
              </tbody>
            </table>
          </div>
        </c:if>

            <c:if test="${!project.getLayers().isEmpty() and project.getLayers() != null}">
                <button id="createProjectAnimalsBtn" data-toggle="collapse" href="#collapseAnimals" type="button" class="btn btn-info" aria-expanded="true">
            <i id="createProjectAnimalsIcon" class="fa fa-plus-circle"></i> Create New Animal
          </button>
                <div id="collapseAnimals" class="collapse col-md-6" style="padding-top:1%;">
            <div class="card md-3">
              <div class="card-body">
                <div class="row">
                  <form action="${pageContext.request.contextPath}/projects/${project.getId()}/animals" method="post" class="col-md-6">
                    <div class="form-group">
                      <label for="AnimalsName">Name</label>
                      <input type="text" name="name" required="required" data-error="Animal name is required" class="form-control" id="AnimalsName" placeholder="Enter Name">
                    </div>
                    <div class="form-group">
                      <label for="animalDescription">Description</label>
                      <textarea type="text" name="description" required="required" data-error="Animal description is required" class="form-control" id="animalDescription" placeholder="Enter Description"></textarea>
                    </div>
                    <div class="form-group">
                      <label for="animalsLayer">Layer</label>

                      <select id="animalsLayer" name="animal_layer" class="form-control">
                        <c:forEach var="layer" items="${project.getLayers()}">
                          <option value="${layer.getId()}">${layer.getName()}</option>
                        </c:forEach>
                      </select>
                    </div>
                    <button type="submit" class="btn btn-primary">Save</button>
                  </form>
                </div>

              </div>

            </div>
          </div>
            </c:if>
        </div>
      </div>

      <div class="card mb-3">
        <div class="card-header">
          <i class="fa fa-layer-group"></i> All Layers</div>
        <div class="card-body">
          <c:if test="${!project.getLayers().isEmpty() and project.getLayers() != null}">
          <div class="table-responsive">
            <table class="table table-bordered" id="dataTableLayers" width="100%" cellspacing="0">
              <thead>
              <tr>
                <th>Id</th>
                <th>Name</th>
                <th></th>
              </tr>
              </thead>
              <tbody>
              <c:forEach var="layer" items="${project.getLayers()}">
                <tr>
                  <td>${layer.getId()}</td>
                  <td>${layer.getName()}</td>
                  <td>
                    <a href="${pageContext.request.contextPath}/projects/${project.getId()}/layers/${layer.getId()}/delete">
                      <i id="layers-delete-${layer.getId()}" class="fa fa-trash"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/projects/${project.getId()}/layers/${layer.getId()}">
                      <i id="layers-open-${layer.getId()}" class="fa fa-arrow-circle-right"></i>
                    </a>
                  </td>
                </tr>
              </c:forEach>
              </tbody>
            </table>
          </div>
          </c:if>

          <button id="createProjectLayersBtn" data-toggle="collapse" href="#collapseLayers" type="button" class="btn btn-info" aria-expanded="true">
              <i id="createProjectLayersIcon" class="fa fa-plus-circle"></i> Create New Layer
            </button>
          <div id="collapseLayers" class="collapse col-md-6" style="padding-top:1%;">
              <div class="card md-3">
                <div class="card-body">
                  <div class="row">
                    <form action="${pageContext.request.contextPath}/projects/${project.getId()}/layers" method="post" class="col-md-6">
                      <div class="form-group">
                        <label for="LayersName">Name</label>
                        <input type="text" name="name" required="required" data-error="Analysis name is required" class="form-control" id="LayersName" placeholder="Enter Name">
                      </div>
                      <button type="submit" class="btn btn-primary">Save</button>
                    </form>
                  </div>

                </div>

              </div>
            </div>

        </div>
      </div>


      <div class="card mb-3">
        <div class="card-header">
          <i class="fa fa-line-chart"></i> All Analysis</div>
        <div class="card-body">
          <c:if test="${!project.getAnalyzes().isEmpty() and project.getAnalyzes() != null}">
            <div class="table-responsive">
            <table class="table table-bordered" id="dataTableAnalysis" width="100%" cellspacing="0">
              <thead>
              <tr>
                <th>Id</th>
                <th>Name</th>
                <th>Description</th>
                <th></th>
              </tr>
              </thead>
              <tbody>
              <c:forEach var="analysis" items="${project.getAnalyzes()}">
                <tr>
                  <td>${analysis.getId()}</td>
                  <td>${analysis.getName()}</td>
                  <td>${analysis.getDescription()}</td>
                  <td>
                    <a href="${pageContext.request.contextPath}/projects/${project.getId()}/analysis/${analysis.getId()}/delete">
                      <i id="analysis-delete-${analysis.getId()}" class="fa fa-trash"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/projects/${project.getId()}/analysis/${analysis.getId()}">
                      <i id="analysis-open-${analysis.getId()}" class="fa fa-arrow-circle-right"></i>
                    </a>
                  </td>
                </tr>
              </c:forEach>
              </tbody>
            </table>
          </div>
          </c:if>

          <c:if test="${analysisTypes != null and !analysisTypes.isEmpty()}">
              <button id="createProjectAnalysisBtn" data-toggle="collapse" href="#collapseAnalysis" type="button" class="btn btn-info" aria-expanded="true">
                <i id="createProjectAnalysisIcon" class="fa fa-plus-circle"></i> Create New Project Analysis
              </button>
              <div id="collapseAnalysis" class="collapse" style="padding-top:1%;">
                <div class="card md-3">
                  <div class="card-body">
                    <%--<div class="row">--%>
                      <form action="${pageContext.request.contextPath}/projects/${project.getId()}/analysis" id="addanalysisForm" method="post">
                        <div class="row">
                          <div class="col-md-3">
                            <div class="form-group">
                              <label for="analysisName">Name</label>
                              <input type="text" name="name" required="required" data-error="Analysis name is required" class="form-control" id="analysisName" aria-describedby="NameHelp" placeholder="Enter Name">
                            </div>

                            <div class="form-group">
                              <label for="analysisDescription">Description</label>
                              <textarea type="text" name="description" required="required" data-error="Analysis description is required" class="form-control" id="analysisDescription" placeholder="Enter Description"></textarea>
                            </div>

                              <div class="form-group">
                                  <label for="analysisVisFontSize">visualization Font Size</label>
                                  <input type="number" step="any" name="font_size" required="required" data-error="Analysis font size is required" class="form-control" id="analysisVisFontSize" placeholder="Enter Font Size">
                              </div>

                              <div class="form-group">
                                  <label for="analysisVisStartTime">visualization start time to plot</label>
                                  <input type="number" step="any" name="startTime2plot" required="required" data-error="Analysis start time plot is required" class="form-control" id="analysisVisStartTime" placeholder="Enter start time to plot">
                              </div>


                              <div class="form-group">
                                  <label for="time2startCountGrabs">Time to start count grabs</label>
                                  <input type="number" step="any" name="time2startCountGrabs" required="required" data-error="Analysis start time plot is required" class="form-control" id="time2startCountGrabs" placeholder="Enter time">
                              </div>


                              <div class="form-group">
                                  <label for="time2endCountGrabs">Time to end count grabs</label>
                                  <input type="number" step="any" name="time2endCountGrabs" required="required" data-error="Analysis start time plot is required" class="form-control" id="time2endCountGrabs" placeholder="Enter time">
                              </div>

                            <div class="form-group">
                              <label for="analysisType">Analysis Types : </label>

                              <c:forEach var="analysis_types" items="${analysisTypes}">
                                <label id="analysisType" class="checkbox"><input type="checkbox" name="types" value="${analysis_types.getId()}">${analysis_types.getName()}</label>
                              </c:forEach>
                            </div>
                              <div class="form-group">
                                  <label for="experimentEvents">Experiments Events To Plot : </label>

                                  <c:forEach var="experimentEvent" items="${experimentEvents}">
                                      <label id="experimentEvents" class="checkbox"><input type="checkbox" name="events" value="${experimentEvent.getId()}">${experimentEvent.getName()}</label>
                                  </c:forEach>
                              </div>
                              <div class="form-group">
                                  <label for="trailsAnalysisExperiment">Experiment for analysis : </label>

                                  <select id="trailsAnalysisExperiment" name="experiment_id" class="form-control">
                                      <c:forEach var="experiment" items="${project.getExperiments()}">
                                          <option value="${experiment.getId()}">
                                                  ${experiment.getName()}
                                          </option>
                                      </c:forEach>
                                  </select>
                              </div>


                              <button id="createAnalysisSubmit" type="submit" class="btn btn-primary">Save</button>
                          </div>
                          <%--<div class="col-md-6">--%>
                            <c:forEach var="experiment" items="${project.getExperiments()}">
                              <div  id="trials${experiment.getId()}" class="col-md-9">
                                <div class="row">
                                <div class="col-md-6">
                                  <c:set var="neurons" value="${neuronsBean.getNeurons(experiment)}"/>

                                  <div class="form-group">
                                    <label>Neurons To Plot : </label>

                                    <div class="table-responsive" style="margin-top:5%">
                                      <table class="table table-bordered dataTableTrials" id="dataTableNeuronsToPlot${experiment.getId()}" width="100%" cellspacing="0">
                                        <thead>
                                        <tr>
                                          <td><input type="checkbox" name="select_all" value="1" id="dataTableNeuronsToPlot${experiment.getId()}-select-all"></td>
                                          <th>Neuron Name</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <c:forEach var="neuron" items="${neurons}">
                                          <tr>
                                            <td>
                                              <input name="neurons_toPlot" type="checkbox" value="${experiment.getId()}_${neuron}">
                                            </td>
                                            <td>${neuron}</td>
                                          </tr>
                                        </c:forEach>
                                        </tbody>
                                      </table>
                                    </div>
                                  </div>
                                  <div class="form-group">
                                  <label>Neurons For Analysis : </label>
                                  <div class="table-responsive" style="margin-top:5%">
                                    <table class="table table-bordered dataTableTrials" id="dataTableNeuronsForAnalysis${experiment.getId()}" width="100%" cellspacing="0">
                                      <thead>
                                      <tr>
                                        <td><input type="checkbox" name="select_all" value="1" id="dataTableNeuronsForAnalysis${experiment.getId()}-select-all"></td>
                                        <th>Neuron Name</th>
                                      </tr>
                                      </thead>
                                      <tbody>
                                      <c:forEach var="neuron" items="${neuronsBean.getNeurons(experiment)}">
                                        <tr>
                                          <td>
                                            <input name="neurons_forAnalysis" type="checkbox" value="${experiment.getId()}_${neuron}">
                                          </td>
                                          <td>${neuron}</td>
                                        </tr>
                                      </c:forEach>
                                      </tbody>
                                    </table>
                                  </div>

                                </div>
                                </div>

                                <div class="col-md-6">
                                 <div class="form-group">
                                  <label>Trials for analysis : </label>
                                    <div class="table-responsive" style="margin-top:5%">
                                        <table class="table table-bordered dataTableTrials" id="dataTableTrials${experiment.getId()}" width="100%" cellspacing="0">
                                            <thead>
                                            <tr>
                                                <td><input type="checkbox" name="select_all" value="1" id="dataTableTrials${experiment.getId()}-select-all"></td>
                                                <th>Trial Name</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <c:forEach var="trial" items="${experiment.getTrials()}">
                                                <tr>
                                                    <td>
                                                        <input name="trialsSelected" type="checkbox" value="${experiment.getId()}_${trial.getId()}">
                                                    </td>
                                                    <td>${trial.getName()}</td>
                                                </tr>
                                            </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>

                                </div>
                                </div>
                                </div>
                              </div>
                            </c:forEach>

                          <%--</div>--%>
                        </div>
                      </form>
                    <%--</div>--%>

                  </div>

                </div>
              </div>
          </c:if>
        </div>
      </div>

      </div>
    </div>
    <!-- /.container-fluid-->
    <!-- /.content-wrapper-->
    <footer class="sticky-footer">
      <div class="container">
        <div class="text-center">
          <small>Copyright © Analysis System 2018</small>
        </div>
      </div>
    </footer>
    <!-- Scroll to Top Button-->
    <a class="scroll-to-top rounded" href="#page-top">
      <i class="fa fa-angle-up"></i>
    </a>
    <!-- Logout Modal-->
    <div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="exampleModalLabel">Ready to Leave?</h5>
            <button class="close" type="button" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">×</span>
            </button>
          </div>
          <div class="modal-body">Select "Logout" below if you are ready to end your current session.</div>
          <div class="modal-footer">
            <button class="btn btn-secondary" type="button" data-dismiss="modal">Cancel</button>
            <a class="btn btn-primary" href="login.jsp">Logout</a>
          </div>
        </div>
      </div>
    </div>
    <!-- Bootstrap core JavaScript-->

    <script src="${pageContext.request.contextPath}/resources/vendor/jquery/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/vendor/bootstrap-4.0.0/js/bootstrap.bundle.min.js"></script>
    <!-- Core plugin JavaScript-->
    <script src="${pageContext.request.contextPath}/resources/vendor/jquery-easing/jquery.easing.min.js"></script>
    <!-- Page level plugin JavaScript-->
    <script src="${pageContext.request.contextPath}/resources/vendor/chart.js/Chart.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/vendor/datatables/jquery.dataTables.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/dataTables.checkboxes.min.js"></script>

  <script src="${pageContext.request.contextPath}/resources/vendor/datatables/dataTables.bootstrap4.js"></script>
    <!-- Custom scripts for all pages-->
    <script src="${pageContext.request.contextPath}/resources/js/sb-admin.min.js"></script>
    <!-- Custom scripts for this page-->
    <script src="${pageContext.request.contextPath}/resources/js/sb-admin-datatables.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/sb-admin-charts.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/vendor/bootstrap-4.0.0/js/bootstrap-treeview.js"></script>

    <script>

        function setCheckBox(id, val)
        {
            $(id + '-select-all').prop('checked', val);
            var tableNP = $(id).DataTable();
            var rowsNP = tableNP.rows({ 'search': 'applied' }).nodes();
            // Check/uncheck checkboxes for all rows in the table
            $('input[type="checkbox"]', rowsNP).prop('checked', val);
        }

        $(document).ready(function () {
            <c:forEach var="experiment_val" items="${project.getExperiments()}">
                $('#trials' + ${experiment_val.getId()}).hide();
            </c:forEach>

            var before = $("#trailsAnalysisExperiment").val();


            setCheckBox('#dataTableNeuronsToPlot' + before, true);

            setCheckBox('#dataTableNeuronsForAnalysis' + before, true);

            setCheckBox('#dataTableTrials' + before, true);
            $('#trials' + before).fadeIn();

            $("#trailsAnalysisExperiment").change(function () {
                setCheckBox('#dataTableNeuronsToPlot' + before, false);

                setCheckBox('#dataTableNeuronsForAnalysis' + before, false);

                setCheckBox('#dataTableTrials' + before, false);

                var id_val = this.value;
                $('#trials' + before).fadeOut();
                $('#trials' + id_val).fadeIn();
                setCheckBox('#dataTableNeuronsToPlot' + id_val, true);

                setCheckBox('#dataTableNeuronsForAnalysis' + id_val, true);

                setCheckBox('#dataTableTrials' + id_val, true);
                before = id_val;
            });

            var checkboxes = $("input[name='types']"),
                submitButt = $("input[id='createAnalysisSubmit']");

            checkboxes.click(function() {
                submitButt.attr("disabled", !checkboxes.is(":checked"));
            });

            $(".experiment_trials_icon").click(function () {
                var id = this.id;
                if ($("#" + id).hasClass("fa-plus-circle")) {
                    $("#" + id).removeClass("fa-plus-circle");
                    $("#" + id).addClass("fa-minus-circle");
                } else {
                    $("#" + id).removeClass("fa-minus-circle");
                    $("#" + id).addClass("fa-plus-circle");
                }
            });


            $("#createProjectAnalysisBtn").click(function () {
                if ($("#createProjectAnalysisIcon").hasClass("fa-plus-circle")) {
                    $("#createProjectAnalysisIcon").removeClass("fa-plus-circle");
                    $("#createProjectAnalysisIcon").addClass("fa-minus-circle");
                } else {
                    $("#createProjectAnalysisIcon").removeClass("fa-minus-circle");
                    $("#createProjectAnalysisIcon").addClass("fa-plus-circle");
                }
            });

            $("#createProjectAnimalsBtn").click(function () {
                if ($("#createProjectAnimalsIcon").hasClass("fa-plus-circle")) {
                    $("#createProjectAnimalsIcon").removeClass("fa-plus-circle");
                    $("#createProjectAnimalsIcon").addClass("fa-minus-circle");
                } else {
                    $("#createProjectAnimalsIcon").removeClass("fa-minus-circle");
                    $("#createProjectAnimalsIcon").addClass("fa-plus-circle");
                }
            });

            $("#createProjectLayersBtn").click(function () {
                if ($("#createProjectLayersIcon").hasClass("fa-plus-circle")) {
                    $("#createProjectLayersIcon").removeClass("fa-plus-circle");
                    $("#createProjectLayersIcon").addClass("fa-minus-circle");
                } else {
                    $("#createProjectLayersIcon").removeClass("fa-minus-circle");
                    $("#createProjectLayersIcon").addClass("fa-plus-circle");
                }
            });

            $("#createProjectExperimentsBtn").click(function () {
                if ($("#createProjectExperimentsIcon").hasClass("fa-plus-circle")) {
                    $("#createProjectExperimentsIcon").removeClass("fa-plus-circle");
                    $("#createProjectExperimentsIcon").addClass("fa-minus-circle");
                } else {
                    $("#createProjectExperimentsIcon").removeClass("fa-minus-circle");
                    $("#createProjectExperimentsIcon").addClass("fa-plus-circle");
                }
            });
        })
    </script>

  </div>
</body>

</html>
