// Container for all custom liger cordova plugin functions
var LIGER = {
	openPage: function(title, page, args) {
		cordova.exec(null, null, "Liger", "openPage", [ title, page, args ]);
	},

	closePage: function() {
		cordova.exec(null, null, "Liger", "closePage", []);
	},

	closeToPage: function(page) {
		cordova.exec(null, null, "Liger", "closePage", [page]);
	},

	updateParent: function(args) {
		cordova.exec(null, null, "Liger", "updateParent", [null, args]);
	},

	updateParentPage: function(page, args) {
		cordova.exec(null, null, "Liger", "updateParent", [page, args]);
	},

	childUpdates: function(args){
		PAGE.childUpdates(args);
	},
	
	openPageArguments: function(args) {
		PAGE.args = args;
	},

	getPageArgs: function(){
		cordova.exec(
			function(args){ 
				PAGE.gotPageArgs(args);
			}, 
			function(error) { 
				return false;
			}, "Liger", "getPageArgs", []);
	},

	openDialog: function(page, args){
		cordova.exec(null, null, "Liger", "openDialog", [ page, args ]);
	},

	openDialogWithTitle: function(title, page, args) {
		cordova.exec(null, null, "Liger", "openDialogWithTitle", [ title, page, args ]);
	},

	closeDialog: function(args) {
		cordova.exec(null, null, "Liger", "closeDialog", [args]);
	},

	closeDialogArguments: function(args){
        PAGE.closeDialogArguments(args);
	},
	
	toolbar: function(items) {
		cordova.exec(null, null, "Liger", "toolbar", [items]);
	},

	userCanRefresh: function(userCanRefresh) {
		cordova.exec(null, null, "Liger", "userCanRefresh", [userCanRefresh]);
	}
};
