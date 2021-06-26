//
//  CustomizerView.swift
//  Ultra
//
//  Created by Justin Bush on 2021-06-26.
//

import Cocoa
import WebKit

class CustomizerView: NSView, WKUIDelegate, WKNavigationDelegate {

    @IBOutlet weak var closeButton: NSButton!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewWillDraw() {
        webView.create()
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.load(file: "images", path: "WebContent/Customizer")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}



