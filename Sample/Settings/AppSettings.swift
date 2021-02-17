//
//  AppSettings.swift
//  Sample
//
//  Created by Thomas Tong on 17/2/2021.
//

import Foundation

class AppSettings {
    
    /*
     * Dummy URLs for return and cancel, these will be provided when creating the Payment.
     * Once payment is finished on Crypto.com Pay payment page, it will redirect.
     * The WebView will need to capture these redirects, refer to SwiftUIWebView
     * and Crypto.com Pay's Payment API for more info.
     */
    static var returnUrl = "https://return.pay.crypto.dummy/"
    static var cancelUrl = "https://cancel.pay.crypto.dummy/"
    
}
