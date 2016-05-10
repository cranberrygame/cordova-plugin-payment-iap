/* IAP
 *
 * @author Ally Ogilvie
 * @copyright Wizcorp Inc. [ Incorporated Wizards ] 2014
 * @file IAP.m
 *
 */

#import "IAP.h"
#import "IAPDebugLog.h"

@implementation IAP

- (CDVPlugin *)initWithWebView:(UIWebView *)theWebView {

    if (self) {
        // Register ourselves as a transaction observer
        // (we get notified when payments in the payment queue get updated)
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

//cranberrygame start
- (void)setUp: (CDVInvokedUrlCommand*)command {
    //self.viewController
    //

	CDVPluginResult* pr = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
	//[pr setKeepCallbackAsBool:YES];
	[self.commandDelegate sendPluginResult:pr callbackId:command.callbackId];
	//CDVPluginResult* pr = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
	//[pr setKeepCallbackAsBool:YES];
	//[self.commandDelegate sendPluginResult:pr callbackId:command.callbackId];	
}
//cranberrygame end

- (void)requestStoreListing:(CDVInvokedUrlCommand *)command {
    NSLog(@"requestStoreListing");
    
    requestStoreListingCallbackId = command.callbackId;
    [self.commandDelegate runInBackground:^{
        [self _requestStoreListing:[command.arguments objectAtIndex:0]];
     }];
}

- (void)_requestStoreListing:(NSArray *)productIdentifiers {
    NSLog(@"_requestStoreListing");
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:productIdentifiers]];
    productsRequest.delegate = self;
    [productsRequest start];
}

- (void)purchaseProduct:(CDVInvokedUrlCommand *)command {
    NSLog(@"purchaseProduct");
    NSString *productId = [command.arguments objectAtIndex:0];
    purchaseProductCallbackId = command.callbackId;
    
    SKProduct *product = NULL;
    if (productsResponse != NULL) {
        for (SKProduct *obj in (NSArray *)productsResponse.products) {
            if ([obj.productIdentifier isEqualToString:productId]) {
                product = obj;
                break;
            }
        }
    }
	
    [self.commandDelegate runInBackground:^{
        if (product != NULL) {
            [[SKPaymentQueue defaultQueue] addTransactionObserver:self];//cranberrygame
            SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
        }
        else {
            [self _requestStoreListing:@[ productId ]];
        }
    }];	
}

- (void)consumeProduct:(CDVInvokedUrlCommand *)command {
    NSLog(@"consumeProduct");
    // Remove any receipt(s) from NSUserDefaults matching productIds, we have verified with a server
    NSArray *productIds = [command.arguments objectAtIndex:0];
    for (NSString *productId in productIds) {
        // Remove receipt from storage
//        [self removeReceipt:productId];
#if USE_ICLOUD_STORAGE
        NSUbiquitousKeyValueStore *storage = [NSUbiquitousKeyValueStore defaultStore];
#else
        NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
#endif
        
        NSMutableArray *savedReceipts = [[NSMutableArray alloc] initWithArray:[storage objectForKey:@"receipts"]];
        if (savedReceipts) {
            for (int i = 0; i < [savedReceipts count]; i++) {
                if ([[[NSDictionary dictionaryWithDictionary:[savedReceipts objectAtIndex:i]] objectForKey:@"productId"] isEqualToString:productId]) {
                    // Remove receipt with matching productId
                    [savedReceipts removeObject:[savedReceipts objectAtIndex:i]];
                    // Remove old receipt array and switch for new one
                    [storage removeObjectForKey:@"receipts"];
                    [storage setObject:savedReceipts forKey:@"receipts"];
                    [storage synchronize];
                }
            }
        }
    }
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)restorePurchases:(CDVInvokedUrlCommand *)command {
    NSLog(@"restorePurchases");

    restorePurchasesCallbackId = command.callbackId;
    //[self.commandDelegate runInBackground:^{
        // Call this to get any previously purchased non-consumables
        //https://github.com/j3k0/cordova-plugin-purchase/issues/286
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];//cranberrygame
        [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    //}];
}

//---------------------------------------------------------

