//
//  WebView.swift
//  Sample
//
//  Created by Thomas Tong on 8/2/2021.
//

import SwiftUI
import WebKit

struct SwiftUIWebView: UIViewRepresentable {
    
    @Binding var url: URL?
    @Binding var showSheet: Bool
    @Binding var successResult: Bool
    
    func makeUIView(context: Context) -> WKWebView {
        
        /*
         * Enable JavaScript and load `payment_url` when creating the WebView.
         */
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        
        return WKWebView(
            frame: .zero,
            configuration: config
        )
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let myURL = url else {
            return
        }
        
        let request = URLRequest(url: myURL)
        uiView.navigationDelegate = context.coordinator
        uiView.load(request)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: SwiftUIWebView
        
        init(_ parent: SwiftUIWebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView,
                     decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            
            let navUrl = navigationAction.request.url!.absoluteURL
            
            /*
             * The WebView needs to capture and handle the following redirects:
             * 1. if URLs contains "monaco://", it is a URL scheme to open Crypto.com App
             * 2. if it is redirecting to `return_url`, then the Payment is succeeded
             * 3. if it is redirection to `cancel_url`, then the Payment is cancelled or failed
             * 4. for other page navigation, allow the request
             */
            if !navUrl.absoluteString.hasPrefix("http://"),
               !navUrl.absoluteString.hasPrefix("https://"),
               UIApplication.shared.canOpenURL(navUrl) {
                
                // have UIApplication handle the url
                UIApplication.shared.open(navUrl, options: [:], completionHandler: nil)
                decisionHandler(.cancel)
            }
            else if navUrl.absoluteString == AppSettings.returnUrl {
                self.parent.successResult = true
                self.parent.showSheet = false
                decisionHandler(.cancel)
            }
            else if navUrl.absoluteString == AppSettings.cancelUrl {
                self.parent.showSheet = false
                decisionHandler(.cancel)
            }
            else {
                decisionHandler(.allow)
            }
        }
    }
}
