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
        
        //backgroundView.layer?.backgroundColor = NSColor(red: 0.00, green: 0.48, blue: 1.00, alpha: 1.00)
        backgroundView.layer?.backgroundColor = CGColor(red: 0.00, green: 0.48, blue: 1.00, alpha: 1.00)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        webView.loadTS()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.ts(.didLoad())
    }

    
    
    // MARK: JavaScript Message Handler
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if message.name == "eventListeners" {
            if let message = message.body as? String {
                if debug { print("> \(message)") }
                //handleJS(message)
            }
        }
    }
    
    
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

