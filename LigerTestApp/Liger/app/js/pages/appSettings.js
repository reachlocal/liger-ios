PAGE.appSettings = function(){
    APPSETTINGS.initialize();
    return true;
}

PAGE.headerButtonTapped = function(button){
	PAGE.closeDialog({button: button});
}

var APPSETTINGS = {
	initialize: function(){
		var me = this;

        me.addBindings();
	},

	addBindings: function(){
	}
}
