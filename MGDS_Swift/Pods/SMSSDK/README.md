# SMSSDK-for-iOS

SMSSDK is the most popular social SDK for apps and mobile games ! We've already supported over 1000 country or zone in global world  until now. And also it’s easily to use in your app.now, I will tell you the steps liking this:

If you use cocoaPods ,now ,it's easily to import SMSSDK liking this:

##cocoapods import：

 > * main module(necessary)
 
 > * pod "SMSSDK"
 
 > * POD "MOBFoundation_IDFA"

Yeah, you are right,it's over using cocoaPods to import SMSSDK. The next is to import the file's header and use the API of the SMSSDK what you wanted.

## Now,tell you the steps of importing SMSSDK manually.

## Step1: Download the SDK from here :[Download SMSSDK_iOS](http://www.mob.com/#/downloadDetail/SMS/ios)
        
 When you download the SDK, you will get something liking this:
 ![](http://ww2.sinaimg.cn/mw690/9fbf66d3gw1f6qr5l038zj20h50brjrx.jpg)

  It’s contain the three parties:

   > * SMSSDK. Including static libraries and local files.When used directly to this folder into the project.
   > * SMSSDKDemo. Showing the SDK foundation.
   > * SMSSDKUI. If you want to use it, drag SMSSDKUI.xcodeproj to your project directly.

##Step2：Import the SDK

 Drag  this folder of the SMSSDK into the project,like this:
![](http://ww1.sinaimg.cn/mw690/9fbf66d3gw1f6qr5m7cohj20yj0rpdrl.jpg)
  
##Step3: Add libraries 

  Required:

   > *  libz.dylib
   > *  libicucore.dylib
   > *  MessageUI.framework
   > * JavaScriptCore.framework
   > * libstdc++.dylib

  Optional

   > *  AddressBook.framework （Needed by the AddressBook foundation）
   > *  AddressBookUI.framework（Needed by the AddressBook foundation）

  Show you like this：
![](http://ww2.sinaimg.cn/mw690/9fbf66d3gw1f6qr5n18q8j20yv0gowkr.jpg)
  
##Step4: Add the initialization code


 > * Import the header file of the SDK  in this appDelegate  file of your project

           #import <SMS_SDK/SMSSDK.h>

 > * Add register SDK method

        In your project ,add register SDK method in this method,like this:
          - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
          {
            //初始化应用，appKey和appSecret从后台申请得
             [SMSSDK registerApp:appKey withSecret:appSecret];
          }

    AppKey and appSerect:
    
> * Register as a Mob developers  
[Click to register](http://www.mob.com/#/reg)
> * New application,the steps of new application,please reference: 
[Document for getting appkey and appSerect](http://bbs.mob.com/forum.php?mod=viewthread&tid=8212&extra=page%3D1)

##Step5: Using API 
![](http://ww4.sinaimg.cn/mw690/9fbf66d3gw1f6qr5nkcndj219j0hrjxa.jpg)

In the SMSSDK file ,it contains all the API in the SDK, and here,you can use anyone that you wanted liking this:

[SMSSDK  ********];

## [If you want to see the chinese document,please click here !](http://wiki.mob.com/iOS%E7%9F%AD%E4%BF%A1SDK%E9%9B%86%E6%88%90%E6%96%87%E6%A1%A3/)

