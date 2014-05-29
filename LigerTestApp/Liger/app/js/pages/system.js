PAGE.system = function(){
    SYSTEM.initialize();
    return true;
}

PAGE.closeDialogArguments = function(args){
	if(args['URL']) {
		$('#inline_image').attr('src', args['URL']);
	}
	$('#args').append(JSON.stringify(args));
}

PAGE.childUpdates = function(args){
	$('#args').append(JSON.stringify(args));
}

var SYSTEM = {
	
	initialize: function(){
		var me = this;

        me.addBindings();
		
		$('#inits').append('*');
		$('#args').append(JSON.stringify(PAGE.args));
	},

	addBindings: function(){
		$("#browser,#mail,#message,#image,#twitter,#facebook,#sinaweibo,#tencentweibo").unbind();

        $("#browser").click(function(){
			PAGE.openDialogWithTitle('Browser', 'browser', {link: "http://daringfireball.net", allowZoom:true},
				{
					"left":{"button":"done"},
					"right":{"button":"save"}
				});
			return false;
        });
		
		$("#email").click(function (){
			var args = {'subject': 'mail test',
			'body': 'Hi,\n\nWe are testing emails.\n\n//Me',
			'toRecipients': 'to@test.com',
			'ccRecipients': 'cc@test.com',
			'bccRecipients': 'bcc@test.com',
			'html': false };
			PAGE.openDialogWithTitle('Email', 'email', args);
			return false;
		});

		
		$("#message").click(function (){
			var args = {'subject': 'message test',
			'body': 'Hi,\n\nWe are testing messages.\n\n//Me'};
			PAGE.openDialogWithTitle('Message', 'message', args);
			return false;
		});

		$("#image").click(function (){
			var args = {};
			PAGE.openDialogWithTitle('Image', 'image', args);
			return false;
		});

		$("#twitter").click(function (){
			var args = {'text': 'Hello, we are testing twitter'};
			PAGE.openDialogWithTitle('Twitter', 'twitter', args);
			return false;
		});

		$("#facebook").click(function (){
			var args = {'text': 'Hello, we are testing facebook'};
			PAGE.openDialogWithTitle('Facebook', 'facebook', args);
			return false;
		});

		$("#sinaweibo").click(function (){
			 var args = {'text': 'Hello, we are testing sina weibo'};
			 PAGE.openDialogWithTitle('Sina Weibo', 'sinaweibo', args);
			 return false;
		 });

		$("#tencentweibo").click(function (){
			var args = {'text': 'Hello, we are testing tencent weibo'};
			PAGE.openDialogWithTitle('Tencent Weibo', 'tencentweibo', args);
			return false;
		});
	}
}
