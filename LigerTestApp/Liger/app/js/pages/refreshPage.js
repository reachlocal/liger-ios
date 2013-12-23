PAGE.refreshPage = function(){
    REFRESHPAGES.initialize();
	// PAGE.userCanRefresh = true;
 //    PAGE.setupRefresh();
    return true;
}

PAGE.closeDialogArguments = function(args){
	$('#args').append(JSON.stringify(args));
}

PAGE.childUpdates = function(args){
	$('#args').append(JSON.stringify(args));
}

PAGE.refresh = function(user){
	$('#refreshes').append('*');
}

var REFRESHPAGES = {
	
	initialize: function(){
		var me = this;

        me.addBindings();
		
		$('#inits').append('*');
		$('#args').append(JSON.stringify(PAGE.args));
	},

	addBindings: function(){
		$("#closePage, #closeDialog").unbind();

		$("#closePage").click(function(){
			PAGE.closePage();
			return false;
		});

		$("#closeDialog").click(function(){
			PAGE.closeDialog({'dialog': ['closed', 'arguments', 'array']});
			return false;
		});		
	}
}
