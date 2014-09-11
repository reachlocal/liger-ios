PAGE.dialog = function(){
    DIALOG.initialize();
    return true;
}

PAGE.closeDialogArguments = function(args){
	$('#args').append(JSON.stringify(args));
}

PAGE.childUpdates = function(args){
	$('#args').append(JSON.stringify(args));
}

PAGE.headerButtonTapped = function(button){
	PAGE.closeDialog({button: button});
}

var DIALOG = {
	
	initialize: function(){
		var me = this;

        me.addBindings();
		
		$('#inits').append('*');
		$('#args').append(JSON.stringify(PAGE.args));
	},

	addBindings: function(){
		$("#updateParent, #updateParentPage, #closeDialog, #closeDialogReset").unbind();

		
		$("#updateParent").click(function(){
			PAGE.updateParent({'child1': 'child2'});
			return false;
		});
		
		$("#closeDialog").click(function(){
			PAGE.closeDialog({'dialog': ['closed', 'the', 'dialog']});
			return false;
		});
		
		$("#closeDialogReset").click(function(){
			PAGE.closeDialog({"resetApp": true});
			return false;
		});
		
	}
}
