//
//  CustomizerViewController.swift
//  Ultra
//
//  Created by Justin Bush on 2020-08-03.
//

import Cocoa
import WebKit

protocol Customizable: class {
    func toggleCustomizer()
    func loadFX()
    func fadeOnSelect()
}

/// When `true`, enables debug functions and console logs
let debugLegacy = false

class CustomizerViewController: NSViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {

    weak var delegate: Customizable?

    // Customizer Objects
    @IBOutlet var customizerWebView: WKWebView!                 // Customizer Side Bar
    @IBOutlet weak var customizerControl: NSSegmentedControl!   // Customizer Page Switch Control
    @IBOutlet weak var customizerBlur: NSVisualEffectView!      // Customizer Switch Blur Effect

    @IBAction func closeCustomizer(_ sender: Any) { delegate?.toggleCustomizer() }
    
    // WebView Observers
    var customizerURLObserver: NSKeyValueObservation?           // Observer for Customizer URL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCustomizer()
    }
    
    
    func initCustomizer() {
        // Customizer WebView Setup
        customizerWebView.navigationDelegate = self
        customizerWebView.uiDelegate = self
        customizerWebView.setValue(false, forKey: "drawsBackground")    // Hide WebView Background
        customizerWebView.allowsLinkPreview = false                     // Hide Link Previews
        customizerWebView.allowsMagnification = false                   // Hide Magnification (CSS Handled)
        customizerWebView.allowsBackForwardNavigationGestures = false   // Disable Back-Forward Navigation
        // WebKit Preferences & Configuration
        let preferences = WKPreferences()               // WebKit Preferences
        preferences.javaScriptEnabled = true            // Enable JavaScript
        // Receive JS calls from Customizer for setting Styles & Themes
        customizerWebView.configuration.userContentController.add(self, name: "jsHandler")
        // Load Customizer: Theme & Style Manager
        initWebCustomizer()
        //customizerWebView.loadFile("themes", path: "WebCustomizer")
        // Customizer Segment Control
        customizerControl.selectedSegment = 0           // Customizer Default: Themes (First Tab)
        customizerBlur.material = .menu                 // Set Customizer Blur Effect
        
        /* Adds Shadow to WKWebView (cool effect on transparent WKWebView)
        customizerWebView.layer?.shadowColor = CGColor.black
        customizerWebView.layer?.shadowOffset = CGSize(width: -3, height: -3)
        customizerWebView.layer?.shadowOpacity = 0.7
        customizerWebView.layer?.shadowRadius = 0.3 */
        
        // OBSERVER: WebView URL (Detect Changes)
        customizerURLObserver = customizerWebView.observe(\.url, options: .new) { [weak self] webView, change in
            let url = "\(String(describing: change.newValue))"; self?.urlDidChange(url) }
    }
    
    func initWebCustomizer() {
        var path = "WebContent/WebCustomizer"
        if debugLegacy { path = "WebContent/WebCustomizer/Legacy" }
        else {
            if #available(OSX 10.14, *) { path = "WebContent/WebCustomizer" }
            else { path = "WebContent/WebCustomizer/Legacy" }
        }
        customizerWebView.loadFile("themes", path: path)
            
    }
    
    /// Called when the WKWebView's absolute URL value changes
    func urlDidChange(_ urlOptional: String) {
        let url = Clean.url(urlOptional)            // Fix Optional URL String
        Debug.log("Customizer Page: \(url.removePath())")
    }
    
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        var makeTransparent = false
        if message.name == "jsHandler" {                            // Check if JS call is from jsHandler
            if debug { print("JS: \(message.body)") }               // Debug: Print jsHandler.value
            if var jsCall = message.body as? String {               // jsCall: JS callback value
                if jsCall == "close" { delegate?.toggleCustomizer() }       // Close JS syntax "close()"
                else if jsCall == "clear"  { makeTransparent = true }       // Set Style as Transparent
                //else if jsCall == "custom" { delegate?.setCustomTheme() }   // Prompt user for custom image
                else if jsCall == "custom" { Debug.log("Custom theme unavailable") }
                else if jsCall.contains(".style") {                 // Style JS syntax "name.style"
                    jsCall.removeLast(6)                            // Remove ".style" from jsCall
                    let style = Style.get(jsCall)                   // Get matching style value
                    Theme.style = style }                           // Save Style value
                else if jsCall.contains(".dynamic") {
                    jsCall.removeLast(8)
                    Theme.name = jsCall
                    Theme.raw = jsCall
                    //Theme.style =
                } else {
                    let raw = jsCall + ".jpg"
                    Theme.raw = raw
                }
                Theme.isTransparent = makeTransparent
                delegate?.fadeOnSelect()        // Trigger Fade on Theme/Style change
                delegate?.loadFX()              // Update Theme/Style in main ViewController
                
                
            }
        }
    }
    
    
    // Handles Customizer Page Segment Control
    @IBAction func customizerControlPressed(_ sender: NSSegmentedControl) {
        var page = "themes"         // Default: Themes (Tab 1)
        switch customizerControl.selectedSegment {
        case 0: page = "themes"     // Tab 1: Themes (default)
        case 1: page = "styles"     // Tab 2: Styles
        case 2: print("dynamic")    // Tab 3: Dynamic ? Video
        default:print("url x") }
        // Load selected page in CustomizerWebView
        if debugLegacy { customizerWebView.loadFile(page, path: "WebContent/WebCustomizer/Legacy") }
        else {
            if #available(OSX 10.14, *) { customizerWebView.loadFile(page, path: "WebContent/WebCustomizer") }
            else { customizerWebView.loadFile(page, path: "WebContent/WebCustomizer/Legacy") }
        }
    }
    
}


