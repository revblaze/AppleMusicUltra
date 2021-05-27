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
        webView.uiDelegate = self                               // Set WebView UI Delegate
        webView.navigationDelegate = self                       // Set WebView Navigation Delegate
        // WebView Configuration
        webView.allowsLinkPreview = false                       // Disable Link Preview
        webView.allowsMagnification = false                     // Disable Magnification
        webView.allowsBackForwardNavigationGestures = false     // Disable Back-Forward Gestures
        webView.setValue(false, forKey: "drawsBackground")      // Set Transparent WebView Background
        webView.customUserAgent = Client.userAgent              // Set Client UserAgent
        let preferences = WKPreferences()                       // WebKit Preferences
        preferences.javaScriptEnabled = true                    // Enable JavaScript
        preferences.javaScriptCanOpenWindowsAutomatically = true
        webView.configuration.preferences = preferences
        let configuration = WKWebViewConfiguration()            // WebKit Configuration
        configuration.preferences = preferences
        configuration.allowsAirPlayForMediaPlayback = true      // Enable WebKit AirPlay
        webView.configuration.applicationNameForUserAgent = Client.name
        // JavaScript Event Listeners
        webView.configuration.userContentController.add(self, name: "eventListeners")
        // Load Apple Music
        webView.load(Client.url)
        //initBackButton()
    }
    
}
