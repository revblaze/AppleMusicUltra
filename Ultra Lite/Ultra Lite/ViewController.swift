//
//  ViewController.swift
//  Ultra Lite
//
//  Created by Justin Bush on 2020-05-22.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Cocoa
import WebKit

/// When `true`, enables debug functions and console logs
let debug = true

class ViewController: NSViewController, NSWindowDelegate, WKUIDelegate, WKNavigationDelegate {

    // MARK: Objects & Variables
    @IBOutlet var webView: WKWebView!
    @IBOutlet var fxView: WKWebView!
    @IBOutlet var blurView: NSVisualEffectView!
    
    @IBOutlet var splashView: NSImageView!
    @IBOutlet var splashLoader: NSProgressIndicator!
    
    // Customizer Objects
    @IBOutlet weak var customizerView: NSView!
    @IBOutlet weak var customizerButton: NSButton!
    @IBOutlet var customizerConstraint: NSLayoutConstraint!
    
    // WebView Observers
    var webViewTitleObserver: NSKeyValueObservation?            // Observer for Web Player Title
    var webViewURLObserver: NSKeyValueObservation?              // Observer for Web Player URL
    var loginWebViewURLObserver: NSKeyValueObservation?         // Observer for Login Window URL
    
    // Window Objects
    let windowController = WindowController()                   // Window Controller
    
    // Login Controller Objects
    private var loginWebView: WKWebView?                        // Login WebView
    private var loginWindowController: LoginWindowController?   // Login Popup Window
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*
        splashView.alphaValue = 0
        splashLoader.alphaValue = 0
        */
        
        showLoader(true)
        
        // OBSERVER: WebView URL (Detect Changes)
        webViewURLObserver = webView.observe(\.url, options: .new) { [weak self] webView, change in
        let url = "\(String(describing: change.newValue))"
        self?.urlDidChange(url); }
        
