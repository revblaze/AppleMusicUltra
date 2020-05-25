//
//  ViewController.swift
//  Ultra
//
//  Created by Justin Bush on 2020-05-25.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Cocoa
import WebKit

/// When `true`, enables debug functions and console logs
let debug = true

var metadata = ["", "", ""]     // Saves requested metadata to memory
var artwork = ""                // Saves current artwork to memory
var nowURL  = ""                // Saves current URL to memory
var lastURL = ""                // Saves previous URL to memory
var initLaunch = true           // Determines if app just launched

class ViewController: NSViewController, NSWindowDelegate, WKUIDelegate, WKNavigationDelegate, Customizable {
    

    // MARK: Objects & Variables
    // Main View Objects
    @IBOutlet var webView: WKWebView!                           // Main Music Web Player
    @IBOutlet var blurView: NSVisualEffectView!                 // Main Background Blur Effect
    @IBOutlet var backButton: NSButton!                         // Main Back Button
    @IBOutlet var launchLoader: NSProgressIndicator!            // Progress Indicator on Launch
    @IBOutlet var leftWebViewConstraint: NSLayoutConstraint!    // Leading WebView Constraint
    // Customizer Objects
    @IBOutlet weak var fxView: WKWebView!                       // Effects Web View
    @IBOutlet weak var customizerView: NSView!                  // Customizer Container View
    @IBOutlet weak var customizerButton: NSButton!              // Bottom Right Customizer Button
    @IBOutlet var customizerConstraint: NSLayoutConstraint!     // Customizer -> Super Constraint
    // Window Objects
    let windowController = WindowController()                   // Window Controller
    // Login Controller Objects
    private var loginWebView: WKWebView?                        // Login WebView
    private var loginWindowController: LoginWindowController?   // Login Popup Window
    
    // Walkthrough Controller Object
    //var introWindowController: WalkthroughWindowController?
    
    // WebView Observers
    var webViewURLObserver: NSKeyValueObservation?              // Observer for Web Player URL
    var webViewTitleObserver: NSKeyValueObservation?            // Observer for Web Player Title
    
    // ViewController Default Values
    var webAlphaFade = CGFloat(0.7)                             // WebView Alpha Value on Fade
    var logoIsHidden = false                                    // Toggle Hide/Show Logo
    var appWillResetSettings = false                            // Reset Settings Flag
    
    
    // MARK: View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        // Start Loader Animation
        launchLoader.isHidden = false           // Show Launch Loader
        launchLoader.startAnimation(true)       // Animate Launch Loader
        // Set Defaults for Elements
        blurView.material = .menu               // Set Default Blur FX
        backButton.isHidden = true              // Hide Back Button by Default
        
        initWebView()                           // Initialize WebView
        initCustomizer()                        // Initialize Customizer
        initFXView()                            // Initialize FXView
        
