//
//  ViewController.swift
//  Ultra
//  Client for Music
//
//  Created by Justin Bush on 2020-08-01.
//

import Cocoa
import WebKit

class ViewController: NSViewController, NSWindowDelegate, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {

    // MARK: Objects
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var backgroundWebView: WKWebView!
    @IBOutlet weak var blurView: NSVisualEffectView!

    @IBOutlet var leftConstraint: NSLayoutConstraint!           // Left WebView Constraint
    @IBOutlet var controlsBackground: NSTextField!              // Opaque Player Controls Background
    @IBOutlet var backButton: NSButton!                         // WebView Back Button
    
    @IBOutlet var progressSpinner: NSProgressIndicator!         // Launch Loading Animation
    @IBOutlet var progressBar: NSProgressIndicator!             // Launch Loading Bar
    var progressValue = 0.0                                     // Progress Value (Double)
    
    // WebView Observers
    var webViewTitleObserver: NSKeyValueObservation?            // Observer for Web Player Title
    var webViewURLObserver: NSKeyValueObservation?              // Observer for Web Player URL
    var webViewProgressObserver: NSKeyValueObservation?         // Observer for Web Player Progress
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //webView.load()
        //webView.ts(global.play)
        //webView.ts(global.async(await: 800))
        
        //webView.ts(load: .index.ts)
        //webView.load.ts(.index)
        //webView.load(.index.ts)
        initWebView()
    }
    
    
    func initWebView() {
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.setValue(false, forKey: "drawsBackground")      // Hide WebView Background
        webView.allowsLinkPreview = false                       // Disable Link Previews
        webView.allowsMagnification = false                     // Disable Magnification (CSS Handled)
        webView.allowsBackForwardNavigationGestures = false     // Disable Back-Forward Navigation
        webView.customUserAgent = Client.userAgent              // WebView Browser UserAgent
        
        // WebKit Preferences & Configuration
        let preferences = WKPreferences()                       // WebKit Preferences
        preferences.javaScriptEnabled = true                    // Enable JavaScript
        preferences.javaScriptCanOpenWindowsAutomatically = true
        webView.configuration.preferences = preferences
        let configuration = WKWebViewConfiguration()            // WebKit Configuration
        configuration.preferences = preferences
        configuration.allowsAirPlayForMediaPlayback = true      // Enable WebKit AirPlay
        configuration.applicationNameForUserAgent = Client.name // App Name

        // JavaScript Event Listeners
        webView.configuration.userContentController.add(self, name: "loadListener")
        webView.configuration.userContentController.add(self, name: "audioListener")
        
        // Initialize Ultra Web Contents
        webView.load(Music.url)     // Load Apple Music Web Player
        playerWillLoad()            // Call Player Loader w/ Animations
    }
    

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

