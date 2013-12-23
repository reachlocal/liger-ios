#import "gsautomation.js"

var openPage = {
	backbutton: [["tap", "((ScrollView))::((WebView))::Open Page"],
			   ["tap", "((NavigationBar))::Pages"]
],
	backbuttonTwice: [["tap", "((ScrollView))::((WebView))::Open Page"],
				["tap", "((ScrollView))::((WebView))::Open Page"],
				["tap", "((NavigationBar))::Page"],
				["tap", "((NavigationBar))::Pages"]
],	  
	closePage: [["tap", "((ScrollView))::((WebView))::Open Page"],
				["tap", "((ScrollView))::((WebView))::Close Page"]
],	  
	closePageTwice: [["tap", "((ScrollView))::((WebView))::Open Page"],
				["tap", "((ScrollView))::((WebView))::Open Page"],
				["tap", "((ScrollView))::((WebView))::Close Page"],
				["tap", "((ScrollView))::((WebView))::Close Page"]
]	  
}

var openDialog = {
	closeDialog: [["tap", "((ScrollView))::((WebView))::Open Dialog"],
				  ["tap", "((ScrollView))::((WebView))::Close Dialog"]
]
}

var openDialogWithTitle = {
	closeDialog: [["tap", "((ScrollView))::((WebView))::Open Dialog With Title"],
				  ["tap", "((ScrollView))::((WebView))::Close Dialog"]
]
}

function runTest(suite, test) {
	UIALogger.logStart(suite + "::" + test);
	performTask(suite[test]);
	displayResult();
}

function main() {
	runTest(openPage, "backbutton");
	runTest(openPage, "backbuttonTwice");
	runTest(openPage, "closePage");
	runTest(openPage, "closePageTwice");
	
	runTest(openDialog, "closeDialog");
	
	runTest(openDialogWithTitle, "closeDialog");
}

main();
