$(document).ready(function(){
    $("#addfieldbtn").click(function(){
        var fieldname = $("#fieldname").val();
        $("#customfields").append("<div class=\"form-group\" id=\""+ fieldname +"row\"><input type=\"hidden\" name=\"field." + fieldname +"\" value=\"string\"><label class=\"col-md-2\">"+ fieldname +"</label><div class=\"col-sm-2\"><button type=\"button\" id=\""+ fieldname +"\" class=\"removalbutton btn btn-danger\">Remove</button></div></div>");
    });

});

$(document).on("click", ".removalbutton", function(event){
    var target = event.target.id;
    $("#"+ target +"row").remove();
});
