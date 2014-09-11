// Container for all custom liger cordova plugin functions
var LIGER = {
	openPage: function(title, page, args, options) {
		if (options === undefined){
			options = {};
		}
		cordova.exec(null, null, "Liger", "openPage", [ title, page, args, options ]);
		window.webkit.messageHandlers.openPage.postMessage([page, title, args, options]);
	},

	closePage: function() {
		cordova.exec(null, null, "Liger", "closePage", []);
		window.webkit.messageHandlers.closePage.postMessage([]);
	},

	closeToPage: function(page) {
		cordova.exec(null, null, "Liger", "closePage", [page]);
		window.webkit.messageHandlers.closePage.postMessage([page]);
	},

	updateParent: function(args) {
		cordova.exec(null, null, "Liger", "updateParent", [null, args]);
		window.webkit.messageHandlers.updateParent.postMessage(["", args]);
	},

	updateParentPage: function(page, args) {
		cordova.exec(null, null, "Liger", "updateParent", [page, args]);
		window.webkit.messageHandlers.updateParent.postMessage([page, args]);
	},

	getPageArgs: function(){
		cordova.exec(
			function(args){ 
				PAGE.gotPageArgs(args);
			}, 
			function(error) { 
				return false;
			}, "Liger", "getPageArgs", []);
		window.webkit.messageHandlers.getPageArgs.postMessage([]);
	},

	openDialog: function(page, args, options){
		if (options === undefined){
			options = {};
		}
		cordova.exec(null, null, "Liger", "openDialog", [ page, args, options ]);
		window.webkit.messageHandlers.openDialog.postMessage([page, "", args, options]);

	},

	openDialogWithTitle: function(title, page, args, options) {
		if (options === undefined){
			options = {};
		}
		cordova.exec(null, null, "Liger", "openDialogWithTitle", [ title, page, args, options ]);
		window.webkit.messageHandlers.openDialog.postMessage(["navigator", "", {title:title, page:page, args:args, options:options}, {}]);
	},

	closeDialog: function(args) {
		cordova.exec(null, null, "Liger", "closeDialog", [args]);
		window.webkit.messageHandlers.closeDialog.postMessage([args]);
	},

	toolbar: function(items) {
		cordova.exec(null, null, "Liger", "toolbar", [items]);
		window.webkit.messageHandlers.toolbar.postMessage([items]);
	},

	userCanRefresh: function(userCanRefresh) {
		cordova.exec(null, null, "Liger", "userCanRefresh", [userCanRefresh]);
	}
};
