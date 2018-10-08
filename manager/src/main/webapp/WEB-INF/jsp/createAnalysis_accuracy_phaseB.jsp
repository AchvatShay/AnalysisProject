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
          <a href="${pageContext.request.contextPath}/projects/${project.getId()}">${project.getName()}</a>
        </li>
      <li class="breadcrumb-item active">
          Accuracy Analysis Phase B
      </li>
      </ol>

      <div class="card mb-3">
        <div class="card-header">
          <i class="fa fa-line-chart"></i> Create new Accuracy Analysis </div>
        <div class="card-body">

        <div class="row">
          <form action="${pageContext.request.contextPath}/projects/${project.getId()}/analysis/accuracy/create" id="addanalysisForm" method="post" class="col-md-12">
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
                      <input type="number" step="any" name="font_size" required="required" data-error="Analysis font size is required" class="form-control" id="analysisVisFontSize" value="14">
                  </div>
                  <div class="form-group">
                      <label for="analysisVisStartTime">visualization start time to plot</label>
                      <input type="number" step="any" name="startTime2plot" required="required" data-error="Analysis start time plot is required" class="form-control" id="analysisVisStartTime" value="1.5">
                  </div>
                  <div class="form-group">
                      <label for="analysisLabels">Analysis Labels : </label>
                        <div id="analysisLabels" class="container-c">
                          <c:forEach var="label_A" items="${labels}">
                              <div class="row checkbox-space">
                                  <label class="checkbox form-check-label">
                                      <input type="checkbox" name="labels" value="${label_A}">${label_A}
                                  </label>
                              </div>
                          </c:forEach>
                        </div>
                  </div>


                  <div class="form-group">
                      <label>Include omissions : </label>
                      <label><input type="radio" name="includeO" value="True">True</label>
                      <label><input type="radio" name="includeO" checked value="False">False</label>
                  </div>

                  <div class="form-group">
                      <label for="DetermineSucFailBy">Determine Success or Failur </label>
                      <select id="DetermineSucFailBy" name="DetermineSucFailBy" class="form-control">
                          <option value="BySuc">By-Success</option>
                          <option value="ByFail">By-Fail</option>
                          <option value="Both">Both</option>
                      </select>
                  </div>

                  <div class="form-group">
                      <label for="bestpcatrajectories2plot">best pca trajectories to plot</label>
                      <input type="number" step="any" name="bestpcatrajectories2plot" required="required" data-error="bestpcatrajectories2plot is required" class="form-control" id="bestpcatrajectories2plot" value="5">
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
                <div class="col-md-3">
                    <div class="form-group">
                        <label for="conf_percent4acc">conf percent for accuracy</label>
                        <input type="number" step="any" name="conf_percent4acc" required="required" data-error="conf_percent4acc is required" class="form-control" id="conf_percent4acc" value="0.05">
                    </div>

                    <div class="form-group">
                        <label for="time4confplot">Time for conf plot</label>
                        <input type="number" step="any" name="time4confplot" required="required" data-error="time4confplot is required" class="form-control" id="time4confplot" value="-2.5">
                    </div>

                    <div class="form-group">
                        <label for="time4confplotNext">Time for conf plot Next</label>
                        <input type="number" step="any" name="time4confplotNext" required="required" data-error="time4confplotNext is required" class="form-control" id="time4confplotNext" value="-2.5">
                    </div>

                    <div class="form-group">
                        <label>linearSVN : </label>
                        <label><input type="radio" name="linearSVN" checked value="True">True</label>
                        <label><input type="radio" name="linearSVN" value="False">False</label>
                    </div>

                    <div class="form-group">
                        <label for="analysisType">Analysis Types : </label>

                        <c:forEach var="analysis_types" items="${analysisTypes}">
                            <div class="row checkbox-space">
                                <label id="analysisType" class="checkbox form-check-label"><input class="form-check-input" type="checkbox" name="types" value="${analysis_types.getId()}">${analysis_types.getName()}</label>
                            </div>
                        </c:forEach>
                    </div>

                    <div class="form-group">
                        <label for="slidingWinLen">SlidingWinLen</label>
                        <input type="number" step="any" name="slidingWinLen" required="required" data-error="slidingWinLen is required" class="form-control" id="slidingWinLen" value="1">
                    </div>

                    <div class="form-group">
                        <label for="slidingWinHop">SlidingWinHop</label>
                        <input type="number" step="any" name="slidingWinHop" required="required" data-error="slidingWinHop is required" class="form-control" id="slidingWinHop" value="0.5">
                    </div>


                    <div class="form-group">
                        <label for="foldsNum">Foldes Num</label>
                        <input type="number" step="any" name="foldsNum" required="required" data-error="Analysis End behave time is required" class="form-control" id="foldsNum" value="10">
                    </div>
                </div>

                    <div class="col-md-6">
                    <div class="form-group border border-dark">
                        <label class="table-analysis-label"><strong>Trials for analysis : </strong></label>
                        <div class="table-responsive space-btn-card" style="margin-top:5%">
                            <table class="table table-bordered dataTableTrials" id="dataTableTrials" width="100%" cellspacing="0">
                                <thead>
                                <tr>
                                    <td><input type="checkbox" name="select_all" value="1" id="dataTableTrials-select-all"></td>
                                    <th>Trial Name</th>
                                    <th>Experiment Name</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="experiment" items="${experiments}">
                                    <c:forEach var="trial" items="${experiment.getTrials()}">
                                        <tr>
                                            <td>
                                                <input name="trialsSelected" type="checkbox" value="${experiment.getId()}_${trial.getId()}">
                                            </td>
                                            <td>${trial.getName()}</td>
                                            <td>${experiment.getName()}</td>
                                        </tr>
                                    </c:forEach>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>

                    </div>
                </div>
            </div>
            <%--</div>--%>
          <div class="row space-btn-card col-md-3">
              <button id="createAnalysisSubmit" type="submit" class="btn btn-primary">Save</button>
          </div>
          </form>
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
            setCheckBox('#dataTableTrials', true);

            $("[name='labels']").each(function () {
                $(this).prop('checked', false);
            });

            $("#addanalysisForm").submit(function() {
                var tableNP = $('#dataTableTrials').DataTable();
                var rowsNP = tableNP.rows({ 'search': 'applied' }).nodes();

                var count_checked_trialsSelected = $("[name='trialsSelected']:checked", rowsNP).length; // count the checked rows


                if(count_checked_trialsSelected == 0)
                {
                    alert("Please select at least one trial for analysis");
                    return false;
                }

                var form = this;

                var table2 = $('#dataTableTrials').DataTable();
                // Iterate over all checkboxes in the table
                table2.$("[name='trialsSelected']").each(function(){
                    // If checkbox doesn't exist in DOM
                    if(!$.contains(document, this)){
                        // If checkbox is checked
                        if(this.checked){
                            // Create a hidden element
                            $(form).append(
                                $('<input>')
                                    .attr('type', 'hidden')
                                    .attr('name', this.name)
                                    .val(this.value)
                            );
                        }
                    }
                });


                $('.loader').show();
                return true; // allow regular form submission
            });
        })
    </script>

  </div>
</body>

</html>
