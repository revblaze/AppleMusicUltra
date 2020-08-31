//
//  ViewController.swift
//  Ultra
//
//  Created by Justin Bush on 2020-08-01.
//

import Cocoa
import WebKit

/// When `true`, enables debug functions and console logs
let debug = true

class ViewController: NSViewController, NSWindowDelegate, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler, Customizable {

    // MARK: Objects & Variables
    @IBOutlet var webView: WKWebView!                       // Player WebView
    @IBOutlet var fxWebView: WKWebView!                     // Effects WebView
    @IBOutlet var blurView: NSVisualEffectView!             // Global Blur Overlay
    @IBOutlet var leftConstraint: NSLayoutConstraint!       // Left WebView Constraint
    @IBOutlet var playerBG: NSTextField!                    // Opaque for Player Background
    @IBOutlet var backButton: NSButton!                     // WebView Back Button
    
    @IBOutlet var progressSpinner: NSProgressIndicator!     // Launch Loading Animation
    @IBOutlet var progressBar: NSProgressIndicator!         // Launch Loading Bar
    var progressValue = 0.0                                 // Progress Value (Double)
    
    // Customizer Objects
    @IBOutlet weak var customizerView: NSView!              // Customizer Container View
    @IBOutlet weak var customizerButton: NSButton!          // Toggle Customizer Button
    @IBOutlet var customizerConstraint: NSLayoutConstraint! // Customizer Constraint
    
    // WebView Observers
    var webViewTitleObserver: NSKeyValueObservation?        // Observer for Web Player Title
    var webViewURLObserver: NSKeyValueObservation?          // Observer for Web Player URL
    var webViewProgressObserver: NSKeyValueObservation?     // Observer for Web Player Progress

    // Window Objects
    let windowController = WindowController()               // Window Controller
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressBar.doubleValue = progressValue
        backButton.alphaValue = 0
        
        // MARK: Observers
        webViewURLObserver = webView.observe(\.url, options: .new) { [weak self] webView, change in
            self?.urlDidChange("\(String(describing: change.newValue))") }
        webViewProgressObserver = webView.observe(\.estimatedProgress, options: .new) { [weak self] webView, change in
            self?.progressDidChange(change.newValue ?? 1.0) }
        webViewTitleObserver = webView.observe(\.title, options: .new) { [weak self] webView, change in
            if let title = change.newValue as? String { self?.titleDidChange(title) }
        }
        
        Theme.initLaunch()  // Initialize Theme
        
        initWebView()       // CoreController/Launch/LoadWebView
        initFXWebView()     // CoreController/Launch/LoadFXWebView
        initCustomizer()    // CoreController/Launch/LoadCustomizer
        
        if !User.isSignedIn { playerBG.isHidden = true }
        
    }
    
    override func viewWillDisappear() {
        Theme.save()
    }
    
    
    
    // MARK:- WebView Setup
    
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
    
    /// Injects base CSS (`style.css`) into webView
    func injectCSS() {
        let js = Script.toJS(file: "style")
        webView.evaluateJavaScript(js)
    }
    // 1. didProvisional: Fired when webView receives a request to load content
    var initLaunch = true
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if initLaunch { playerWillLoad(); initLaunch = false }
    }
    // 2. didCommit: Fired when the webView begins to load and render content
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        Debug.log("webView didCommit")
        injectCSS()
    }
    // 3. didFinish: Fired when the web content
    var wasCalled = false
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Debug.log("webView didFinish")
        addEventListeners(forState: .active)
        if !wasCalled { playerDidLoad(); wasCalled = true }
        
    }
    
    
    
    
    // MARK: JS Event Handler
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let result = message.body as? String {
            print("> \(message.name): \(result)")
        }
        
        if message.name == "audioListener" {
            // Audio Event Handler
        }
    }
    
    
    
    // MARK:- Segue & Navigation
    // Prepare Storyboard for Segue
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if debug { print("Segue Performed for: \(segue)") }
        if segue.identifier == "CustomizerSegue" {
            let customizer = segue.destinationController as! CustomizerViewController
            customizer.delegate = self          // Assign Customizer delegate to self
        }
    }
    
    

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

