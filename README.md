Cordova IAP plugin
====================

# Overview #
in app purchase

[android, ios, wp8] [cordova cli] [xdk] [cocoon] [phonegap build service]

Requires google play developer account https://play.google.com/apps/publish/
Requires apple developer account https://developer.apple.com/devcenter/ios/index.action
Requires windows phone developer account https://dev.windowsphone.com/
wp8 is not yet supported

This is open source cordova plugin.

You can see Plugins For Cordova in one page: http://cranberrygame.github.io?referrer=github

cf)construct2

android: Phonegap IAP or c2 IAP plugin

blackberry10: c2 IAP plugin (https://www.scirra.com/manual/173/iap)

ios: Phonegap IAP or c2 IAP plugin

windows8: c2 IAP plugin

wp8: Phonegap IAP

# Change log #
```c
```
# Install plugin #

## Cordova cli ##
https://cordova.apache.org/docs/en/edge/guide_cli_index.md.html#The%20Command-Line%20Interface - npm install -g cordova@5.0.0
```c
cordova plugin add cordova-plugin-payment-iap
(when build error, use github url: cordova plugin add https://github.com/cranberrygame/cordova-plugin-payment-iap)
```

## Xdk ##
https://software.intel.com/en-us/intel-xdk - Download XDK - XDK PORJECTS - [specific project] - CORDOVA HYBRID MOBILE APP SETTINGS - Plugin Management - Add Plugins to this Project - Third Party Plugins -
```c
Plugin Source: Cordova plugin registry
Plugin ID: cordova-plugin-payment-iap
```

## Cocoon ##
https://cocoon.io - Create project - [specific project] - Setting - Plugins - Custom - Git Url: https://github.com/cranberrygame/cordova-plugin-payment-iap.git - INSTALL - Save<br>

## Phonegap build service (config.xml) ##
https://build.phonegap.com/ - Apps - [specific project] - Update code - Zip file including config.xml
```c
<gap:plugin name="cordova-plugin-payment-iap" source="npm" />
```

## Construct2 ##
Download construct2 plugin<br>
https://dl.dropboxusercontent.com/u/186681453/pluginsforcordova/index.html<br>
How to install c2 native plugins in xdk, cocoon and cordova cli<br>
https://plus.google.com/102658703990850475314/posts/XS5jjEApJYV

# Server setting #
```c
```
## Android ##
```c
//if you see this message when trying to add in app product, you must republish the app with Phonegap IAP plugin once in alpha, beta, normal publish (just republish, no iap event coding).
//if your app is republished with dummy Phonegap IAP plugin, then you can add in app product
//(See 1.png 2.png 3.png)
Your app doesn't have any in-app products yet. 
To add in-app products, you need to add the BILLING permission to your APK.

//add in app product (nonconsumable)
google play developer console - [specific app] - in app product - add - managed, product ID: testapp_removeads - Name : Remove Ads, Description: You can purchase remove ads by tapping "Remove Ads" button. And you can also restore previous purchases by tapping "Restore" button. - set active

//add in app product (consumable)
google play developer console - [specific app] - in app product - add - unmanaged, product ID: testapp_coinpack1 - Name : Coin Pack1 (250 Coins), Description: Coin pack1 (250 Coins) - set active

//add in app product (consumable)
google play developer console - [specific app] - in app product - add - unmanaged, product ID: testapp_coinpack2 - Name : Coin Pack2 (750 Coins), Description: Coin pack2 (750 Coins) - set active

//add in app product (consumable)
google play developer console - [specific app] - in app product - add - unmanaged, product ID: testapp_coinpack3 - Name : Coin Pack3 (2250 Coins), Description: Coin pack3 (2250 Coins) - set active

//get application license key (per app)
google play developer console - [specific app] - Services & APis - license and in app purchase - get ANDROID_APPLICATION_LICENSE_KEY
```
<img src="https://raw.githubusercontent.com/cranberrygame/cordova-plugin-payment-iap/master/doc/android1.png">
<img src="https://raw.githubusercontent.com/cranberrygame/cordova-plugin-payment-iap/master/doc/android2.png">
<img src="https://raw.githubusercontent.com/cranberrygame/cordova-plugin-payment-iap/master/doc/android3.png">

## iOS ##
```c
//accept paid agreement if you are adding your first app on iOS (contributed by tabrez)

//add in app product (nonconsumable)
itunesconnect - Manage Your Apps - [specific app] - Manage In-App Purchases - Create New - Non Consumable - Select - Reference Name: testapp_removeads, Product ID: testapp_removeads - 언어 추가 - 언어: English, Display Name : Remove Ads, Description: You can purchase remove ads by tapping "Remove Ads" button. And you can also restore previous purchases by tapping "Restore" button. - Screenshot for Review (screen shot where "Remove Ads" button and "Restore" button exist)

//add in app product (consumable)
itunesconnect - Manage Your Apps - [specific app] - Manage In-App Purchases - Create New - Consumable - Select - Reference Name: testapp_coinpack1, Product ID: testapp_coinpack1 - 언어 추가 - 언어: English, Display Name : Coin Pack1 (250 Coins), Description: Coin Pack1 (250 Coins) - Screenshot for Review (screen shot where PurchaseConsumablePack button exists)

//add in app product (consumable)
itunesconnect - Manage Your Apps - [specific app] - Manage In-App Purchases - Create New - Consumable - Select - Reference Name: testapp_coinpack2, Product ID: testapp_coinpack2 - 언어 추가 - 언어: English, Display Name : Coin Pack2 (750 Coins), Description: Coin Pack2 (750 Coins) - Screenshot for Review (screen shot where PurchaseConsumablePack button exists)

//add in app product (consumable)
itunesconnect - Manage Your Apps - [specific app] - Manage In-App Purchases - Create New - Consumable - Select - Reference Name: testapp_coinpack3, Product ID: testapp_coinpack3 - 언어 추가 - 언어: English, Display Name : Coin Pack3 (2250 Coins), Description: Coin Pack3 (2250 Coins) - Screenshot for Review (screen shot where PurchaseConsumablePack button exists)

cf)Screenshot for Review (Screenshots must be 960x640, 960x600, 640x960, 640x920, 1136x640, 1136x600, 640x1136, 640x1096, 2208x1242, 1242x2208, 1334x750, 750x1334, 1024x768, 1024x748, 768x1024, 768x1004, 2048x1536, 2048x1496, 1536x2048 or 1536x2008 pixels.)

iOS Simulator - Hardware - Device - iPhone 6 Plus

Screen capture (1242x2208)

See doc/iOS Simulator Screen Shot_iPhone 6 Plus.png
```

should_agree_with_paid_applications_contracts
<img src="https://raw.githubusercontent.com/cranberrygame/cordova-plugin-payment-iap/master/doc/contracts1.png">
<img src="https://raw.githubusercontent.com/cranberrygame/cordova-plugin-payment-iap/master/doc/contracts2.png">

In app purchase screenshot for review (iPhone 6 Plus)
<img src="https://raw.githubusercontent.com/cranberrygame/cordova-plugin-payment-iap/master/doc/in_app_purchase_screenshot_for_review_iphone_6_plus.png">

## Wp8 ##
```c
//add in app product (nonconsumable)
Windows Phone Dev Center - Dashboard - select Windows Phone Store - Apps - [specific app] - Products - Add in-app product - In-app product properties - In-app product alias: testapp_removeads, Product identifier: testapp_removeads, Product type: Durable, Product lifetime: Forever - Save -
Description - Product title: Remove Ads, Description: Remove ads, Product image: (300x300 px PNG file) - Save - Submit

//add in app product (consumable)
Windows Phone Dev Center - Dashboard - select Windows Phone Store - Apps - [specific app] - Products - Add in-app product - In-app product properties - In-app product alias: testapp_coinpack1, Product identifier: testapp_coinpack1, Product type: Consumable - Save -
Description - Product title: Coin Pack1 (250 Coins), Description: Coin Pack1 (250 Coins), Product image: (300x300 px PNG file) - Save - Submit

//add in app product (consumable)
Windows Phone Dev Center - Dashboard - select Windows Phone Store - Apps - [specific app] - Products - Add in-app product - In-app product properties - In-app product alias: testapp_coinpack2, Product identifier: testapp_coinpack2, Product type: Consumable - Save -
Description - Product title: Coin Pack2 (750 Coins), Description: Coin Pack2 (750 Coins), Product image: (300x300 px PNG file) - Save - Submit

//add in app product (consumable)
Windows Phone Dev Center - Dashboard - select Windows Phone Store - Apps - [specific app] - Products - Add in-app product - In-app product properties - In-app product alias: testapp_coinpack3, Product identifier: testapp_coinpack3, Product type: Consumable - Save -
Description - Product title: Coin Pack3 (2250 Coins), Description: Coin Pack3 (2250 Coins), Product image: (300x300 px PNG file) - Save - Submit

ing
//Get YOUR_APP_ID from Windows Phone Dev Center and put it in "your wp8 project - Properties - WMAppManifest.xml - Packaging - Product ID"
Windows Phone Dev Center - Dashboard - select Windows Phone Store - Apps - [specific app] - Details - App ID: YOUR_APP_ID
```

# API #
```javascript

var androidApplicationLicenseKey = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtrOQsWiUYfQ65MjUam2zu2DgoBkOsaoelFQHWzRkAT+KHr1xPIOF5JUeQs/XWtNjRI4pavBrRveB3xnoKE+WxvILh4N+3Kl11/i0r9B6/LBae8V8WZpArEIIvh3rgowDGTO0B6sfWO71iP9EStmwziBI4sDOMuPensBSmj8bxj3hhNEzyRJvQbybdNgAD2xoy55+S0kgLHE3PbZwqogJf1pPIGSmhC2SXSrMXoJzxeMxM8/hN7VoVj9VAJxzOE3zR9he9npiDWGLsPnAIXggUN9Ys0h80YjwRl7GHLP0P/itBo28w4+qOqz2E34SFFInAqX7evtrMu3AkfYcX+FPuQIDAQAB";
var productIds = "testapp_removeads,testapp_coinpack1,testapp_coinpack2,testapp_coinpack3";
var existing_purchases = [];
var product_info = {};
		
document.addEventListener("deviceready", function(){

	window.iap.setUp(androidApplicationLicenseKey);

	//get all products' infos for all productIds
	window.iap.requestStoreListing(productIds, function (result){
	/*
	[
		{
			"productId": "sword001",
			"title": "Sword of Truths",
			"price": "Formatted price of the item, including its currency sign.",
			"description": "Very pointy sword. Sword knows if you are lying, so don't lie."
		},
		{
			"productId": "shield001",
			"title": "Shield of Peanuts",
			"price": "Formatted price of the item, including its currency sign.",
			"description": "A shield made entirely of peanuts."
		}
	]
	*/
	//alert(JSON.stringify(result));

		for (var i = 0 ; i < result.length; ++i){
			var p = result[i];
			
			product_info[p["productId"]] = { title: p["title"], price: p["price"] };			
			
			alert("productId: "+p["productId"]);
			alert("title: "+p["title"]);
			alert("price: "+p["price"]);
		}
	}, function (error){
		alert("error: "+error);
	});
}, false);
	
function purchaseProduct(productId) {
	
	//purchase product id, put purchase product id info into server.
	window.iap.purchaseProduct(productId, function (result){
		alert("purchaseProduct");
	}, 
	function (error){
		alert("error: "+error);
	});
}

function consumeProduct(productId) {
	//consume product id, throw away purchase product id info from server.
	window.iap.consumeProduct(productId, function (result){
		alert("purchaseProduct");
	}, 
	function (error){
		alert("error: "+error);
	});	
}

function restorePurchases() {
	//get user's purchased product ids which purchased before and not cunsumed.
	window.iap.restorePurchases(function (result){
		for (var i = 0 ; i < result.length; ++i){
			var p = result[i];
			
			if (self.existing_purchases.indexOf(p['productId']) === -1)
				self.existing_purchases.push(p['productId']);			

			alert("productId: "+p['productId']);
		}
	}, 
	function (error){
		alert("error: "+error);
	});
}

function hasProduct = function (productId){
	return existing_purchases.indexOf(productId) !== -1;
};
	
```
# Examples #
<a href="https://github.com/cranberrygame/cordova-plugin-payment-iap/blob/master/example/basic/index.html">example/basic/index.html</a><br>

# Test #

[![](http://img.youtube.com/vi/xXrVb8E8gMM/0.jpg)](https://www.youtube.com/watch?v=xXrVb8E8gMM&feature=youtu.be "Youtube")

You can also run following test apk.
https://dl.dropboxusercontent.com/u/186681453/pluginsforcordova/iap/apk.html

## Android ##
```c
//publish as alpha test (recommend) or beta test instead of production.
google play developer console - [specific app] - APK - Alpha test - Upload as alpha test - Drag and drop apk and publish now as alpha test.

//add test user for iap
google play developer console - configuration - account detail - testing accounts (google play account)

//add test community for alpha test or beta test download
google play developer console - 
All applications - 
[specific app] - 
APK -
Alpha testers - 
Manage list of testers - 
Add Google groups or Google+ community: https://plus.google.com/communities/xxx (if you want make Google+ Community, go to this: https://plus.google.com/communities) -
Add - 
Let test user download and install apk from this url: https://play.google.com/apps/testing/YOUR_PACKAGE (invite test user in your Google+ community, wait until this url is available, take hours)

test for iap requires real device.

cf)caution 

if you want to test with local apk, use signed and exactly same version apk uploaded in google play store.

cf)error message

the item you requested is not available for purchase
==> In-activated Product Id, so Activate Product Id
http://stackoverflow.com/questions/13117081/the-item-you-requested-is-not-available-for-purchase
```

## iOS ##
```c
test doest not requires publishing.
test requires real device.

//if you don't want to spend real money buying your own app, setup your test users and buy with test account.
//if you alreay logged in with other account, first log out (Setting - iTunes & App Store - Apple ID: xxx@xxx.com - Log out)
itunesconnect - Users and Roles - Sandbox Testers - +

//Xdk
XDK PROJECTS - projectname - BUILD SETTINGS - iOS - Provisioning Profile: production, Production Provisioning File: YOUR_PROVISION_FILE (.mobileprovision)
BUILD - CORVOVA 3,X HYBRID MOBILE APP PLATFORMS - iOS - Build - iOS CERTIFICATE - Edit - UPLOAD CERTIFICATE: YOUR_CERTIFICATE_FILE (.cer) - Go to Next Step - Download .ipa file - Drag it to the itunes and run it on the device

//Xcode
Select "Xcode - iPhone" (Ad Hoc)
- Product
- Run
```
<img src="https://raw.githubusercontent.com/cranberrygame/cordova-plugin-payment-iap/master/doc/tester1_iossandbox1.png">
<img src="https://raw.githubusercontent.com/cranberrygame/cordova-plugin-payment-iap/master/doc/tester1_iossandbox2.png">
<img src="https://raw.githubusercontent.com/cranberrygame/cordova-plugin-payment-iap/master/doc/tester2_testflight.png">

## Wp8 ##
```c
```

# Useful links #

Cordova Plugins<br>
http://cranberrygame.github.io?referrer=github

# Credits #
