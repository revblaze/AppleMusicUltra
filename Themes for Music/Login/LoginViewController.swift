//
//  LoginViewController.swift
//  Themes for Music
//
//  Created by Justin Bush on 2020-03-21.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Cocoa
import WebKit

class LoginViewController: NSViewController, WKUIDelegate, WKNavigationDelegate, NSWindowDelegate {

    // Variables
    var loginWebView: WKWebView?
    
    // WebView URL Observer
    var webViewURLObserver: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginWebView?.uiDelegate = self
        loginWebView?.navigationDelegate = self
    }
    
    /* TEST COMMENTING THIS OUT */
    override func viewDidAppear() {
        super.viewDidAppear()
        view.window?.delegate = self
        view.window?.title = "Apple Music Login"
        view.window?.level = .floating              // Keep as key window (front)
    }
    
    // Set login webview
    func setWebView(_ newWebView: WKWebView) {
        newWebView.navigationDelegate = self
        newWebView.uiDelegate = self
        // Add as subview, update constraints and bring to the top
        newWebView.frame = view.bounds
        newWebView.customUserAgent = Music.userAgent
        newWebView.configuration.applicationNameForUserAgent = Music.userAgent
        view.addSubview(newWebView)
        self.setupConstraints(for: newWebView)
        loginWebView = newWebView
        
        loginWebView?.allowsLinkPreview = false
        loginWebView?.allowsMagnification = false
        loginWebView?.allowsBackForwardNavigationGestures = false
        loginWebView?.configuration.preferences.javaScriptEnabled = true
        loginWebView?.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        loginWebView?.customUserAgent = Music.userAgent
        loginWebView?.configuration.applicationNameForUserAgent = Music.userAgent
        
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        webViewURLObserver = loginWebView?.observe(\.url, options: .new) { loginWebView, change in
            let url = "\(String(describing: change.newValue))"
            ViewController().urlDidChange(urlString: url) }
    }
    
}



/// MARK: NSViewController extantion for constraints
extension NSViewController {
    /// Setup constraints for webview, it should be clip to bounds of the screen
    func setupConstraints(for webview: WKWebView) {
        
        webview.translatesAutoresizingMaskIntoConstraints = false
        // Add constraints to main ViewController view
        if let superView = webview.superview {
            // Top
            superView.addConstraints([NSLayoutConstraint(item: webview,
                                                         attribute: .top,
                                                         relatedBy: .equal,
                                                         toItem: superView,
                                                         attribute: .top,
                                                         multiplier: 1.0,
                                                         constant: 0.0)])
            // Bottom
            superView.addConstraints([NSLayoutConstraint(item: webview,
                                                         attribute: .bottom,
                                                         relatedBy: .equal,
                                                         toItem: superView,
                                                         attribute: .bottom,
                                                         multiplier: 1.0,
                                                         constant: 0.0)])
            // Left
            superView.addConstraints([NSLayoutConstraint(item: webview,
                                                         attribute: .left,
                                                         relatedBy: .equal,
                                                         toItem: superView,
                                                         attribute: .left,
                                                         multiplier: 1.0,
                                                         constant: 0.0)])
            // Right
            superView.addConstraints([NSLayoutConstraint(item: webview,
                                                         attribute: .right,
                                                         relatedBy: .equal,
                                                         toItem: superView,
                                                         attribute: .right,
                                                         multiplier: 1.0,
                                                         constant: 0.0)])
            
        }
    }
    
}
