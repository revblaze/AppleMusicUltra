//
//  CustomizerViewController.swift
//  Ultra
//
//  Created by Justin Bush on 2021-06-26.
//

import Cocoa
import WebKit

class CustomizerViewController: NSViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var closeButton: NSButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.create()
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.configuration.userContentController.add(self, name: "eventListeners")
        webView.load(file: "images", path: "WebContent/Customizer")
        
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "eventListeners" {
            if let message = message.body as? String {
                if debug { print("[Customizer] > \(message)") }
                
            }
        }
    }
    
}


extension WKWebView {
    func create() {
        self.allowsLinkPreview = false
        self.allowsMagnification = false
        self.allowsBackForwardNavigationGestures = false
        self.setValue(false, forKey: "drawsBackground")
    }
}
