//
//  LoginController.swift
//  Apple Music
//
//  Created by Justin Bush on 2020-03-03.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Cocoa
import WebKit

class LoginViewController: NSViewController, WKUIDelegate, WKNavigationDelegate, NSWindowDelegate {
    
    var loginWebView: WKWebView?
    @IBOutlet var titleBar: NSTextField!
    
    // WebView URL Observer
    var webViewURLObserver: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginWebView?.navigationDelegate = self
        loginWebView?.uiDelegate = self
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        view.window?.delegate = self
        view.window?.title = "Apple Music Login"
        // Keep as key window (front)
        view.window?.level = .floating
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
            ViewController().urlDidChange(urlString: url)
        }
    
        // Detect click event of Login success: Continue button
        // https://stackoverflow.com/a/53755764/1234120
        let js = "varbutton = document.getElementById('continue'); button.addEventListener('click', function() { varmessageToPost = {'ButtonId':'continue'}; window.webkit.messageHandlers.buttonClicked.postMessage(messageToPost); },false);"
        loginWebView?.evaluateJavaScript(js, completionHandler: nil)
        
        // CSS Tester for Login Popup
        //let css = "footer .footer { opacity: 0 !important; }"
        //let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
    }
    
}

