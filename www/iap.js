
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
	requestStoreListing: function (productIds, s, f) {
		if (!productIds || productIds.length == 0) {
			return s({});
		}
		if (Object.prototype.toString.call(productIds) === '[object String]') {
			// In the event one productId is passed in as String we shall put it in
			// an array to be easily dealt with natively.
			productIds = [ productIds ];
		}
		cordova.exec(s, f, "IAP", "requestStoreListing", [ productIds ]);	
	},

	purchaseProduct: function(productId, s, f) {
		if (!productId) {
			return f("noProductId");
		}
		cordova.exec(s, f, "IAP", "purchaseProduct", [ productId ]);		
	},	

	consumeProduct: function (receipt, s, f) {
		if (!receipt || receipt.length == 0) {
			return s();
		}
		if (Object.prototype.toString.call(receipt) === '[object String]') {
			// In the event one receipt is passed in as String we shall put it in
			// an array to be easily dealt with natively.
			receipt = [ receipt ];
		}
	   
		cordova.exec(s, f, "IAP", "consumeProduct", [ receipt ]);
	},	

	restorePurchases: function (s, f) {
		cordova.exec(s, f, "IAP", "restorePurchases", []);
	},	

	canMakePurchase: function(s, f) {
		cordova.exec(s, f, "IAP", "canMakePurchase", []);		
	},
	
	getPending: function (s, f) {
		cordova.exec(s, f, "IAP", "getPending", []);
	}
};
