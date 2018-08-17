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
  <link href="${pageContext.request.contextPath}/resources/css/gallery.css" rel="stylesheet">
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
  <!-- Custom styles for this template-->
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
        <li class="nav-item">
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
        <li class="nav-item">
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

      <div class="loader"></div>

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
          <a href="${pageContext.request.contextPath}/" class="elements">Analysis System</a>
        </li>
        <li class="breadcrumb-item active">
          <a href="${pageContext.request.contextPath}/projects">My Projects</a>
        </li>
        <li class="breadcrumb-item active">
          <a href="${pageContext.request.contextPath}/projects/${analysis.getExperiment().getProject().getId()}">${analysis.getExperiment().getProject().getName()}</a>
        </li>
        <li class="breadcrumb-item active">
          ${analysis.getName()}
        </li>
      </ol>

      <div class="row">
        <div class="col-12">

          <div class="col-md-5">
            <div class="card mb-3">
              <div class="card-header">
                <i class="fa fa-info-circle"></i> Analysis info</div>
              <div class="card-body">
                <div class="row">
                  <div class="col-md-3 card-text space-btn-card">Description : </div>
                  <div class="col-md-5 card-text">${analysis.getDescription()} </div>
                </div>
              </div>
            </div>
          </div>

          <c:if test="${tif != null and !tif.isEmpty()}">
          <div class="col-md-12">
            <div class="card text-center">
            <div class="card-header">
              <ul class="nav nav-tabs card-header-tabs" id="mainType">

                <c:forEach var="tif_map" items="${tif}">
                  <li class="nav-item">
                    <a class="nav-link btn clickType" id="click${tif_map.key.getName()}">${tif_map.key.getName()}</a>
                  </li>
                </c:forEach>
              </ul>
            </div>

            <c:forEach var="tif_map" items="${tif}">
              <div id="${tif_map.key.getName()}" class="card-body">
                <div class="gallery" id="gallery">
                  <c:forEach var="tifFile" items="${tif_map.value}">
                    <div class="mb-3 pics animation ">
                      <img class="img-fluid" data-toggle="tooltip" data-placement="right" title="${tifFile.getFileName()}" src="${pageContext.request.contextPath}/resources/AnalysisResults/${tifFile.getUserName()}/${tifFile.getProjectName()}/${tifFile.getAnalysisName()}/${tifFile.getAnalysisType()}/${tifFile.getFileName()}${tifFile.getFileEnd()}">
                      <a class="btn-floating btn-large" href="${pageContext.request.contextPath}/projects/${analysis.getExperiment().getProject().getId()}/analysis/${analysis.getId()}/download/${tifFile.getUserName()}/${tifFile.getProjectName()}/${tifFile.getAnalysisName()}/${tifFile.getAnalysisType()}/${tifFile.getFileName()}">
                        <i class="fa fa-file-download"></i>
                      </a>
                    </div>
                  </c:forEach>
                </div>
              </div>
            </c:forEach>
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
        $(window).on('load', function(){
            $('.loader').hide();
        });

        $(document).ready(function () {
            var count = 0;
            var currentType;
            <c:forEach var="tif_map" items="${tif}">
              if (count == 0) {
                  $('#${tif_map.key.getName()}').show();
                  $('#click${tif_map.key.getName()}').addClass("active")
                  count = count + 1;
                  currentType = '${tif_map.key.getName()}';
              } else {
                  $('#${tif_map.key.getName()}').hide();
              }
            </c:forEach>

            $('#mainType .clickType').click(function () {
                   var newType = this.text;
                   if ($('#click' + currentType).hasClass("active"))
                   {
                       $('#click' + currentType).removeClass("active");
                   }

                $('#click' + newType).addClass("active");

                $('#' + currentType).hide();
                   $('#' + newType).show();
                   currentType = newType;
            });

        });
    </script>

  </div>
</body>

</html>
