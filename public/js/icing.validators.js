    $(function() {
	$.validator.addMethod('IP4Checker', function(value) {
	    var ip = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$";
	return value.match(ip);
    }, 'Invalid IP address');
    });
    $(function() {
	$.validator.addMethod('IP4NetChecker', function(value) {
	    var net = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\/[0-9]+$";
	    return value.match(net);
	}, 'Invalid IP network');
    });
    $(function() {
	$.validator.addMethod('zipcityChecker', function(value) {
	    var zipcity = "^[0-9]{4}.*$";
	    return value.match(zipcity);
	}, 'Invalid zipcode');
    });
    $(function() {
	$.validator.addMethod('InterfaceChecker', function(value) {
	    var interface = "^(GigabitEthernet([0-9]+\/[0-9]+)|TenGigabitEthernet([0-9]+\/[0-9]+)|TenGigE([0-9]+\/[0-9]+\/[0-9]+\/[0-9]+)|Vlan|Bundle-Ether([0-9]+)|GigabitEthernet([0-9]+\/[0-9]+\/[0-9]+)|GigabitEthernet([0-9]+\/[0-9]+\/[0-9]+\/[0-9]+)|(?:xe|ge)-([0-9]+\/[0-9]+\/[0-9]+))$";
	    return value.match(interface);
	}, "Invalid Interface");
    });
    $(function() {
	$.validator.addClassRules({
	    validatevlan: {
            range: [1, 4094]
        },
        validatecidrv4: {
            IP4NetChecker: true
        },
        validateipv4: {
            IP4Checker: true
        },
        validateasn: {
            range: [1, 4294967296]
        },
        validatezipcity: {
            zipcityChecker: true
        },
        validateinterface: {
            InterfaceChecker: true
        },
        validatespeed: {
            range: [1, 100000]
        }
    })
});
