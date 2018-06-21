$(document).ready(function() {
    var $validator = $("#provisionform").validate({
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
	    $(element).parents(".col-sm-5").addClass("has-error").removeClass("has-success");
	},
	unhighlight: function(element, errorClass, validClass) {
	    $(element).parents(".col-sm-5").addClass("has-success").removeClass("has-error");
	}
    });
    $("#rootwizard").bootstrapWizard({
        'tabClass': 'nav nav-pills',
        'onNext': function(tab, navigation, index) {
            var $valid = $("#provisionform").valid();
            if (!$valid) {
                $validator.focusInvalid();
                return false;
            }
        },
      'onTabClick': function(tab, navigation, index) {
            var $valid = $("#provisionform").valid();
            if (!$valid) {
                $validator.focusInvalid();
                return false;
            }

        }

    });
    $("#inputForm").on('change', function() {
        if (this.value) {
            $("#tab2").load("/order/dynconfig/"+ this.value);
        }
    });
});
