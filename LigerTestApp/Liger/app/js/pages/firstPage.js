PAGE.firstPage = function(){
    FIRSTPAGE.initialize();
    return true;
}

PAGE.closeDialogArguments = function(args){
	$('#args').append(JSON.stringify(args));
}

PAGE.childUpdates = function(args){
	$('#args').append(JSON.stringify(args));
}

PAGE.onPageAppear = function(){
	$('#pageAppear').append('*');
}

var FIRSTPAGE = {
	
	initialize: function(){
		var me = this;

        me.addBindings();
		
		$('#inits').append('*');
		$('#args').append(JSON.stringify(PAGE.args));
	},

	addBindings: function(){
		$("#openPage, #refreshPage, #toolbarPage, #openDialog, #openDialogWithTitle").unbind();
        
        $("#openPage").click(function(){
			PAGE.openPage('Second Page', 'secondPage', {'test1': 'test2'});
			return false;
        });

		$("#refreshPage").click(function(){
			PAGE.openPage('Refresh Page', 'refreshPage', {});
			return false;
		});

		$("#toolbarPage").click(function(){
			PAGE.openPage('Toolbar Page', 'toolbarPage', {});
			return false;
		});

		$("#openDialog").click(function(){
			PAGE.openDialog('dialog', {'dialogtest1': 'dialogtest2'});
			return false;
		});

		$("#openDialogWithTitle").click(function(){
			PAGE.openDialogWithTitle('Dialog Page', 'dialog', {'dialogtest3': 'dialogtest4'});
			return false;
		});
		
	}
}
