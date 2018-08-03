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
  <link href="../../resources/vendor/bootstrap-4.0.0/css/bootstrap.min.css" rel="stylesheet">
  <link href="../../resources/vendor/bootstrap-4.0.0/css/bootstrap-reboot.min.css" rel="stylesheet">
  <link href="../../resources/vendor/bootstrap-4.0.0/css/bootstrap-grid.min.css" rel="stylesheet">
  <!-- Custom fonts for this template-->
  <link href="../../resources/vendor/fontawesome-5.2.0/css/fontawesome.min.css" rel="stylesheet" type="text/css">

  <link href="../../resources/vendor/fontawesome-5.2.0/css/solid.min.css" rel="stylesheet" type="text/css">

  <link href="../../resources/vendor/fontawesome-5.2.0/css/v4-shims.min.css" rel="stylesheet" type="text/css">
  <!-- Page level plugin CSS-->
  <link href="../../resources/vendor/datatables/dataTables.bootstrap4.css" rel="stylesheet">
  <!-- Custom styles for this template-->
  <link href="../../resources/css/sb-admin.css" rel="stylesheet">
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
          <a href="/" class="elements">Analysis System</a>
        </li>
        <li class="breadcrumb-item active">
          <a href="/projects">My Projects</a>
        </li>
        <li class="breadcrumb-item active">
          <a href="/project/${analysis.getProject().getId()}">${analysis.getProject().getName()}</a>
        </li>
        <li class="breadcrumb-item active">
          ${analysis.getName()}
        </li>
      </ol>

      <div class="row">
        <div class="col-12">
          <h1>Analysis ${analysis.getName()} results</h1>
          <p>${analysis.getDescription()}</p>

          <div id="myCarousel" class="carousel slide align-self-center" data-ride="carousel">
            <!-- Indicators -->
            <ol class="carousel-indicators" id="slidPicOL">
              <%
                int count1 = 0;
              %>
              <c:forEach var="tifFile" items="${tif}">
                <%
                  if (count1 == 0)
                  { %>
                    <li data-target="#myCarousel" data-slide-to="" class="li-carousel active"></li>
                  <%
                  } else { %>
                <li data-target="#myCarousel" data-slide-to="" class="li-carousel"></li>
                 <% }
                 count1++;
                %>
              </c:forEach>
            </ol>

            <!-- Wrapper for slides -->
            <%
              count1 = 0;
            %>
            <div class="carousel-inner align-self-center" role="listbox" style="left: 25%;">
              <c:forEach var="tifFile" items="${analysis.getAllTifResults()}">
                <%
                  if (count1 == 0)
                  { %>
                <div class="carousel-item active">
                  <img src="../../resources/analysis_results/${tifFile.getName()}">
                </div>
                <%
                } else { %>
                  <div class="carousel-item">
                    <img src="../../resources/analysis_results/${tifFile.getName()}">
                  </div>
                  <% }

                  count1++;
                %>
              </c:forEach>
            </div>

            <!-- Left and right controls -->
            <a class="carousel-control-prev" href="#myCarousel" role="button" data-slide="prev">
              <span class="fa fa-angle-left" style="color: black;font-size: 32px;" aria-hidden="true"></span>
              <span class="sr-only">Previous</span>
            </a>
            <a class="carousel-control-next" href="#myCarousel" role="button" data-slide="next">
              <span class="fa fa-angle-right" style="color: black;font-size: 32px;" aria-hidden="true"></span>
              <span class="sr-only">Next</span>
            </a>
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

    <script src="../../resources/vendor/jquery/jquery.min.js"></script>
    <script src="../../resources/vendor/bootstrap-4.0.0/js/bootstrap.bundle.min.js"></script>
    <!-- Core plugin JavaScript-->
    <script src="../../resources/vendor/jquery-easing/jquery.easing.min.js"></script>
    <!-- Page level plugin JavaScript-->
    <script src="../../resources/vendor/chart.js/Chart.min.js"></script>
    <script src="../../resources/vendor/datatables/jquery.dataTables.js"></script>
    <script src="../../resources/vendor/datatables/dataTables.bootstrap4.js"></script>
    <!-- Custom scripts for all pages-->
    <script src="../../resources/js/sb-admin.min.js"></script>
    <!-- Custom scripts for this page-->
    <script src="../../resources/js/sb-admin-datatables.min.js"></script>
    <script src="../../resources/js/sb-admin-charts.min.js"></script>

    <script>
      $(document).ready(function () {
          var c = 0;

          $(".li-carousel").each(function () {
              $(this).attr("data-slide-to", c.toString());
              c = c + 1;
          });

          if (c == 0)
          {
            $("#myCarousel").attr("hidden", "hidden");
          }
      });
    </script>

  </div>
</body>

</html>
