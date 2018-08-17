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

  <link href="${pageContext.request.contextPath}/resources/css/analysis-custom.css" rel="stylesheet">
</head>

<body class="fixed-nav sticky-footer bg-dark" id="page-top">
<!-- Navigation-->
  <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top" id="mainNav">
    <a class="navbar-brand" href="projects">Analysis System</a>
    <button class="navbar-toggler navbar-toggler-right" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarResponsive">
      <ul class="navbar-nav" id="exampleAccordion">
        <li class="nav-item" >
          <a class="nav-link" href="${pageContext.request.contextPath}/analysis">
            <i class="fa fa-fw fa-area-chart"></i>
            <span class="nav-link-text">Analysis</span>
          </a>
        </li>
        <li class="nav-item" >
          <a class="nav-link" href="${pageContext.request.contextPath}/projects">
            <i class="fa fa-fw fa-line-chart"></i>
            <span class="nav-link-text">Projects</span>
          </a>
        </li>
        <li class="nav-item" >
          <a class="nav-link" href="${pageContext.request.contextPath}/users">
            <i class="fa fa-fw fa-users"></i>
            <span class="nav-link-text">Users</span>
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
    <div class="container-fluid rapper">

      <c:if test="${error_message != null and !error_message.equals('')}">
        <div class="alert alert-danger">
          <strong>Error!</strong> ${error_message}
          <button type="button" class="close" data-dismiss="alert" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
      </c:if>

      <!-- Breadcrumbs-->
      <ol class="breadcrumb">
        <li class="breadcrumb-item">
          <a href="${pageContext.request.contextPath}/">Analysis System</a>
        </li>
        <li class="breadcrumb-item active">My Projects</li>
      </ol>

      <c:if test="${!my_projects.isEmpty()}">
        <div class="card mb-3">
          <div class="card-header">
            <i class="fa fa-line-chart"></i> All Projects</div>
          <div class="card-body">
            <div class="table-responsive">
              <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                <thead>
                <tr>
                  <th>Id</th>
                  <th>Name</th>
                  <th>Description</th>
                  <th></th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="project" items="${my_projects}">
                  <tr>
                    <td>${project.getId()}</td>
                    <td>${project.getName()}</td>
                    <td>${project.getDescription()}</td>
                    <td>
                      <a href="${pageContext.request.contextPath}/projects/${project.getId()}/delete">
                        <i id="project-delete-${project.getId()}" class="fa fa-trash"></i>
                      </a>
                      <a href="${pageContext.request.contextPath}/projects/${project.getId()}">
                        <i id="project-edit-${project.getId()}" class="fa fa-arrow-circle-right"></i>
                      </a>
                    </td>
                  </tr>
                </c:forEach>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </c:if>


      <button id="createProjectBtn" data-toggle="collapse" href="#collapse1" type="button" class="btn btn-info" aria-expanded="true">
        <i id="createProjectIcon" class="fa fa-plus-circle"></i> Create New Project
      </button>

      <div id="collapse1" class="collapse col-md-6" style="padding-top:1%;">
        <div class="card md-3">
          <div class="card-body">
            <div class="row">
                <form action="${pageContext.request.contextPath}/projects" method="post" class="col-md-6">
                  <div class="form-group">
                    <label for="projectName">Name</label>
                    <input type="text" name="name" required="required" data-error="Project name is required" class="form-control" id="projectName" aria-describedby="NameHelp" placeholder="Enter Name">
                  </div>
                  <div class="form-group">
                    <label for="projectDescription">Description</label>
                    <textarea type="text" name="description" required="required" data-error="Project description is required" class="form-control" id="projectDescription" placeholder="Enter Description"></textarea>
                  </div>

                  <button type="submit" class="btn btn-primary">Save</button>
                </form>
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
            <a class="btn btn-primary" href="${pageContext.request.contextPath}/logout">Logout</a>
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
          $("#createProjectBtn").click(function () {
              if ($("#createProjectIcon").hasClass("fa-plus-circle")) {
                  $("#createProjectIcon").removeClass("fa-plus-circle");
                  $("#createProjectIcon").addClass("fa-minus-circle");
              } else {
                  $("#createProjectIcon").removeClass("fa-minus-circle");
                  $("#createProjectIcon").addClass("fa-plus-circle");
              }
          });
      })
    </script>

  </div>
</body>

</html>
