# Prerequisites

1. A modern mac with a recent version of OS X installed, preferably the latest.
2. Install the latest version of Xcode from the app store (Hint: Avoid using betas unless you have a specific reason to do so).
3. Install [Cocoapods](http://cocoapods.org). A common way to deal with ruby and gems is [RVM](https://rvm.io) which we use when developing Liger itself.

# Create a project

Create a new iOS Empty Application Xcode project and give it a name. This is the name will show up in the app store and under your app icon. This is also part of the identifier for your iOS app (com.yourcompany.yournewawesomeapp) which you will be using for certificates. Choose wisely.

Make sure you created an empty application and not an empty project, as going forward you won't succeed. Don't worry if you did though, just throw away the project and create a new one.

When the app is created and everything is done, close the project. You will more or less never again open it up. After you've created your podfile and installed your pods, you will use a workspace instead. This workspace includes the project you just created, as well as your pod's project.

# The Podfile
## Add Liger to your Podfile

If you don't already have a Podfile create one by running this in a terminal:

    cd your_project_folder
    pod init

Open your Podfile and add in liger. Some prefer adding it per target, others just at the top of the file. You should end up with something like this:

    # Uncomment this line to define a global platform for your project
    # platform :ios, "6.0"

    target "YourFancyApp" do
        pod 'liger'
    end

    target "YourFancyAppTests" do

    end

or

    # Uncomment this line to define a global platform for your project
    platform :ios, "6.1"

    pod 'liger'

    target "YourFancyAppTests" do

    end


## Install the pods

Time to install your pods. Do that as follows:

    cd your_project_folder
    pod install

This creates a workspace (if you don't already had one) and installs all the pods in your Podfile as well as any dependencies.

# Prep the app

Open up your *xcworkspace*. It should be named something like YourFancyApp.xcworkspace. A tip is to clear your recently opened list in Xcode to avoid opening the project.

## The app delegate

You've got two options. The easiest is to use Liger's app delegate straight up, and the slightly more advanced option is to inherit from it (and always make sure you call the superclass' implementation if you overload a method). But why use the more advanced option? Basically if you use a 3rd party library or some home grown software that you want to start up or have react to events coming into the app delegate. Pretty common examples would be logging/reporting such as [Flurry](http://www.flurry.com), [Crashalytics](https://crashlytics.com), [Testflight's SDK](https://www.testflightapp.com), etc.

If that's not the case you can go with the easy version. Simply open up your *main.m* and replace the name of your app delegate with *LGRAppDelegate*. Going from something like this:

    //
    //  main.m
    //  FancyApp
    //
    //  Created by John Gustafsson on 12/2/13.
    //  Copyright (c) 2013 John Gustafsson. All rights reserved.
    //

    #import <UIKit/UIKit.h>

    #import "AppDelegate.h"

    int main(int argc, char * argv[])
    {
        @autoreleasepool {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
    }

to this:

    //
    //  main.m
    //  FancyApp
    //
    //  Created by John Gustafsson on 12/2/13.
    //  Copyright (c) 2013 John Gustafsson. All rights reserved.
    //

    #import <UIKit/UIKit.h>

    #import "LGRAppDelegate.h"

    int main(int argc, char * argv[])
    {
        @autoreleasepool {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([LGRAppDelegate class]));
        }
    }

*Hint* the difference is the #import (now importing *LGRAppDelegate* instead of your own *AppDelegate* (or similar)) and the name of the class inside of _NSStringFromClass_.

# Add config.xml

Liger is currently using Cordova to send messages between the web views and the native portions. Cordova is included as a dependency in the liger cocoapod so you will get the same version as we have. You do on the other hand have to supply a *config.xml* file. Using this as a template save it as a file named *config.xml* and include it in your project. If you feel uncertain about how files are added to Xcode, [read our Xcode folders tutorial](./xcodefolders.md).

    <?xml version="1.0" encoding="UTF-8"?>
    <widget xmlns     = "http://www.w3.org/ns/widgets"
            xmlns:cdv = "http://cordova.apache.org/ns/1.0"
            id        = "io.cordova.yourfancyapp"
            version   = "1.0.0">
        <name>Your fancy app</name>

        <description>
            Description of your fancy app
        </description>

        <author href="http://yourfancycompany.com" email="">
            You
        </author>

        <access origin="*" />
        <preference name="fullscreen" value="false" />
        <preference name="KeyboardDisplayRequiresUserAction" value="false" />
        <preference name="SuppressesIncrementalRendering" value="false" />
        <preference name="webviewbounce" value="true" />
        <preference name="UIWebViewBounce" value="true" />
        <preference name="TopActivityIndicator" value="gray" />
        <preference name="EnableLocation" value="false" />
        <preference name="EnableViewportScale" value="false" />
        <preference name="AutoHideSplashScreen" value="true" />
        <preference name="ShowSplashScreenSpinner" value="true" />
        <preference name="FadeSplashScreen" value="true" />
        <preference name="FadeSplashScreenDuration" value="2" />
        <preference name="MediaPlaybackRequiresUserAction" value="false" />
        <preference name="AllowInlineMediaPlayback" value="true" />
        <preference name="BackupWebStorage" value="cloud" />

        <plugins>
            <feature name="Liger">
                <param name="ios-package" value="LGRLiger" />
                <param name="android-package" value="com.reachlocal.liger.LigerPlugin" />
            </feature>
        </plugins>

    </widget>

# Add the app folder

This is where you write your next fantastic app! First you need to create a folder named app in your project (which is loaded into your workspace, remember, don't open the project). This needs to be what I like to call a "blue" folder (as oppose to a "yellow" one). Take a look at [our Xcode folders tutorial](./xcodefolders.md) if you feel uncertain about how to do so. The blue/yellow folder distinction is a very common first problem to run into, so if you do you are in good company. Our tutorial should clear things up and help you rise above.

Next you have two options. Either copy the template app from liger-common (TODO Link here!) or you copy your existing app into your brand new blue app folder. A more advanced alternative is to share the app folder between different flavors of Liger. For example by keeping you app code in a separate git repository and including it in both projects as a submodule.

TODO Write "managing my app code" tutorial and link to it.

The next step is to copy the supplied cordova.js from the Pod to your app folder. I found mine under *Pods/Cordova/CordovaLib/cordova.js* but YMMV. Copy *cordova.js* to *app/vendor/cordova.js*. TODO What to do if you need two different versions of cordova.js?

Now begins the fun part. Write your next amazing app! A good point to start is the [app.json](appjson.md) file which defines a number of things about your app.

To summarize:
1. Create app folder
2. Copy the template app from liger-common (TODO Link to liger-common's readme.md)
3. Copy cordova.js to app/vendor
4. Write your app and share it in other liger flavors (Android for example)

# Advanced topics

## Cordova

Liger uses [Cordova](http://cordova.apache.org) internally. While you shouldn't make use of the Liger Cordova plug-in directly yourself, as there's no guarantees Liger will include Cordova at all in the future, you might want to use a different Cordova plug-in. Here lies Dragons. This is truly an advanced topic so first see if any of these alternatives would work for you.

Look to see if HTML offers what you want. Over the recent years HTML5 has grown to support more and more types of functionality. <audio> and <video> tags are an example of this. Hit those search engines and forums! This is the easiest way to solve your issues.

Next down the road look at writing a native Page. Look at the forums to see if someone else already has, and if not write your own. That might not be a reasonable proposition for you, but this is a sure fire way to add that special feature you so genuinely want to grace your users with. An option is to find someone else to help you, which also might be possible through the forums. Don't forget to look for the native support Liger comes with out of the box, such as an in app browser, email and messaging dialogs.

Next you might attempt a Cordova plug-in. But before you do, make sure it's reasonably compatible with Liger. Many are not. Again the forums can be your friend here. If you do find a plug-in and it's your only option, here's some quick pointers.

* The Cordova podspec includes subspecs for their plug-ins.
* If you can't find it as a pod you need to add the code into your own project.
* Don't forget to update your config.xml to include the plug-ins you have added.
* You need to create a **cordova_plugins.js** file and include it in your project somehow.
* You need to include the js for the plug-ins.
