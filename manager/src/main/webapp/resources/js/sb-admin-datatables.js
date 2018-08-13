// Call the dataTables jQuery plugin
$(document).ready(function() {
  $('#dataTable').DataTable();
    $('#dataTableLayers').DataTable();
    $('#dataTableAnimals').DataTable();
    $('#dataTableExperiment').DataTable();
    $('#dataTableAnalysis').DataTable();

    $('#dataTableAnalysisTypes').DataTable();

    $('#dataTableExpTrials').DataTable();
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

        // Handle form submission event
        $('#addanalysisForm').on('submit', function(e){
            var form = this;

            // Iterate over all checkboxes in the table
            table.$('input[type="checkbox"]').each(function(){
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
        });

    });
});
