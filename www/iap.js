
module.exports = {

//cranberrygame start
	setUp: function(androidApplicationLicenseKey) {
		cordova.exec(
			function (result) {
			}, 
			function (error) {
			},
			'IAP',
			'setUp',			
			[androidApplicationLicenseKey]
		); 
	},
//cranberrygame end	
	requestStoreListing: function (productIds, successCallback, failureCallback) {
		if (!productIds || productIds.length == 0) {
			return successCallback({});
		}
		if (Object.prototype.toString.call(productIds) === '[object String]') {
			// In the event one productId is passed in as String we shall put it in
			// an array to be easily dealt with natively.
			//productIds = [ productIds ];
			var tempProductIds = [];
			if (productIds.indexOf(",") === -1) {
				tempProductIds.push(productIds);
			}
			else {
				tempProductIds = productIds.split(",");				
			}
			productIds = tempProductIds;
		}
		//alert(JSON.stringify(productIds));
		//alert(Object.prototype.toString.call(productIds));
		cordova.exec(successCallback, failureCallback, "IAP", "requestStoreListing", [ productIds ]);	
	},

	purchaseProduct: function(productId, successCallback, failureCallback) {
		if (!productId) {
			return failureCallback("noProductId");
		}
		cordova.exec(successCallback, failureCallback, "IAP", "purchaseProduct", [ productId ]);		
	},	

	consumeProduct: function (receipt, successCallback, failureCallback) {
		if (!receipt || receipt.length == 0) {
			return successCallback();
		}
		if (Object.prototype.toString.call(receipt) === '[object String]') {
			// In the event one receipt is passed in as String we shall put it in
			// an array to be easily dealt with natively.
			receipt = [ receipt ];
		}
	   
		cordova.exec(successCallback, failureCallback, "IAP", "consumeProduct", [ receipt ]);
	},	

	restorePurchases: function (successCallback, failureCallback) {
		cordova.exec(successCallback, failureCallback, "IAP", "restorePurchases", []);
	}
};