//requestStoreListing, purchaseProduct callback (SKProductsRequestDelegate)
/*
 @protocol SKProductsRequestDelegate <SKRequestDelegate>
 
 @required
 // Sent immediately before -requestDidFinish:
 - (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response NS_AVAILABLE_IOS(3_0);
 
 @end
 */

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    // Receiving a list of products from Apple
    
    if (purchaseProductCallbackId != NULL) {
        
        if ([response.invalidProductIdentifiers count] > 0) {
            for (NSString *invalidProductId in response.invalidProductIdentifiers) {
                NSLog(@"Invalid product id: %@" , invalidProductId);
            }
            // We have requested at least one invalid product fallout here for security
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                              messageAsString:@"unknownProductId"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:purchaseProductCallbackId];
            purchaseProductCallbackId = NULL;
            return;
        }
        
        // Continue the purchase flow
        if ([response.products count] > 0) {
            SKProduct *product = [response.products objectAtIndex:0];
            SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
            
            return;
        }
        
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                          messageAsString:@"unknownProductId"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:purchaseProductCallbackId];
        purchaseProductCallbackId = NULL;
    }
    
    if (requestStoreListingCallbackId != NULL) {
        // Continue product(s) list request
        
        if ([response.invalidProductIdentifiers count] > 0) {
            for (NSString *invalidProductId in response.invalidProductIdentifiers) {
                NSLog(@"Invalid product id: %@" , invalidProductId);
            }
            // We have requested at least one invalid product fallout here for security
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                          messageAsString:@"unknownProductId"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:requestStoreListingCallbackId];
            requestStoreListingCallbackId = NULL;
            return;
        }
       
        // If you request all productIds we create a shortcut here for doing purchaseProduct
        // it saves on http requests
        productsResponse = (SKProductsResponse *)response;
        
		NSMutableArray *productDetails = [NSMutableArray array];		
        NSLog(@"Products found: %i", [response.products count]);
        for (SKProduct *obj in response.products) {
            // Build a detailed product list from the list of valid products
            
            // Fromat the price
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
            [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            [numberFormatter setLocale:obj.priceLocale];
            NSString *formattedPrice = [numberFormatter stringFromNumber:obj.price];
 /*
		
            NSDictionary *product = @{
                @"productId":   obj.productIdentifier,
                @"title":       obj.localizedTitle,
                @"price":       formattedPrice,
                @"description": obj.localizedDescription
            };
*/
            NSDictionary *product = nil;
            if(obj.localizedTitle==nil) {
            	product = @{
	                @"productId":   obj.productIdentifier,
	                @"title":       @"",
	                @"price":       formattedPrice,
	                @"description": @""
	            };
            }
            else {
	            product = @{
	                @"productId":   obj.productIdentifier,
	                @"title":       obj.localizedTitle,
	                @"price":       formattedPrice,
	                @"description": obj.localizedDescription
	            };
            }

			[productDetails addObject:product];
        }
        
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:productDetails];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:requestStoreListingCallbackId];
        requestStoreListingCallbackId = NULL;
    }
}

/*
 //??
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"request - didFailWithError: %@", [[error userInfo] objectForKey:@"NSLocalizedDescription"]);
}
*/

