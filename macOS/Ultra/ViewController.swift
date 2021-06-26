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
    @IBOutlet weak var customizerView: NSView!
    @IBOutlet weak var customizerConstraint: NSLayoutConstraint!
    @IBOutlet weak var customizerButton: NSButton!
    
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
        initFXView()
        
        // Set Observers
        webViewURLObserver = webView.observe(\.url, options: .new) { [weak self] webView, change in
            self?.urlDidChange("\(String(describing: change.newValue))") }
    }
    
    override func viewDidAppear() {
        
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        webView.loadTS()
        //webView.loadCSS()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.ts(.didLoad())
        //webView.loadCSS()
        print("webView didFinish")
        //toggleCustomizer()
        
    }
    
    func initFXView() {
        let image = NSImage(imageLiteralResourceName: "monterey")
        fxView.setImage(image)
    }
    
    @IBAction func onToggleCustomizer(_ sender: Any) { toggleCustomizer() }
    
    func toggleCustomizer() {
        var alpha = CGFloat(0.7)
        var constraintWidth = CGFloat(-280)
        if customizerConstraint.constant != 0 { constraintWidth = 0; alpha = 1 }
        
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 0.25
            customizerConstraint.animator().constant = constraintWidth
            webView.animator().alphaValue = alpha
        }, completionHandler: { () -> Void in })
        
    }

    
    // MARK:- JavaScript Message Handler
    var newMessage = ""
    var lastMessage = ""
    var objectCount = 0
    var countObjects = false
    var initShowCustomizer = false
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if message.name == "eventListeners" {
            if let message = message.body as? String {
                if debug { print("> \(message)") }
                
                lastMessage = newMessage
                newMessage = message
                
                //webView.ts(.didLoad())
                if message.contains("artist-index") { webView.ts(.didLoad()) }
                
                if !initShowCustomizer && message.hasSuffix("pageDidLoad = true") {
                    toggleCustomizer()
                    initShowCustomizer = true
                }
                
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

