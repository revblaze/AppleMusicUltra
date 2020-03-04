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
        
        // WebView URL Observer (Detect Changes)
        /*
        webViewURLObserver = loginWebView?.observe(\.url, options: .new) { loginWebView, change in
            let url = "\(String(describing: change.newValue))"
            ViewController().urlChange(urlString: url)
        }
 */
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.delegate = self
        self.view.window?.title = "Apple Music Login"
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
        loginWebView = newWebView // What is the reference for?
        
        //let config = loginWebView?.configuration.preferences
        
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
        
        // This one works
        webViewURLObserver = loginWebView?.observe(\.url, options: .new) { loginWebView, change in
            let url = "\(String(describing: change.newValue))"
            ViewController().urlChange(urlString: url)
        }
        /*
        webViewURLObserver = newWebView.observe(\.url, options: .new) { newWebView, change in
            let url = "\(String(describing: change.newValue))"
            ViewController().urlChange(urlString: url)
        }*/
        
        
    }
    
    func urlChange(urlString: String) {
        // Fix Optional URL String
        var url = urlString.replacingOccurrences(of: "Optional", with: "")
        let brackets: Set<Character> = ["(", ")"]
        url.removeAll(where: { brackets.contains($0) })
        
        print("Login URL:", url)
    }
    
    func closeLoginPrompt() {
        print("url we made it this far")
        
        loginWebView = nil
        loginWebView?.removeFromSuperview()
        //self.view.window!.performClose(nil)
        //self.view.window!.windowController!.close()
        self.dismiss(self)
        //dismiss(self)
    }
    
    
    /*
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let title = loginWebView?.title
        //if title != "Drag & Drop Website Builder – UWeb.io" {
            //titleBar.stringValue = title!
            titleBar.drawsBackground = true
            titleBar.backgroundColor = NSColor.clear
            view.addSubview(self.titleBar)
        //}
    }
 */
    
}

