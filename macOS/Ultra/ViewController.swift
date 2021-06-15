//
//  ViewController.swift
//  Ultra
//
//  Created by Justin Bush on 2021-06-10.
//

import Cocoa
import WebKit

class ViewController: NSViewController, NSWindowDelegate, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var fxView: FXView!
    @IBOutlet weak var backgroundView: NSView!
    
    // Observers
    var webViewURLObserver: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize Objects & Views
        initWebView()
        
        // Set Observers
        webViewURLObserver = webView.observe(\.url, options: .new) { [weak self] webView, change in
            self?.urlDidChange("\(String(describing: change.newValue))") }
    }
    
    override func viewDidAppear() {
        backgroundView.layer?.backgroundColor = CGColor(red: 0.00, green: 0.48, blue: 1.00, alpha: 1.00)
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

    
    var newMessage = ""
    var lastMessage = ""
    var objectCount = 0
    var countObjects = false
    // MARK: JavaScript Message Handler
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if message.name == "eventListeners" {
            if let message = message.body as? String {
                if debug { print("> \(message)") }
                //handleJS(message)
                
                lastMessage = newMessage
                newMessage = message
                
                if lastMessage.contains("not-authenticated") && newMessage.contains("[object Object]") {
                    countObjects = true
                    if debug { print("User is attempting to login") }
                }
                
                if countObjects {
                    objectCount += 1
                    if objectCount >= 4 {
                        countObjects = false
                        if debug { print("User logged in, reloading client") }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.webView.reload()
                        }
                    }
                    
                }
                
            }
            
            
            
            
        }
    }
    
    
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

