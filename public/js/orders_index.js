$(document).ready(function() {
    $('#ordertable').dataTable();
    $('#order_form').hide();
    $('#order_add_btn').click(function() {
	$('#order_form').show();
    });


} );
