/* wizPurchasePlugin
 *
 * @author Ally Ogilvie
 * @copyright Wizcorp Inc. [ Incorporated Wizards ] 2014
 * @file wizPurchasePlugin.h
 *
 */

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import <Cordova/CDVPlugin.h>

@interface IAP : CDVPlugin <SKProductsRequestDelegate, SKPaymentTransactionObserver> {
    SKProductsResponse *productsResponse;
    NSString *requestStoreListingCallbackId;
    NSString *purchaseProductCallbackId;
    NSString *restorePurchasesCallbackId;
}

//cranberrygame start
- (void)setUp: (CDVInvokedUrlCommand*)command;
//cranberrygame end
- (void)requestStoreListing:(CDVInvokedUrlCommand *)command;
- (void)purchaseProduct:(CDVInvokedUrlCommand *)command;
- (void)consumeProduct:(CDVInvokedUrlCommand *)command;
- (void)restorePurchases:(CDVInvokedUrlCommand *)command;
//- (void)canMakePurchase:(CDVInvokedUrlCommand *)command;
//- (void)getPending:(CDVInvokedUrlCommand *)command;

@end
