//
//  WKConfiguration.swift
//  Ultra
//
//  Created by Justin Bush on 2021-06-10.
//

import Cocoa
import WebKit

extension ViewController {
    
    /// Initialize `webView: auth, builder, dashboard (websites & domains)`
    func initWebView() {
        webView.uiDelegate = self                               // Set WebView UI Delegate
        webView.navigationDelegate = self                       // Set WebView Navigation Delegate
        webView.allowsLinkPreview = false                       // Disable Link Preview
        webView.allowsMagnification = false                     // Disable Magnification
        webView.allowsBackForwardNavigationGestures = false     // Disable Back-Forward Gestures
        //webView.customUserAgent = Client.userAgent              // Set Client UserAgent
        // WebView Configuration
        //webView.configuration.applicationNameForUserAgent = Client.name
        // JavaScript Event Listeners
        webView.configuration.userContentController.add(self, name: "eventListeners")
        webView.setValue(false, forKey: "drawsBackground")
        //webView.load(AppleMusic.url(forPage: .listenNow))
    }
    
}