//restorePurchases callback (SKPaymentTransactionObserver)
/*
 @protocol SKPaymentTransactionObserver <NSObject>
 @required
 // Sent when the transaction array has changed (additions or state changes).  Client should check state of transactions and finish as appropriate.
 - (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions NS_AVAILABLE_IOS(3_0);
 

 // Sent when all transactions from the user's purchase history have successfully been added back to the queue.
 - (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue NS_AVAILABLE_IOS(3_0);
 
 // Sent when an error is encountered while adding transactions from the user's purchase history back to the queue.
 - (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error NS_AVAILABLE_IOS(3_0);
 
 // Sent when the download state has changed.
 - (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray<SKDownload *> *)downloads NS_AVAILABLE_IOS(6_0);

 @optional
 // Sent when transactions are removed from the queue (via finishTransaction:).
 - (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray<SKPaymentTransaction *> *)transactions NS_AVAILABLE_IOS(3_0);
 
 @end
 */

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    NSLog(@"updatedTransactions");
    
    NSInteger errorCode = 0; // Set default unknown error
    NSString *error;
    for (SKPaymentTransaction *transaction in transactions) {
        
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"SKPaymentTransactionStatePurchasing");
                continue;
            {
            case SKPaymentTransactionStatePurchased:
                NSLog(@"SKPaymentTransactionStatePurchased");
                // Immediately save to NSUserDefaults incase we cannot reach JavaScript in time
                // or connection for server receipt verification is interupted
                NSString *receipt = [[NSString alloc] initWithData:[transaction transactionReceipt] encoding:NSUTF8StringEncoding];//deprecated
                /*
                 NSData *receiptData;
                 if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_7_0) {
                 receiptData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
                 } else {
                 receiptData = transaction.transactionReceipt;
                 }
                 NSString *receipt = [[NSString alloc] initWithData:receiptData encoding:NSUTF8StringEncoding];
                 */
                
                // We requested this payment let's finish
                NSDictionary *result = @{
                                         @"platform": @"ios",
                                         @"receipt": receipt,
                                         @"productId": transaction.payment.productIdentifier,
                                         @"packageName": [[NSBundle mainBundle] bundleIdentifier]
                                         };
                
                [self backupReceipt:result];
                
                if (purchaseProductCallbackId) {
                    
                    // Return result to JavaScript
                    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:purchaseProductCallbackId];
                    purchaseProductCallbackId = NULL;
                }
                break;
            }
            case SKPaymentTransactionStateFailed:
                
                error = transaction.error.localizedDescription;
                errorCode = transaction.error.code;
                NSLog(@"SKPaymentTransactionStateFailed %d %@", errorCode, error);
                if (purchaseProductCallbackId) {
                    // Return result to JavaScript
                    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                                      messageAsString:[self returnErrorString:transaction.error]];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:purchaseProductCallbackId];
                    purchaseProductCallbackId = NULL;
                }
                break;
            case SKPaymentTransactionStateRestored: {
                // We restored some non-consumable transactions add to receipt backup
                NSLog(@"SKPaymentTransactionStateRestored");
                NSString *receipt = [[NSString alloc] initWithData:[transaction transactionReceipt] encoding:NSUTF8StringEncoding];//deprecated
                /*
                 NSData *receiptData;
                 if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_7_0) {
                 receiptData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
                 } else {
                 receiptData = transaction.transactionReceipt;
                 }
                 NSString *receipt = [[NSString alloc] initWithData:receiptData encoding:NSUTF8StringEncoding];
                 */
                
                NSDictionary *result = @{
                                         @"platform": @"ios",
                                         @"receipt": receipt,
                                         @"productId": transaction.payment.productIdentifier,
                                         @"packageName": [[NSBundle mainBundle] bundleIdentifier]
                                         };
                [self backupReceipt:result];
                break;
            }
            default:
                NSLog(@"SKPaymentTransactionStateInvalid");
                if (purchaseProductCallbackId) {
                    // Return result to JavaScript
                    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                                      messageAsString:[self returnErrorString:transaction.error]];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:purchaseProductCallbackId];
                    purchaseProductCallbackId = NULL;
                }
                continue;
        }
        
        // Finishing a transaction tells Store Kit that you’ve completed everything needed for the purchase.
        // Unfinished transactions remain in the queue until they’re finished, and the transaction queue
        // observer is called every time your app is launched so your app can finish the transactions.
        // Your app needs to finish every transaction, regardles of whether the transaction succeeded or failed.
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
}

- (void)backupReceipt:(NSDictionary *)result {
    NSLog(@"Backing up receipt");
#if USE_ICLOUD_STORAGE
    NSUbiquitousKeyValueStore *storage = [NSUbiquitousKeyValueStore defaultStore];
#else
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
#endif
    
    NSArray *savedReceipts = [storage arrayForKey:@"receipts"];
    if (!savedReceipts) {
        // Storing the first receipt
        [storage setObject:@[result] forKey:@"receipts"];
    } else {
        // Adding another receipt
        NSArray *updatedReceipts = [savedReceipts arrayByAddingObject:result];
        [storage setObject:updatedReceipts forKey:@"receipts"];
    }
    [storage synchronize];
}

