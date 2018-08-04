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
  <link href="../../${pageContext.request.contextPath}/resources/vendor/bootstrap-4.0.0/css/bootstrap.min.css" rel="stylesheet">
  <link href="../../${pageContext.request.contextPath}/resources/vendor/bootstrap-4.0.0/css/bootstrap-reboot.min.css" rel="stylesheet">
  <link href="../../${pageContext.request.contextPath}/resources/vendor/bootstrap-4.0.0/css/bootstrap-grid.min.css" rel="stylesheet">
  <!-- Custom fonts for this template-->
  <link href="../../${pageContext.request.contextPath}/resources/vendor/fontawesome-5.2.0/css/fontawesome.min.css" rel="stylesheet" type="text/css">

  <link href="../../${pageContext.request.contextPath}/resources/vendor/fontawesome-5.2.0/css/solid.min.css" rel="stylesheet" type="text/css">

  <link href="../../${pageContext.request.contextPath}/resources/vendor/fontawesome-5.2.0/css/v4-shims.min.css" rel="stylesheet" type="text/css">
  <!-- Page level plugin CSS-->
  <link href="../../${pageContext.request.contextPath}/resources/vendor/datatables/dataTables.bootstrap4.css" rel="stylesheet">
  <!-- Custom styles for this template-->
  <link href="../../${pageContext.request.contextPath}/resources/css/sb-admin.css" rel="stylesheet">
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

    <c:if test="${!project.getExperiments().isEmpty()}">
      <div class="card mb-3">
        <div class="card-header">
          <i class="fa fa-flask"></i> All Experiments</div>
        <div class="card-body">
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
                       <a href="${pageContext.request.contextPath}/experiments/delete/${experiment.getId()}">
                        <i id="experiments-delete-${experiment.getId()}" class="fa fa-trash"></i>
                      </a>
                      <a href="${pageContext.request.contextPath}/experiments/${experiment.getId()}">
                        <i id="experiments-open-${experiment.getId()}" class="fa fa-arrow-circle-right"></i>
                      </a>
                    </td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </div>
        </div>
        <div class="card-footer small text-muted">
          <input type="submit" id="create_experiment" value="Add Experiment" class="btn btn-primary fa-plus">
        </div>
        </div>
    </c:if>

      <c:if test="${!project.getAnimals().isEmpty()}">
      <div class="card mb-3">
        <div class="card-header">
          <i class="fa fa-frog"></i> All Animals</div>
        <div class="card-body">
          <div class="table-responsive">
            <table class="table table-bordered" id="dataTableAnimal" width="100%" cellspacing="0">
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
                    <a href="${pageContext.request.contextPath}/animals/delete/${animal.getId()}">
                      <i id="animals-delete-${animal.getId()}" class="fa fa-trash"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/animals/${animal.getId()}">
                      <i id="animals-open-${animal.getId()}" class="fa fa-arrow-circle-right"></i>
                    </a>
                  </td>
                </tr>
              </c:forEach>
              </tbody>
            </table>
          </div>
        </div>
        <div class="card-footer small text-muted">
          <input type="submit" id="create_animal" value="Add Animal" class="btn btn-primary fa-plus">
        </div>
      </div>
      </c:if>

        <c:if test="${!project.getLayers().isEmpty()}">
      <div class="card mb-3">
        <div class="card-header">
          <i class="fa fa-layer-group"></i> All Layers</div>
        <div class="card-body">
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
                    <a href="${pageContext.request.contextPath}/layers/delete/${layer.getId()}">
                      <i id="layers-delete-${layer.getId()}" class="fa fa-trash"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/layers/${layer.getId()}">
                      <i id="layers-open-${layer.getId()}" class="fa fa-arrow-circle-right"></i>
                    </a>
                  </td>
                </tr>
              </c:forEach>
              </tbody>
            </table>
          </div>
        </div>
        <div class="card-footer small text-muted">
          <input type="submit" id="create_layer" value="Add Layer" class="btn btn-primary fa-plus">
        </div>
      </div>
        </c:if>

          <c:if test="${!project.getAnalyzes().isEmpty()}">
      <div class="card mb-3">
        <div class="card-header">
          <i class="fa fa-line-chart"></i> All Analysis</div>
        <div class="card-body">
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
                    <a href="${pageContext.request.contextPath}/analysis/delete/${analysis.getId()}">
                      <i id="analysis-delete-${analysis.getId()}" class="fa fa-trash"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/analysis/${analysis.getId()}">
                      <i id="analysis-open-${analysis.getId()}" class="fa fa-arrow-circle-right"></i>
                    </a>
                  </td>
                </tr>
              </c:forEach>
              </tbody>
            </table>
          </div>
        </div>
        <div class="card-footer small text-muted">
          <input type="submit" id="create_analysis" value="Add Analysis" class="btn btn-primary fa-plus">
        </div>
      </div>
          </c:if>

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

    <script src="../../${pageContext.request.contextPath}/resources/vendor/jquery/jquery.min.js"></script>
    <script src="../../${pageContext.request.contextPath}/resources/vendor/bootstrap-4.0.0/js/bootstrap.bundle.min.js"></script>
    <!-- Core plugin JavaScript-->
    <script src="../../${pageContext.request.contextPath}/resources/vendor/jquery-easing/jquery.easing.min.js"></script>
    <!-- Page level plugin JavaScript-->
    <script src="../../${pageContext.request.contextPath}/resources/vendor/chart.js/Chart.min.js"></script>
    <script src="../../${pageContext.request.contextPath}/resources/vendor/datatables/jquery.dataTables.js"></script>
    <script src="../../${pageContext.request.contextPath}/resources/vendor/datatables/dataTables.bootstrap4.js"></script>
    <!-- Custom scripts for all pages-->
    <script src="../../${pageContext.request.contextPath}/resources/js/sb-admin.min.js"></script>
    <!-- Custom scripts for this page-->
    <script src="../../${pageContext.request.contextPath}/resources/js/sb-admin-datatables.min.js"></script>
    <script src="../../${pageContext.request.contextPath}/resources/js/sb-admin-charts.min.js"></script>

    <script>

    </script>

  </div>
</body>

</html>
