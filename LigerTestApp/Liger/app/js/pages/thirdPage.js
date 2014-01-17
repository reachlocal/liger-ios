PAGE.thirdPage = function(){
    THIRDPAGE.initialize();
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

var THIRDPAGE = {
	
	initialize: function(){
		var me = this;

        me.addBindings();
		
		$('#inits').append('*');
		$('#args').append(JSON.stringify(PAGE.args));
	},

	addBindings: function(){
		$("#closePage, #closeToPage, #updateParent, #updateParentPage, #openDialog, #openDialogWithTitle").unbind();

		$("#closePage").click(function(){
			PAGE.closePage();
			return false;
		});

		$("#closeToPage").click(function(){
			PAGE.closeToPage('firstPage');
			return false;
		});
		
		$("#updateParent").click(function(){
			PAGE.updateParent({'child1': 'child2'});
			return false;
		});
		
		$("#updateParentPage").click(function(){
			PAGE.updateParentPage('firstPage', {'child3': 'child4'});
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