- (NSString *)returnErrorString:(NSError *)error {
    // Default error SKErrorUnknown
    NSString *errorString = @"unknownError";
    // Indicates that an unknown or unexpected error occurred.
    if ([error.domain isEqualToString:@"SKErrorDomain"]) {
        switch (error.code) {
            case 1:
                // SKErrorClientInvalid
                // Indicates that the client is not allowed to perform the attempted action.
                errorString = @"invalidClient";
                break;
            case 2:
                // SKErrorPaymentCancelled
                // Indicates that the user cancelled a payment request.
                errorString = @"userCancelled";
                break;
            case 3:
                // SKErrorPaymentInvalid
                // Indicates that one of the payment parameters was not recognized by the Apple App Store.
                errorString = @"invalidPayment";
                break;
            case 4:
                // SKErrorPaymentNotAllowed
                // Indicates that the user is not allowed to authorise payments.
                errorString = @"unauthorized";
                break;
            case 5:
                // SKErrorStoreProductNotAvailable
                // Indicates that the requested product is not available in the store.
                errorString = @"unknownProductId";
                break;
            default:
                break;
        }
    }
    return errorString;
}

//cranberrygame start
/*
//iOS purchase restore not work #19
//https://github.com/Wizcorp/phonegap-plugin-wizPurchase/issues/19
//SKPaymentTransaction
//https://developer.apple.com/LIBRARY/ios/documentation/StoreKit/Reference/SKPaymentTransaction_Class/index.html#//apple_ref/occ/instp/SKPaymentTransaction/payment
//SKPayment
//https://developer.apple.com/LIBRARY/ios/documentation/StoreKit/Reference/SKPaymentRequest_Class/index.html#//apple_ref/swift/cl/SKPayment
*/
//cranberrygame end
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    NSLog(@"paymentQueueRestoreCompletedTransactionsFinished");
    if (restorePurchasesCallbackId != NULL) {
        
        //NSArray *receipts;
		NSMutableArray *purchasedProducts = [NSMutableArray array];
        if ([[[SKPaymentQueue defaultQueue] transactions] count] > 0) {
            for (SKPaymentTransaction *transaction in [[SKPaymentQueue defaultQueue] transactions]) {

                // Immediately save to NSUserDefaults incase we cannot reach JavaScript in time
                // or connection for server receipt verification is interupted
                NSString *receipt = [[NSString alloc] initWithData:[transaction transactionReceipt] encoding:NSUTF8StringEncoding];//deprecated
/*
                NSData *receiptData;
                if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_7_0) {
                    receiptData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
                } else {
                    receiptData = transaction.transactionReceipt;
                }
                NSString *receipt = [[NSString alloc] initWithData:receiptData encoding:NSUTF8StringEncoding];
*/
                
                // We requested this payment let's finish
                NSDictionary *result = @{
                     @"platform": @"ios",
                     @"receipt": receipt,
                     @"productId": transaction.payment.productIdentifier,
                     @"packageName": [[NSBundle mainBundle] bundleIdentifier]
                };
                
				[purchasedProducts addObject:result];
            }				
        } 

//cranberrygame start		
/*
        // Return result to JavaScript
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:purchasedProducts];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:restorePurchasesCallbackId];
*/	
		if ([purchasedProducts count] > 0) {
			CDVPluginResult* pr = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:purchasedProducts];
			//[pr setKeepCallbackAsBool:YES];
			[self.commandDelegate sendPluginResult:pr callbackId:restorePurchasesCallbackId];
			//CDVPluginResult* pr = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
			//[pr setKeepCallbackAsBool:YES];
			//[self.commandDelegate sendPluginResult:pr callbackId:restorePurchasesCallbackId];
		}
		else {
			//CDVPluginResult* pr = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
			//[pr setKeepCallbackAsBool:YES];
			//[self.commandDelegate sendPluginResult:pr callbackId:restorePurchasesCallbackId];
			CDVPluginResult* pr = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"no purchased data"];
			//[pr setKeepCallbackAsBool:YES];
			[self.commandDelegate sendPluginResult:pr callbackId:restorePurchasesCallbackId];
		}		
//cranberrygame end
		
        restorePurchasesCallbackId = NULL;
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    NSLog(@"restoreCompletedTransactionsFailedWithError");
    
    if (restorePurchasesCallbackId != NULL) {
        // Convert error code to String
        NSString *errorString = [self returnErrorString:error];
        // Return result to JavaScript
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                          messageAsString:errorString];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:restorePurchasesCallbackId];
        restorePurchasesCallbackId = NULL;
    }
}

@end