        // OBSERVER: WebView URL (Detect Changes)
        webViewURLObserver = webView.observe(\.url, options: .new) { [weak self] webView, change in
            let url = "\(String(describing: change.newValue))"
            self?.urlDidChange(urlString: url); }
        // OBSERVER: WebView Title (Detect Changes)
        webViewTitleObserver = webView.observe(\.title, options: .new) { [weak self] webView, change in
            let title = "\(String(describing: change.newValue))"
            self?.titleDidChange(pageTitle: title); }
    }
    
    
    
    // MARK:- URLs & Titles
    
    
    
    // MARK: URL Did Change
    // Used for managing Login, Error handling and setting UserDefaults
    var urlCallCount = 0
    /// Called when the WKWebView's absolute `URL` value changes
    func urlDidChange(urlString: String) {
        let url = Helper.cleanURL(urlString)    // Fix Optional URL String
        if debug { print("URL:", url) }         // Debug: Print URL to load
        Active.url = url                        // Update Active URL value
        urlCallCount += 1
        // Check User login status and keep window closed
        if urlCallCount > 20 {
            //print("> 20: \(urlCallCount)")
            //checkLoginAndCloseWindow()
        }
        print("urlCallCount: \(urlCallCount)")
        //checkLoginAndCloseWindow()              // Activates updateLoginStatus()
        
        // Save User CountryCode to Defaults
        URLHandler.setCountryCode(url)
        // Check User Login Success
        if URLHandler.userDidLogin(url, last: lastURL) {
            checkLoginAndCloseWindow()
        }
        // Handle Radio Station Error
        if ErrorHandler.isRadioStation(url, last: lastURL) {
            let title = ErrorMessage.Radio.title
            let message = ErrorMessage.Radio.message
            showAlert(title: title, message: message)
        }
        // Handle Error Return URL
        if url.contains("error") || url.contains(ErrorHandler.authKitURL) {
            ErrorHandler.didReceiveError(url)
        }
        
        lastURL = url           // Change lastURL at end of compare function
    }
    
    // MARK: Title Did Change
    // Mostly used for grabbing Apple Music metadata to share (under development) and back button management
    var callsToTitle = 0
    /// Called when the WKWebView's absolute page `Title` value changes
    func titleDidChange(pageTitle: String) {
        var title = Helper.cleanOptional(pageTitle)                     // Clean Optional("Page Title")
        if title.contains("on Apple Music") { title.removeLast(15) }    // Remove "on Apple Music" suffix
        if debug { print("Title: \(title)") }                           // Debug: Print title on change
        
        if callsToTitle <= 4 { callsToTitle += 1 }                      // Count calls made to title
        //if debug { print("callsToTitle: \(callsToTitle)") }           // Debug: Print call count
        // Once 4 calls have been made to title, AMWP is ready
        //if callsToTitle == 4 && !Settings.restoreSession { loadLastURLSession() }
        if callsToTitle == 4 && !Settings.restoreLastSession { fadePlayerAtLaunch() } //loadLastURLSession() }
        
        /*
         if webView.canGoBack { fadeBackButton(true) }
         else { fadeBackButton(false) }
         */
        
        /*
         // Trigger Metadata Fetch & Send to NowPlaying
         if nowURL.contains("playlist") {                                // Get Metadata: Playlist
         getArtwork()                                                // Get playlist artwork
         backButton.isHidden = false                                 // Show back button
         DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
         self.player.updatePlaylist(name: title, url: nowURL, img: artwork)
         })
         } else if nowURL.contains("album") {                            // Get Metadata: Album
         getArtwork()                                                // Get album artwork
         backButton.isHidden = false                                 // Show back button
         DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
         self.player.updateAlbum(name: title, url: nowURL, img: artwork)
         })
         } else if nowURL.contains("artist") {                           // Get Metadata: Artist
         getArtistArtwork()                                          // Get artist header image
         backButton.isHidden = false                                 // Show back button
         DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
         self.player.updateArtist(name: title, url: nowURL, img: artwork)
         }) }
         else if webView.canGoBack { backButton.isHidden = false }       // Show back button if appropriate
         else { backButton.isHidden = true }                             // Hide back button, WebView can't go back
         */
    }
    
    
    
    // MARK:- WebView Manager
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        let js = Script.toJS("style")
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Evaluate default CSS/JS code
        let js = Script.toJS("style")
        webView.evaluateJavaScript(js, completionHandler: nil)
        
        // if debug { print("URL CSS Code:", css) }
        // Fades-in Main Player WebView on Launch
        if initLaunch {
            if !Settings.restoreLastSession {
                fadePlayerAtLaunch()
            }
            initLaunch = false
        }
    }
    
    
    
    // MARK: Set Theme & Style
    /// Sets theme at launch and uses settings from previous session if user has launched before
    func setLaunchTheme() {
        Active.loadDefaults()
        setStyle(Active.style)
        if Active.clear { setTransparent() }
        else {
            if Active.image.contains("file://") { Active.image = "" }
            setImage(Active.image)
        }
    }
    /// Sets app Style and NSAppearance (Light/Dark - based on Style)
    func setStyle(_ style: Style) {
        fadeOnStyleSelect(style)
        blurView.material = style.fx
        setDarkMode(style.isDark)
        Active.setStyle(style)
        //setLiveStyle(style, isDark: style.isDark)
    }
    
    /// Set background image from menu bar
    func setImage(_ image: String) {
        transparentWindow(false)
        let html = FXManager.setImage(image)
        fxView.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
        fadeOnThemeSelect()
        Active.setTheme(image, isType: Theme.FX.image, isClear: false)
        
    }
    
    /// Set background image from user selected file (png, jpg or jpeg)
    func setCustomTheme() {
        let imageURL = windowController.selectImageFile()
        //let image = String(imageURL.absoluteString)
        //if !image.isEmpty && image.isBlank() {
        if imageURL.absoluteString == "file//.cancel" {
            if debug { print("User cancelled file selection") }
        } else {
            Active.path = imageURL
            setBackground(imageURL)
            Active.setCustomTheme(imageURL)
        }
        
        /*
        if let image = imageURL as? URL {
            setBackground(imageURL)
        }
        */
        
    }
    
    
    
    // MARK: Helpers: Themes & Styles
    /// Set background to transparent System
    func setTransparent() {
        fxView.alphaValue = 0
        transparentWindow(true)
        Active.clear = true
    }
    /// Toggle window between transparent and background media
    func transparentWindow(_ toggle: Bool) {
        var fxAlpha = CGFloat(1)
        if toggle { fxAlpha = 0 }
        fxView.alphaValue = fxAlpha
        if toggle { blurView.blendingMode = .behindWindow }     // Set blur behind window
        else { blurView.blendingMode = .withinWindow }          // Set blur within window
    }
    /// Set background image of theme with blur effect
    func setBackground(_ media: Any) {
        transparentWindow(false)                            // Switch blending mode to window
        if let object = media as? String {                  // Test media as String
            if !object.isEmpty {                            // Check for empty String
                setImage(object)
                /*
                let image = NSImage(named: object)
                imageView.image = image                     // Set image as background
                */
            } else { fxView.alphaValue = 0 }             // Empty String, hide background
        }
        if let object = media as? URL {                     // Test media as URL
            /* SEND URL TO FXCONTROLLER, TYPE: IMAGE
            let image = NSImage(byReferencing: object)      // Set image as custom user file
            imageView.image = image                         // Set custom image as background
            if debug { print("URLObject: \(object)") }
            */
            
            /*
            let filePath = object.deletingLastPathComponent()
            let pathString = filePath.absoluteString.replacingOccurrences(of: "file://", with: "")
            print("pathString: \(pathString)")
            let path = pathString.toURL()
            
            
            let image = object.absoluteString.removePath()
            
            let html = FXManager.setCustomImage(image)
            fxView.loadHTMLString(html, baseURL: path)
            */
            
            let path = object.absoluteString.replacingOccurrences(of: "file://", with: "~")
            let html = FXManager.setCustomImage(path)
            fxView.loadHTMLString(html, baseURL: nil)
            
            print("html: \(html)")
            print("path: \(path)")
        }
    }
    
    @IBAction func fxGradient(_ sender: Any) { setFX("gradient") }
    
    func setFX(_ name: String) {
        transparentWindow(false)
        fxView.loadFile(name, path: "WebFX/fx")
    }
    
    
    /**
     Set Light or Dark mode and save selection to Defaults
        - Parameters:
        - mode: `true` (Dark Mode), `false` (Light Mode)
     
     */
    func setDarkMode(_ mode: Bool) {
        if #available(OSX 10.14, *) {
            if mode {
                App.appearance = NSAppearance(named: .darkAqua)     // Force Dark Mode UI
                Defaults.set("dark", forKey: "mode")                // Save Defaults
                Active.mode = true                                  // Set Live Variables
            } else {
                App.appearance = NSAppearance(named: .aqua)         // Force Light Mode UI
                Defaults.set("light", forKey: "mode")               // Save Defaults
                Active.mode = false                                 // Set Live Variables
            }
        } else {
            setDarkModeLegacy(mode)                                 // Force Light/Dark Mode via CSS
        }
        
    }
    /**
    Legacy (macOS 10.13 and lower): Set Light or Dark mode and save selection to Defaults
       - Parameters:
       - mode: `true` (Dark Mode), `false` (Light Mode)
    
    */
    func setDarkModeLegacy(_ mode: Bool) {
        var cssFile = ""
        if mode {
            cssFile = "dark-mode"                                   // Force Dark Mode CSS
            Defaults.set("dark", forKey: "mode")                    // Save Defaults
            Active.mode = true                                      // Set Live Variables
        } else {
            cssFile = "light-mode"                                  // Force Light Mode CSS
            Defaults.set("light", forKey: "mode")                   // Save Defaults
            Active.mode = false                                     // Set Live Variables
        }
        let js = Script.toJS(cssFile, path: "WebCode/Legacy")
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
    /// Changes logo style (light/dark) on NSAppearance mode change - also briefly "flashes" the webView with animation
    func changeLogoStyle(_ style: Style) {
        var js: String
        if style.isDark { js = Script.toJS("dark") }
        else { js = Script.toJS("light") }
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
    
    
    
    
    // MARK:- Object Animators
    
    
    /// Fade-in WebView with animation on launch
    func fadePlayerAtLaunch() {
        launchLoader.isHidden = true
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 2
            webView.animator().alphaValue = 1
            customizerButton.animator().isHidden = false
        }, completionHandler: { () -> Void in
            self.launchLoader.stopAnimation(self)
        })
    }
    /// Slide-out Customizer menu with animation and slightly fade main player `webView`
    func showCustomizer() {
        customizerView.isHidden = false
        customizerButton.image = NSImage(named: "NSStopProgressFreestandingTemplate")
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 0.2
            customizerConstraint.animator().constant = 280
            webView.animator().alphaValue = webAlphaFade
        }, completionHandler: { () -> Void in
            //print("CustomizerWebView (width, height):", self.customizerWebView.frame.size)
        })
    }
    /// Slide-back/hide Customizer menu with animation and fade-in main player `webView` from slightly translucent state
    func hideCustomizer() {
        customizerButton.image = NSImage(named: "NSSmartBadgeTemplate")
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 0.2
            customizerConstraint.animator().constant = 0
            webView.animator().alphaValue = 1
        }, completionHandler: { () -> Void in
            self.customizerView.isHidden = true
        })
    }
    /// Fades in-and-out Music Player WebView when switching Style modes (`new Style.isDark != Active.style.isDark`)
    func fadeOnStyleSelect(_ style: Style) {
        var alphaSwitch = CGFloat(1.0)
        if !customizerView.isHidden { alphaSwitch = webAlphaFade }
        if style.isDark != Active.style.isDark {
            changeLogoStyle(style)
            NSAnimationContext.runAnimationGroup({ (context) -> Void in
                context.duration = 0.2 //length of the animation time in seconds
                webView.animator().alphaValue = 0.1
            }, completionHandler: { () -> Void in
                self.webView.animator().alphaValue = alphaSwitch
            })
        }
    }
    /// Fades in-and-out Music Player WebView when switching Style modes (`new Style.isDark != Active.style.isDark`)
    func fadeOnThemeSelect() {
        //var alphaSwitch = CGFloat(1.0)
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 0.1 //length of the animation time in seconds
            fxView.animator().alphaValue = 0.1
        }, completionHandler: { () -> Void in
            self.fxView.animator().alphaValue = 1.0
        })
    }
    /// Fade in/out back button
    func fadeBackButton(_ show: Bool) {
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 0.2 //length of the animation time in seconds
            backButton.animator().isHidden = show
        }, completionHandler: { () -> Void in
            //self.backButton.isHidden = show
        })
    }
    
    
    
    
    // MARK:- Initializers
    
    
    /// Initialize Music Player WebView
    func initWebView() {
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.setValue(false, forKey: "drawsBackground")      // Hide WebView Background
        webView.allowsLinkPreview = false                       // Disable Link Previews
        webView.allowsMagnification = false                     // Disable Magnification (CSS Handled)
        webView.allowsBackForwardNavigationGestures = false     // Disable Back-Forward Navigation
        webView.customUserAgent = Ultra.userAgent               // WebView Browser UserAgent
        webView.configuration.applicationNameForUserAgent = Ultra.app  // App Name UserAgent
        // WebKit Preferences & Configuration
        let preferences = WKPreferences()                       // WebKit Preferences
        preferences.javaScriptEnabled = true                    // Enable JavaScript
        preferences.javaScriptCanOpenWindowsAutomatically = true
        let configuration = WKWebViewConfiguration()            // WebKit Configuration
        configuration.preferences = preferences
        configuration.allowsAirPlayForMediaPlayback = true      // Enable WebKit AirPlay
        let webController = WKUserContentController()
        webView.configuration.userContentController = webController
        webView.alphaValue = 0                                  // Hide WebView on Launch
        
        // Load Apple Music Web Player
        webView.load(Ultra.url)
        /*
        if Settings.restoreLastSession { loadLastSession() }
        else { webView.load(Ultra.url) }
         */
        //fadePlayerAtLaunch()
    }
    /// Initialize Customizer
    func initCustomizer() {
        customizerView.isHidden = true          // Hide Customizer on Launch
        customizerButton.isHidden = true        // Hide Customizer Button Until Loaded
        customizerConstraint.constant = 0       // Set Customizer Blur View Leading to 0
    }
    /// Initialize Customizer
    func initFXView() {
        fxView.alphaValue = 1
        let html = FXManager.setImage("wave")
        fxView.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
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
    
    
    
    // MARK: Account Status Manager
    /// Checks and updates user login status, updating `User.isSignedIn` when applicable
    func updateLoginStatus() {
        webView.evaluate(script: Script.loginButton, completion: { (key, error) in
            if let key = key as? Int { LoginHelper.checkStatusAndUpdate(key) }
            if let error = error {
                if debug { print("UpdateLoginStatus Error: \(error.localizedDescription)") }
            }
        })
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

    
    
    // MARK: Local Helpers
    /// Show alert with title, message and OK button
    func showAlert(title: String, message: String) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    /// Show alert with return values of `true` or `false` based on user selection `OK` or `Cancel`
    func showAlert(title: String, message: String, withAction: Bool) -> Bool {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        let modalResult = alert.runModal()
        
        switch modalResult {
        case .alertFirstButtonReturn:
            return true
        case .alertSecondButtonReturn:
            return false
        default:
            return false
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
    
    
    
    
    // MARK:- Menu Functions
    // MARK: Menu Manager
    @IBAction func toggleCustomizer(_ sender: Any) {
        if !customizerView.isHidden { hideCustomizer() }
        else { showCustomizer() }
    }
    /// Toggles bottom left Customizer button
    @IBAction func toggleCustomizerButton(_ sender: NSButton) {
        if !customizerView.isHidden { hideCustomizer()
            sender.image = NSImage(named: "NSSmartBadgeTemplate")
        } else { showCustomizer()
            sender.image = NSImage(named: "NSStopProgressFreestandingTemplate")
        }
    }
    
    
    
    
    // MARK:- Menu Items
    
    // STYLES
    @IBAction func stylePreset(_ sender: Any) { setStyle(Style.preset) }
    @IBAction func styleFrosty(_ sender: Any) { setStyle(Style.frosty) }
    @IBAction func styleBright(_ sender: Any) { setStyle(Style.bright) }
    @IBAction func styleEnergy(_ sender: Any) { setStyle(Style.energy) }
    @IBAction func styleCloudy(_ sender: Any) { setStyle(Style.cloudy) }
    @IBAction func styleShadow(_ sender: Any) { setStyle(Style.shadow) }
    @IBAction func styleVibing(_ sender: Any) { setStyle(Style.vibing) }
    
    // THEMES
    @IBAction func themeTransparent(_ sender: Any) { setTransparent() }
    @IBAction func themeWave(_ sender: Any) { setImage("wave") }
    @IBAction func themeSpring(_ sender: Any) { setImage("spring") }
    @IBAction func themeDunes(_ sender: Any) { setImage("dunes") }
    @IBAction func themeQuartz(_ sender: Any) { setImage("quartz") }
    @IBAction func themeSilk(_ sender: Any) { setImage("silk") }
    @IBAction func themeBubbles(_ sender: Any) { setImage("bubbles") }
    //EXTRA THEMES
    @IBAction func themeGoblin(_ sender: Any) { setImage("goblin") }
    @IBAction func themePurple(_ sender: Any) { setImage("purple") }
    
    // Custom User Theme
    @IBAction func themeCustom(_ sender: Any) { setCustomTheme() }
    
    
    

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