        initWebView()
        initFXView()
        initBlurView()
    }
    
    
    
    // MARK:- URL Manager
    /// Called when the WKWebView's absolute `URL` value changes
    func urlDidChange(_ urlString: String) {
        let url = Clean.url(urlString)          // Fix Optional URL String
        if debug { print("URL:", url) }         // Debug: Print URL to load
    }
    
    
    
    
    
    // MARK:- WebView Manager
    
    func initWebView() {
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.setValue(false, forKey: "drawsBackground")      // Hide WebView Background
        webView.allowsLinkPreview = false                       // Disable Link Previews
        webView.allowsMagnification = false                     // Disable Magnification (CSS Handled)
        webView.allowsBackForwardNavigationGestures = true     // Disable Back-Forward Navigation
        webView.customUserAgent = Ultra.userAgent               // WebView Browser UserAgent
        // WebKit Preferences & Configuration
        let preferences = WKPreferences()                       // WebKit Preferences
        preferences.javaScriptEnabled = true                    // Enable JavaScript
        preferences.javaScriptCanOpenWindowsAutomatically = true
        let configuration = WKWebViewConfiguration()            // WebKit Configuration
        configuration.preferences = preferences
        configuration.allowsAirPlayForMediaPlayback = true      // Enable WebKit AirPlay
        configuration.applicationNameForUserAgent = "Ultra"     // App Name
        let webController = WKUserContentController()
        webView.configuration.userContentController = webController
        //webView.alphaValue = 0                                  // Hide WebView on Launch
        
        webView.load(Ultra.url)
    }
    
    var wasCalled = false
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        if !wasCalled {
            let js = Script.toJS("style")
            // DEBUG: Completion error
            webView.evaluateJavaScript(js, completionHandler: nil)
            wasCalled = true
        }
        print("webView didCommit")
        //showLoader(true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        showLoader(false)
    }

    
    
    
    
    // MARK:- FX Manager
    
    func initFXView() {
        fxView.navigationDelegate = self
        fxView.uiDelegate = self
        //fxView.setValue(false, forKey: "drawsBackground")      // Hide WebView Background
        fxView.allowsLinkPreview = false                       // Disable Link Previews
        fxView.allowsMagnification = false                     // Disable Magnification (CSS Handled)
        fxView.allowsBackForwardNavigationGestures = true     // Disable Back-Forward Navigation
        
        fxView.loadFile("index", path: "WebFX")
    }
    
    
    
    // MARK:– Blur Manager
    
    func initBlurView() {
        blurView.material = .light //.menu
    }
    
    
    
    // MARK: Loader
    func showLoader(_ show: Bool) {
        var opacity = CGFloat(0)
        if show { opacity = 1 }
        splashLoader.startAnimation(show)
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 0.5
            splashView.alphaValue = opacity
            splashLoader.alphaValue = opacity
        }, completionHandler: { () -> Void in
            if !show {
                self.splashLoader.stopAnimation(true)
                /*
                self.splashLoader.alphaValue = 0
                self.splashView.alphaValue = 0
                */
            }
        })
    }
    
    
    
    
    // MARK:- Login Manager
    // Catch Apple auth request and present Login window
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url?.absoluteString
        if !User.isSignedIn {
            if let isAuth = url?.contains("idmsa.apple.com/IDMSWebAuth/") {
                if webView === loginWebView && isAuth {
                    self.presentLoginScreen(with: loginWebView!) }
            }
        }
        decisionHandler(.allow)
    }
    // Create new Window with Login Prompt
    private func presentLoginScreen(with loginWebView: WKWebView) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        if let loginWindowVC = storyboard.instantiateController(withIdentifier: "LoginWindow") as? LoginWindowController {
            loginWindowController = loginWindowVC
            if let loginVC = loginWindowVC.window?.contentViewController as? LoginViewController {
                loginVC.setWebView(loginWebView) }
            loginWindowVC.showWindow(self)
        }
    }
    // Creates new loginWebView instance (withWindowSize: 650 x 710)
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        loginWebView = WKWebView(frame: view.bounds, configuration: configuration)
        loginWebView!.frame = view.bounds
        self.setupConstraints(for: loginWebView!)
        loginWebView!.navigationDelegate = self
        loginWebView!.uiDelegate = self
        view.addSubview(loginWebView!)
        updateLoginStatus()
        return loginWebView!
    }
    
    /*
    private func getConfiguredWebview() -> WKWebView {
        let config = WKWebViewConfiguration()
        let js = "document.querySelectorAll('.web-navigation__auth-button')[0].addEventListener('click', function(){ window.webkit.messageHandlers.clickListener.postMessage('Do something'); })"
        let script = WKUserScript(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: false)

        
        //config.userContentController.addUserScript(script)
        //config.userContentController.add(self, name: "clickListener")
        

        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }
    */
    
    // MARK: Account Status Manager
    /// Checks and updates user login status, updating `User.isSignedIn` when applicable
    func updateLoginStatus() {
        webView.evaluateJavaScript(Script.loginButton, completionHandler: { (key, error) in
            if let key = key as? Int { LoginHelper.checkStatusAndUpdate(key) }
            if let error = error {
                if debug { print("UpdateLoginStatus Error: \(error.localizedDescription)") }
            }
        })
        /*
        webView.evaluate(script: Script.loginButton, completion: { (key, error) in
            if let key = key as? Int { LoginHelper.checkStatusAndUpdate(key) }
            if let error = error {
                if debug { print("UpdateLoginStatus Error: \(error.localizedDescription)") }
            }
        })
        */
    }
    /// Checks to see if the user is logged in and sets `User.isSignedIn`; closes `LoginWindow` if `true`
    func checkLoginAndCloseWindow() {
        updateLoginStatus()         // Check value, then update User.isSignedIn & Active.isSignedIn
        // Check if LoginWindow is key or visible
        let key = loginWindowController?.window?.isKeyWindow ?? false
        let vis = loginWindowController?.window?.occlusionState.contains(.visible) ?? false
        if LoginHelper.isWindowVisible(key: key, visible: vis) && LoginHelper.activeAccount() {
            App.keyWindow?.performClose(self)
        }
        if debug { LoginHelper.printDebug(key: key, vis: vis) }
    }
    
    
    

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

