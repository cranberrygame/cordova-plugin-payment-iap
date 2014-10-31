/** 
 * A phonegap plugin to enable WP8 In-App Purchases.
 * Author: Toby Kavukattu
 * Version: 0.1
 * License: MIT
 *
 * Based on the iOS plugin by Matt Kane & Guillaume Charhon
 * https://github.com/phonegap/phonegap-plugins/tree/master/iOS/InAppPurchaseManager)
 * https://github.com/usmart/InAppPurchaseManager-EXAMPLE)
 */

function IAP() { 
	//cordova.exec(null,null,'IAP',"setup",[]);
}

/**
 * Retrieves localised product data, including price (as localised
 * string), name, description of multiple products.
 *
 * @param {Array} productIds
 *   An array of product identifier strings.
 *
 * @param {Function} callback
 *   Called once with the result of the products request. Signature:
 *
 *     function(validProducts, invalidProductIds)
 *
 *   where validProducts receives an array of objects of the form
 *
 *     {
 *      id: "<productId>",
 *      title: "<localised title>",
 *      description: "<localised escription>",
 *      price: "<localised price>"
 *     }
 *
 *  and invalidProductIds receives an array of product identifier
 *  strings which were rejected by the app store.
 */
IAP.prototype.requestStoreListing = function (productIds, successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'IAP', 'requestStoreListing', productIds);
};

/**
 * Restores previously completed purchases.
 * The restored transactions are passed to the onRestored callback, so make sure you define a handler for that first.
 * 
 */
IAP.prototype.restorePurchases = function (successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'IAP', 'restorePurchases', []);
};

/**
 * Makes an in-app purchase. 
 * 
 * @param {String} productId The product identifier. e.g. "com.example.MyApp.myproduct"
 */
IAP.prototype.purchaseProduct = function (productId, successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'IAP', 'purchaseProduct', [productId]);
/*
	cordova.exec(function (result) {
        window.iap.onPurchased("",productId,"");
	}, null, 'IAP', 'purchaseProduct', [productId]);
*/	
};

IAP.prototype.consumeProduct = function (productId, successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'IAP', 'consumeProduct', [productId]);
};

var iap = new IAP();
module.exports = iap;
