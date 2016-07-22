$(function(){

	$('#info_box_form').submit(function(e){
	 	e.preventDefault();
	 	$("#info_data_processing").show();
	});

	$('input[type=radio][name=machine]').change(function() {
        $("form#machine_form").submit();
    });

   // $( "#datepicker" ).datepicker();
    //$( "#datepicker" ).datepicker( "option", "dateFormat", "yy-mm-dd" );

    $("#info_box_datepicker").datepicker({
		format: 'yy-mm-dd',
	}).on("show", function() {
		$(this).val("2012-01-02").datepicker('update');
	});

	
});