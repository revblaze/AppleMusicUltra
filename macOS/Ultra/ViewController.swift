//
//  ViewController.swift
//  Ultra
//
//  Created by Justin Bush on 2021-06-10.
//

import Cocoa
import WebKit

class ViewController: NSViewController, NSWindowDelegate, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
    // Views
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var fxView: FXView!
    @IBOutlet weak var backgroundView: NSView!
    // UI Elements
    @IBOutlet weak var backButton: NSButton!
    
    // Observers
    var webViewURLObserver: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize Objects & Views
        initWebView()
        initBackButton()
        
        // Set Observers
        webViewURLObserver = webView.observe(\.url, options: .new) { [weak self] webView, change in
            self?.urlDidChange("\(String(describing: change.newValue))") }
    }
    
    override func viewDidAppear() {
        backgroundView.layer?.backgroundColor = CGColor(red: 0, green: 0.48, blue: 1, alpha: 1)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        webView.loadTS()
        //webView.loadCSS()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.ts(.didLoad())
        //webView.loadCSS()
        print("webView didFinish")
        
    }

    
    // MARK:- JavaScript Message Handler
    var newMessage = ""
    var lastMessage = ""
    var objectCount = 0
    var countObjects = false
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if message.name == "eventListeners" {
            if let message = message.body as? String {
                if debug { print("> \(message)") }
                
                lastMessage = newMessage
                newMessage = message
                
                //webView.ts(.didLoad())
                if message.contains("artist-index") { webView.ts(.didLoad()) }
                
                // Auth Login Handler
                willAttemptAuth()
                if countObjects { reloadOnAuth() }
            }
            
            
            
        }
    }
    
    
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

