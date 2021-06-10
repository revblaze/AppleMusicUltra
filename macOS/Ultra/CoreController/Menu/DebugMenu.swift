//
//  DebugMenu.swift
//  Ultra
//
//  Created by Justin Bush on 2021-06-10.
//

import Cocoa

extension ViewController {
    
    // MARK: Debug JavaScript
    @IBAction func injectJavaScript(_ sender: NSMenuItem) {
        webView.loadTS()
    }
    
    @IBAction func runJavaScript(_ sender: NSMenuItem) {
        webView.ts(.didLoad())
    }
    
    
    // MARK:- Debug UI Elements
    @IBAction func debugToggleWebView(_ sender: NSMenuItem) {
        webView.isHidden = !webView.isHidden
    }
    
    
}
