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

  <link href="${pageContext.request.contextPath}/resources/css/analysis-custom.css" rel="stylesheet">
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
              <span class="nav-link nav-link-text">Welcome - ${current_user}</span>
            </li>
            <li class="nav-item">
                  <a class="nav-link" data-toggle="modal" data-target="#exampleModal">
                      <i class="fa fa-fw fa-sign-out"></i>Logout</a>
              </li>
          </ul>
      </div>
  </nav>
    <div class="container-fluid rapper">
      <div class="loader" style="display: none"></div>

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
          <a href="${pageContext.request.contextPath}/projects/${experiment.getProject().getId()}">${experiment.getProject().getName()}</a>
        </li>
        <li class="breadcrumb-item active">
          <a href="${pageContext.request.contextPath}/projects/${experiment.getProject().getId()}/experiments/${experiment.getId()}">${experiment.getName()}</a>
        </li>
      </ol>

      <div class="card mb-3">
        <div class="card-header">
          <i class="fa fa-line-chart"></i> Create new Analysis for experiment - ${experiment.getName()}</div>
        <div class="card-body">

        <%--<div class="row">--%>
          <form action="${pageContext.request.contextPath}/projects/${experiment.getProject().getId()}/analysis" id="addanalysisForm" method="post">
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
              </div>
              <div class="col-md-3">
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
                  <label for="startBehaveTime4trajectory">Start behave time for trajctory</label>
                  <input type="number" step="any" name="startBehaveTime4trajectory" required="required" data-error="Analysis Start behave time is required" class="form-control" id="startBehaveTime4trajectory" placeholder="Enter start behave time">
                </div>
                <div class="form-group">
                  <label for="endBehaveTime4trajectory">End behave time for trajctory</label>
                  <input type="number" step="any" name="endBehaveTime4trajectory" required="required" data-error="Analysis End behave time is required" class="form-control" id="endBehaveTime4trajectory" placeholder="Enter end behave time">
                </div>
                <div class="form-group">
                  <label for="foldsNum">Foldes Num</label>
                  <input type="number" step="any" name="foldsNum" required="required" data-error="Analysis End behave time is required" class="form-control" id="foldsNum" placeholder="Enter foldes num">
                </div>
              </div>
              <div class="col-md-3">
                <div class="form-group">
                  <label for="analysisType">Analysis Types : </label>

                  <c:forEach var="analysis_types" items="${analysisTypes}">
                    <div class="row checkbox-space">
                      <label id="analysisType" class="checkbox form-check-label"><input class="form-check-input" type="checkbox" name="types" value="${analysis_types.getId()}">${analysis_types.getName()}</label>
                    </div>
                  </c:forEach>
                </div>
                  <div class="form-group">
                      <label for="experimentEvents">Experiments Events To Plot : </label>

                      <c:forEach var="experimentEvent" items="${experimentEvents}">
                          <div class="row checkbox-space">
                            <label id="experimentEvents" class="form-check-label checkbox"><input class="form-check-input" type="checkbox" name="events" value="${experimentEvent.getId()}">${experimentEvent.getName()}</label>
                          </div>
                      </c:forEach>
                  </div>
              </div>

            </div>

            <input id="trailsAnalysisExperiment" type="number" name="experiment_id" hidden="hidden" value="${experiment.getId()}"/>

            <div class="row space-btn-card">
              <%--<div class="col-md-6">--%>
                  <div  id="trials${experiment.getId()}" class="col-md-12">
                    <div class="row">
                    <div class="col-md-6">
                      <div class="form-group space-btn-card border border-dark">
                        <label class="table-analysis-label"><strong>Neurons To Plot : </strong></label>
                        <div class="table-responsive space-btn-card" style="margin-top:5%">
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
                      <div class="form-group border border-dark">
                        <label class="table-analysis-label"><strong>Neurons For Analysis : </strong></label>
                      <div class="table-responsive space-btn-card" style="margin-top:5%">
                        <table class="table table-bordered dataTableTrials" id="dataTableNeuronsForAnalysis${experiment.getId()}" width="100%" cellspacing="0">
                          <thead>
                          <tr>
                            <td><input type="checkbox" name="select_all" value="1" id="dataTableNeuronsForAnalysis${experiment.getId()}-select-all"></td>
                            <th>Neuron Name</th>
                          </tr>
                          </thead>
                          <tbody>
                          <c:forEach var="neuron" items="${neurons}">
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
                     <div class="form-group border border-dark">
                       <label class="table-analysis-label"><strong>Trials for analysis : </strong></label>
                        <div class="table-responsive space-btn-card" style="margin-top:5%">
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

              <%--</div>--%>
            </div>
          <div class="row space-btn-card col-md-3">
              <button id="createAnalysisSubmit" type="submit" class="btn btn-primary">Save</button>
          </div>
          </form>
        <%--</div>--%>


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
            // $('.loader').hide();
            <c:forEach var="experiment_val" items="${project.getExperiments()}">
                $('#trials' + ${experiment_val.getId()}).hide();
            </c:forEach>

            var before = $("#trailsAnalysisExperiment").val();


            setCheckBox('#dataTableNeuronsToPlot' + before, false);

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
                setCheckBox('#dataTableNeuronsToPlot' + id_val, false);

                setCheckBox('#dataTableNeuronsForAnalysis' + id_val, true);

                setCheckBox('#dataTableTrials' + id_val, true);

                before = id_val;
            });

            $("#addanalysisForm").submit(function() {
                var count_checked_types = $("[name='types']:checked").length; // count the checked rows
                var count_checked_neuronsAnalysis = $("[name='neurons_forAnalysis']:checked").length; // count the checked rows
                var count_checked_trialsSelected = $("[name='trialsSelected']:checked").length; // count the checked rows

                if(count_checked_types == 0)
                {
                    alert("Please select at least one type for analysis");
                    return false;
                }

                if(count_checked_neuronsAnalysis == 0)
                {
                    alert("Please select at least one neuron for analysis");
                    return false;
                }


                if(count_checked_trialsSelected == 0)
                {
                    alert("Please select at least one trial for analysis");
                    return false;
                }


                $('.loader').show();
                return true; // allow regular form submission
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

        })
    </script>

  </div>
</body>

</html>
