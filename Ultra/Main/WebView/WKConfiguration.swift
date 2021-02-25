//
//  WKConfiguration.swift
//  Ultra
//
//  Created by Justin Bush on 2021-02-25.
//

import Foundation
import WebKit

// MARK: WebView Configuration
// WebKit initializers and configuration
extension ViewController {
    
    /// Initialize main `WebView` client for UWeb
    func initWebView() {
        webView.uiDelegate = self                           // Set WebView UI Delegate
        webView.navigationDelegate = self                   // Set WebView Navigation Delegate
        webView.allowsLinkPreview = false                   // Disable Link Preview
        webView.allowsMagnification = false                 // Disable Magnification
        webView.allowsBackForwardNavigationGestures = false // Disable Back-Forward Gestures
        //webView.customUserAgent = Client.userAgent          // Set Client UserAgent
        // WebView Configuration
        //webView.configuration.applicationNameForUserAgent = Client.name
        // JavaScript Event Listeners
        webView.configuration.userContentController.add(self, name: "eventListeners")
        webView.setValue(false, forKey: "drawsBackground")
        // Load UWeb
        //webView.load(Client.url)
        
        //initBackButton()
    }
    
}
