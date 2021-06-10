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
    
    // Observers
    var webViewURLObserver: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initWebView()
        
        webViewURLObserver = webView.observe(\.url, options: .new) { [weak self] webView, change in
            self?.urlDidChange("\(String(describing: change.newValue))") }
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

