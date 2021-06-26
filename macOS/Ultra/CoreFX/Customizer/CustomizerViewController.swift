//
//  CustomizerViewController.swift
//  Ultra
//
//  Created by Justin Bush on 2021-06-26.
//

import Cocoa
import WebKit

var wallpaperName = "monterey"

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
                wallpaperName = message
                NotificationCenter.default.post(Notification(name: .setWallpaper))
            }
        }
    }
    
}

enum Images: String {
    case monterey
    case wave
    case spring
    case dunes
    case quartz
    case silk
    case bubbles
    case goblin
    case purple
    //case custom
}


extension WKWebView {
    func create() {
        self.allowsLinkPreview = false
        self.allowsMagnification = false
        self.allowsBackForwardNavigationGestures = false
        self.setValue(false, forKey: "drawsBackground")
    }
}
