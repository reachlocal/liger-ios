PAGE.toolbarPage = function(){
    TOOLBARPAGE.initialize();
    return true;
}

PAGE.closeDialogArguments = function(args){
	$('#args').append(JSON.stringify(args));
}

PAGE.childUpdates = function(args){
	$('#args').append(JSON.stringify(args));
}

PAGE.toolbarItems = [{'iconText': 'First', 'callback':"PAGE.args['tab'] = 'first'; TOOLBARPAGE.initialize();"},
					 {'iconText': 'Second', 'callback':"PAGE.args['tab'] = 'second'; TOOLBARPAGE.initialize();"},
					 {'iconText': 'Third', 'callback':"PAGE.args['tab'] = 'third'; TOOLBARPAGE.initialize();"}];

var TOOLBARPAGE = {
	initialize: function(){
		var me = this;

        me.addBindings();
		
		$('#inits').append('*');
		$('#args').append(JSON.stringify(PAGE.args));
	},

	addBindings: function(){
		$("#closePage").unbind();

		$("#closePage").click(function(){
			PAGE.closePage();
			return false;
		});
	}
}
