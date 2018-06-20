$(document).ready(function(){
    $("#addfieldbtn").click(function(){
        var fieldname = $("#fieldname").val();
        if ($("#" + fieldname +"row").length) {
            $("#errormsg").html("<em class=\"has-error\">Duplicate name</em>");
        }
        else {
            $("#errormsg").html("")
            $("#customfields").append("<div class=\"col-md\" id=\""+ fieldname +"row\"><input type=\"hidden\" name=\"field." + fieldname +"\" value=\"string\" class=\"customfield\"><div class=\"col-sm-2\"><input class=\"form-control\" disabled=\"disabled\" type=\"text\" value=\""+ fieldname +"\"><button type=\"button\" id=\""+ fieldname +"\" class=\"removalbutton btn btn-danger btn-xs\">Remove</button></div></div>");
        }
            $("#fieldname").val("");
            $("#fieldname").focus();
    });



    $("#inventoryform").validate({
	errorElement: "em",
	errorPlacement: function(error, element) {
	    // Add the help-block class to the error element
	    error.addClass("help-block");

	    if (element.prop("type") === "checkbox") {
		error.insertAfter(element.parent("label"));
	    } else {
		error.insertAfter(element);
	    }
	},
	highlight: function(element, errorClass, validClass) {
	    $(element).parents(".col-sm-2").addClass("has-error").removeClass("has-success");
	},
	unhighlight: function(element, errorClass, validClass) {
	    $(element).parents(".col-sm-2").addClass("has-success").removeClass("has-error");
	}
    });


    $("#inventoryform").submit(function(event){
        if ($(".customfield").length) {
            return;
        }
        else {
            $("#errormsg").html("<em class=\"has-error\">Must have at least one field</em>");
            event.preventDefault();
        }
    });




});

$(document).on("click", ".removalbutton", function(event){
    var target = event.target.id;
    $("#"+ target +"row").remove();

});
