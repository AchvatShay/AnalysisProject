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
  <title>Analysis System</title>
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
          <a href="${pageContext.request.contextPath}/projects/${experiment.getProject().getId()}">${experiment.getProject().getName()}</a>
        </li>
        <li class="breadcrumb-item active">
          ${experiment.getName()}
        </li>
      </ol>

      <div class="row">
        <div class="col-12">
          <label for="name">Name : </label>
          <label id="name">${experiment.getName()}</label>

          <label for="description">Description : </label>
          <label id="description">${experiment.getDescription()}</label>

          <label for="animal">Animal : </label>
          <label id="animal">${experiment.getAnimal().getName()}</label>

          <label for="project">Project : </label>
          <label id="project">${experiment.getProject().getName()}</label>
        </div>
      </div>

      <div class="col-md-5">
        <div class="card mb-3">
          <div class="card-header">
            <i class="fa fa-info-circle"></i> Experiment Conditions</div>
          <div class="card-body">
            <div class="row">
              <div class="col-md-3 card-text">Type : </div>
              <div class="col-md-3 card-text">${experiment.getExperimentCondition().getExperimentType().getName()} </div>
            </div>
            <div class="row">
              <div class="col-md-3">Injections : </div>
              <div class="col-md-3">${experiment.getExperimentCondition().getExperimentInjections().getName()} </div>
            </div>
            <div class="row">
              <div class="col-md-3">Pellet Pertubation : </div>
              <div class="col-md-3">${experiment.getExperimentCondition().getExperimentPelletPertubation().getName()} </div>
            </div>
            <div class="row">
              <div class="col-md-3">depth : </div>
              <div class="col-md-3">${experiment.getExperimentCondition().getDepth()} </div>
            </div>
            <div class="row">
              <div class="col-md-3">imaging_sampling_rate : </div>
              <div class="col-md-3">${experiment.getExperimentCondition().getImaging_sampling_rate()} </div>
            </div>
            <div class="row">
              <div class="col-md-3">behavioral_sampling_rate : </div>
              <div class="col-md-3">${experiment.getExperimentCondition().getBehavioral_sampling_rate()} </div>
            </div>
            <div class="row">
              <div class="col-md-3">tone_time : </div>
              <div class="col-md-3">${experiment.getExperimentCondition().getTone_time()} </div>
            </div>
            <div class="row">
              <div class="col-md-3">duration : </div>
              <div class="col-md-3">${experiment.getExperimentCondition().getDuration()} </div>
            </div>
            <div class="row">
              <div class="col-md-3">behavioral_delay : </div>
              <div class="col-md-3">${experiment.getExperimentCondition().getBehavioral_delay()} </div>
            </div>
          </div>
        </div>
      </div>

      <button id="addExperimentTrialBtn" data-toggle="collapse" href="#collapseTrial" type="button" class="btn btn-info" aria-expanded="true">
        <i id="addExperimentTrialIcon" class="fa fa-plus-circle"></i> Add Trials
      </button>
      <div id="collapseTrial" class="collapse col-md-6" style="padding-top:1%;">
        <div class="card md-3">
          <div class="card-header">
            <div class="card-title">
              <h1>Multiple Trails</h1>
            </div>
          </div>
          <div class="card-body">
            <div class="row">
              <form action="${pageContext.request.contextPath}/projects/${experiment.getProject().getId()}/experiments/${experiment.getId()}/add_trails" method="post" class="col-md-6">
                <div class="form-group">
                  <label for="files_location">Trails BDA+TPA files location</label>
                  <input type="text" name="files_location" required="required" data-error="files location is required" class="form-control" id="files_location" placeholder="Enter files location">
                </div>
                <button type="submit" class="btn btn-primary">ADD</button>
              </form>
            </div>

          </div>

        </div>

        <div class="card md-3">
          <div class="card-header">
            <div class="card-title">
              <h1>Trail</h1>
            </div>
          </div>
          <div class="card-body">
            <div class="row">
              <form action="${pageContext.request.contextPath}/projects/${experiment.getProject().getId()}/experiments/${experiment.getId()}/add_trail" method="post" class="col-md-6">
                <div class="form-group">
                  <label for="bda_location">Trail BDA file location</label>
                  <input type="text" name="bda_location" required="required" data-error="BDA location is required" class="form-control" id="bda_location" placeholder="Enter files location">
                </div>
                <div class="form-group">
                  <label for="tpa_location">Trail TPA file location</label>
                  <input type="text" name="tpa_location" required="required" data-error="BDA location is required" class="form-control" id="tpa_location" placeholder="Enter files location">
                </div>
                <button type="submit" class="btn btn-primary">ADD</button>
              </form>
            </div>
          </div>
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
    <script src="${pageContext.request.contextPath}/resources/vendor/datatables/dataTables.bootstrap4.js"></script>
    <!-- Custom scripts for all pages-->
    <script src="${pageContext.request.contextPath}/resources/js/sb-admin.min.js"></script>
    <!-- Custom scripts for this page-->
    <script src="${pageContext.request.contextPath}/resources/js/sb-admin-datatables.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/sb-admin-charts.min.js"></script>

  <script>
      $(document).ready(function () {
          $("#addExperimentTrialBtn").click(function () {
              if ($("#addExperimentTrialIcon").hasClass("fa-plus-circle")) {
                  $("#addExperimentTrialIcon").removeClass("fa-plus-circle");
                  $("#addExperimentTrialIcon").addClass("fa-minus-circle");
              } else {
                  $("#addExperimentTrialIcon").removeClass("fa-minus-circle");
                  $("#addExperimentTrialIcon").addClass("fa-plus-circle");
              }
          });
      })
  </script>

  </div>
</body>

</html>
