$(function(){

	// $('#info_box_form').submit(function(e){
	//  	e.preventDefault();
	//  	$("#info_data_processing").show();
	// });

	

    var $datepicker = $('#info_box_datepicker');
    $datepicker.datepicker({
		format: 'yy-mm-dd',
	}).on("show", function() {
		$(this).val("2012-01-02").datepicker('update');
	});
    //$datepicker.datepicker('setDate', last_date);
   
});