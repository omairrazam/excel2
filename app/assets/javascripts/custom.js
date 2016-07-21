$(function(){

	// $('#info_box_form').submit(function(e){
	// 	e.preventDefault();
	// 	$.get(this.action, $(this).serialize(),null,script);
		
	// });


	$('input[type=radio][name=machine]').change(function() {
        $("form#machine_form").submit();
    });

    $( "#datepicker" ).datepicker();
    $( "#datepicker" ).datepicker( "option", "dateFormat", "yy-mm-dd" );
});