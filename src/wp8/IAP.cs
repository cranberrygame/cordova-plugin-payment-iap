/*
 * A phonegap plugin to enable WP8 In-App Purchases.
 * Author: Toby Kavukattu
 * Version: 0.1
 * License: MIT
 * 
 * Based on the iOS plugin by Matt Kane & Guillaume Charhon
 * https://github.com/phonegap/phonegap-plugins/tree/master/iOS/InAppPurchaseManager)
 * https://github.com/usmart/InAppPurchaseManager-EXAMPLE)
 */

using System;
using System.Windows;
using System.Runtime.Serialization;
using WPCordovaClassLib.Cordova;
using WPCordovaClassLib.Cordova.Commands;
using WPCordovaClassLib.Cordova.JSON;
using System.Diagnostics; //Debug.WriteLine
//
using System.Windows.Controls;
using Microsoft.Phone.Controls;
//#if DEBUG
//using MockIAPLib;
//using Store = MockIAPLib;
//#else
using Windows.ApplicationModel.Store;
using Store = Windows.ApplicationModel.Store;
//#endif
using System.IO;
using System.Windows.Threading;
using System.Runtime.Serialization.Json;
using System.Collections;
using System.Collections.Generic;

namespace Cordova.Extension.Commands
{
    public class IAP : BaseCommand
    {
        //public void setup(string args)
        //{
        //    this.DispatchCommandResult(new PluginResult(PluginResult.Status.OK)); 
        //}

        public class Product
        {
            public string productId { get; set; }
            public string title { get; set; }
            public string description { get; set; }
            public string price { get; set; }
        }
				
        public async void requestStoreListing(string args)
        {
			try
			{
				ListingInformation li = await Store.CurrentApp.LoadListingInformationAsync();
				List<string> products = new List<string>();
		
				foreach (string key in li.ProductListings.Keys)
				{
					//http://msdn.microsoft.com/en-us/library/windows/apps/windows.applicationmodel.store.productlisting?cs-save-lang=1&cs-lang=csharp#code-snippet-2
					ProductListing pl = li.ProductListings[key];

					//https://github.com/wildabeast/BarcodeScanner/blob/c3090dcf5347c1cc10caaeff225bb2c0a0deeede/src/wp8/BarcodeScanner.cs
					Product p = new Product
					{
						productId = pl.ProductId,
						title = pl.Name,
						description = pl.Description,
						price = pl.FormattedPrice
					};
					string json = JsonHelper.Serialize(p);
					products.Add(json);
				}

				if (products.Count > 0)
				{
					DispatchCommandResult(new PluginResult(PluginResult.Status.OK, JsonHelper.Serialize( products.ToArray() )));
				}
			}
			catch (Exception)
			{
				DispatchCommandResult(new PluginResult(PluginResult.Status.ERROR, "Unknown Error"));
			}
		}
		
        public async void purchaseProduct(string args)
        {
            string productId = JsonHelper.Deserialize<string[]>(args)[0];		
            Debug.WriteLine("productId: " + productId);
			
			if (!CurrentApp.LicenseInformation.ProductLicenses[productId].IsActive)
			{
				try
				{
					//show the purchase screen
					var receipt = await CurrentApp.RequestProductPurchaseAsync(productId, true);
					if (CurrentApp.LicenseInformation.ProductLicenses[productId].IsActive)
					{
						DispatchCommandResult(new PluginResult(PluginResult.Status.OK, ""));
					}
				}
				catch
				{		
					DispatchCommandResult(new PluginResult(PluginResult.Status.ERROR, "Unknown Error"));
				}
			}
			else
			{
				//Already owns the product
			}			
        }

        public async void consumeProduct(string args)
        {
            string productId = JsonHelper.Deserialize<string[]>(args)[0];		
            Debug.WriteLine("productId: " + productId);
			
			if (!CurrentApp.LicenseInformation.ProductLicenses[productId].IsActive)
			{
				try
				{
					CurrentApp.ReportProductFulfillment(productId);

					DispatchCommandResult(new PluginResult(PluginResult.Status.OK, ""));
				}
				catch
				{		
					DispatchCommandResult(new PluginResult(PluginResult.Status.ERROR, "Unknown Error"));
				}
			}
			else
			{
				//Already owns the product
			}			
        }

		public async void restorePurchases(string args)
        {
			try
			{
				ListingInformation li = await Store.CurrentApp.LoadListingInformationAsync();
				List<string> products = new List<string>();
		
				foreach (string key in li.ProductListings.Keys)
				{
					ProductListing pl = li.ProductListings[key];

					if (CurrentApp.LicenseInformation.ProductLicenses[key].IsActive)
					{		
						//https://github.com/wildabeast/BarcodeScanner/blob/c3090dcf5347c1cc10caaeff225bb2c0a0deeede/src/wp8/BarcodeScanner.cs
						Product p = new Product
						{
							productId = pl.ProductId,
							title = pl.Name,
							description = pl.Description,
							price = pl.FormattedPrice
						};
						string json = JsonHelper.Serialize(p);
						products.Add(json);						
					}
				}

				if (products.Count > 0)
				{
					DispatchCommandResult(new PluginResult(PluginResult.Status.OK, JsonHelper.Serialize( products.ToArray() )));					
				}
			}
			catch (Exception)
			{
				DispatchCommandResult(new PluginResult(PluginResult.Status.ERROR, "Unknown Error"));
			}	
        }		
    }
}