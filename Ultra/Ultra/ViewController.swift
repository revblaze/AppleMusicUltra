//
//  ViewController.swift
//  Ultra
//
//  Created by Justin Bush on 2021-05-27.
//

import Cocoa
import WebKit

class ViewController: NSViewController, NSWindowDelegate, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
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


}

