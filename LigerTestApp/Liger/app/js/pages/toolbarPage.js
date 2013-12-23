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

PAGE.toolbarItems = [{'iconText': 'First', 'callback':"alert('First');"},
					 {'iconText': 'Second', 'callback':"alert('Second');"},
					 {'iconText': 'Third', 'callback':"alert('Third');"}];

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
