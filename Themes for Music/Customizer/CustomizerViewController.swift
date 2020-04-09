//
//  CustomizerViewController.swift
//  Themes for Music
//
//  Created by Justin Bush on 2020-04-06.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Cocoa
import WebKit

protocol Customizable: class {
    func hideCustomizer()
    func setTransparent()
    func setCustomTheme()
    func setImage(_ image: String)
    func setStyle(_ style: Styles)
    
    func cleanURL(_ urlString: String) -> String
    func compareModes(_ style: Styles) -> Bool
}

class CustomizerViewController: NSViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {

    weak var delegate: Customizable?
    
    // Customizer Objects
    @IBOutlet var customizerWebView: WKWebView!                 // Customizer Side Bar
    @IBOutlet weak var customizerControl: NSSegmentedControl!   // Customizer Page Switch Control
    @IBOutlet weak var customizerBlur: NSVisualEffectView!      // Customizer Switch Blur Effect
    //@IBOutlet weak var closeCustomizer: NSButton!               // Close Customizer Button

    @IBAction func closeCustomizer(_ sender: Any) { delegate?.hideCustomizer() }
    
    // WebView Observers
    var customizerURLObserver: NSKeyValueObservation?           // Observer for Customizer URL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomizer()
    }
    
    override func viewDidAppear() {
        if debug {
            if delegate != nil { print("Customizable delegate is set to ViewController") }
            else { print("Error: Customizable delegate = nil")}
        }
    }
    
    // MARK: Customizer Setup
    
    func setupCustomizer() {
        // Hide Customizer UI Objects on Launch
        /*
        customizerControl.isHidden = true               // Hide Page Controller
        customizerBlur.isHidden = true                  // Hide Customizer FX
        closeCustomizer.isHidden = true                 // Hide Close Button
        customizerWebView.isHidden = true               // Hide Customizer WebView
        */
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
        customizerWebView.loadFile("themes", path: "WebCustomizer")
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
        let url = "\(String(describing: change.newValue))"
        self?.customizerURLDidChange(urlString: url) }
    }
    
    /// Called when the WKWebView's absolute URL value changes
    func customizerURLDidChange(urlString: String) {
        let url = delegate?.cleanURL(urlString)           // Fix Optional URL String
        if debug { print("Customizer Page:", url?.removePath() ?? "customizerURL returned nil") }
    }
    
    // Handles JS calls from CustomizerWebView
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "jsHandler" {                            // Check if JS call is from jsHandler
            if debug { print("JS: \(message.body)") }               // Debug: Print jsHandler.value
            if var jsCall = message.body as? String {               // jsCall: JS callback value
                if jsCall == "close" { delegate?.hideCustomizer() }           // Close JS syntax "close()"
                else if jsCall == "clear"  { delegate?.setTransparent() }     // Set Style as Transparent
                else if jsCall == "custom" { delegate?.setCustomTheme() }     // Prompt user for custom image
                else if jsCall.contains(".style") {                 // Style JS syntax "name.style"
                    jsCall.removeLast(6)                            // Remove ".style" from jsCall
                    let style = Style.toMaterial(jsCall)            // Get matching style value
                    delegate?.setStyle(style)                                 // Set Style as active
                    /* TODO: Reload WebView on Style.isDark change without interrupting music */
                    if delegate?.compareModes(style) ?? false {                        // Check: new Style.mode == current Style.mode
                        // webView.reloadFromOrigin() -> stops WebView from playing (CSS workaround for album artwork?)
                        if debug { print("Comparing Style Modes:")
                            //print("  style.isDark = \(style.isDark)  vs.  Active.style.isDark = \(darkModeIsActive())")
                        }
                    }
                } else { delegate?.setImage(jsCall) }                         // Set image background for Theme
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
        customizerWebView.loadFile(page, path: "WebCustomizer")
    }
    
}
