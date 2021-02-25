//
//  ViewController.swift
//  Ultra
//
//  Created by Justin Bush on 2021-02-25.
//

import Cocoa
import WebKit

class ViewController: NSViewController, NSWindowDelegate, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {

    // MARK: Objects & Variables
    @IBOutlet var webView: WKWebView!                       // Player WebView
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    // MARK:- JavaScript Event Handler
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let result = message.body as? String {
            print("> \(message.name): \(result)")
        }
        
        if message.name == "audioListener" {
            // Audio Event Handler
        }
    }
    
    

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

