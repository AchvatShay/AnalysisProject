// Call the dataTables jQuery plugin
$(document).ready(function() {
  $('#dataTable').DataTable();
    $('#dataTableLayers').DataTable();
    $('#dataTableAnimals').DataTable();
    $('#dataTableExperiment').DataTable();
    $('#dataTableAnalysis').DataTable();

    $('#dataTableAnalysisTypes').DataTable();

    $('#dataTableExpTrials').DataTable();
    $(".dataTableNeurons").each(function () {
        var id = this.id;


        var table = $('#' + id).DataTable();


        // Handle click on "Select all" control
        $('#dataTableNeuronsToPlot-select-all').on('click', function(){
            // Get all rows with search applied
            var rows = table.rows({ 'search': 'applied' }).nodes();
            // Check/uncheck checkboxes for all rows in the table
            $("[name='neurons_toPlot']", rows).prop('checked', this.checked);
        });

        $('#dataTableNeuronsForAnalysis-select-all').on('click', function(){
            // Get all rows with search applied
            var rows = table.rows({ 'search': 'applied' }).nodes();
            // Check/uncheck checkboxes for all rows in the table
            $("[name='neurons_forAnalysis']", rows).prop('checked', this.checked);
        });

        // Handle click on checkbox to set state of "Select all" control
        $('#' + id + ' tbody').on('change', "[name='neurons_forAnalysis']", function(){
            // If checkbox is not checked
            if(!this.checked){
                var el = $('#dataTableNeuronsForAnalysis-select-all').get(0);
                // If "Select all" control is checked and has 'indeterminate' property
                if(el && el.checked && ('indeterminate' in el)){
                    // Set visual state of "Select all" control
                    // as 'indeterminate'
                    el.indeterminate = true;
                }
            }
        });

        // Handle click on checkbox to set state of "Select all" control
        $('#' + id + ' tbody').on('change', "[name='neurons_toPlot']", function(){
            // If checkbox is not checked
            if(!this.checked){
                var el = $('#dataTableNeuronsToPlot-select-all').get(0);
                // If "Select all" control is checked and has 'indeterminate' property
                if(el && el.checked && ('indeterminate' in el)){
                    // Set visual state of "Select all" control
                    // as 'indeterminate'
                    el.indeterminate = true;
                }
            }
        });
    });

    $(".dataTableTrialsAccuracy").each(function () {
        var id = this.id;


        var table = $('#' + id).DataTable();

        // Handle click on "Select all" control
        $('#dataTableTrialsAccuracy-select-all').on('click', function(){
            // Get all rows with search applied
            var rows = table.rows({ 'search': 'applied' }).nodes();
            // Check/uncheck checkboxes for all rows in the table
            $("[name='trialsSelected']", rows).prop('checked', this.checked);
        });
    });

    $(".dataTableTrials").each(function () {
        var id = this.id;


        var table = $('#' + id).DataTable();


        // Handle click on "Select all" control
        $('#' + id + '-select-all').on('click', function(){
            // Get all rows with search applied
            var rows = table.rows({ 'search': 'applied' }).nodes();
            // Check/uncheck checkboxes for all rows in the table
            $('input[type="checkbox"]', rows).prop('checked', this.checked);
        });

        // Handle click on checkbox to set state of "Select all" control
        $('#' + id + ' tbody').on('change', 'input[type="checkbox"]', function(){
            // If checkbox is not checked
            if(!this.checked){
                var el = $('#' + id + '-select-all').get(0);
                // If "Select all" control is checked and has 'indeterminate' property
                if(el && el.checked && ('indeterminate' in el)){
                    // Set visual state of "Select all" control
                    // as 'indeterminate'
                    el.indeterminate = true;
                }
            }
        });

    });
});
