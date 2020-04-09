//
//  ViewController.swift
//  Themes for Music
//
//  Created by Justin Bush on 2020-03-21.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Cocoa
import WebKit

// System Variable Shortcuts
let App = NSApplication.shared
let Defaults = UserDefaults.standard

struct Music {
    static let app = "Themes for Music"
    static let url = "https://beta.music.apple.com"
    static let userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.1 Safari/605.1.15"
}

struct User {
    static var co = Defaults.string(forKey: "CountryCode")
    static var isSignedIn = Defaults.bool(forKey: "signedIn")
    static var firstLaunch = Defaults.bool(forKey: "firstLaunch")
}

var metadata = ["", "", ""] // Saves requested metadata to memory
var artwork = ""            // Saves current artwork to memory
var nowURL  = ""            // Saves current URL to memory
var lastURL = ""            // Saves previous URL to memory
var initLaunch = true       // Determines if app just launched

let debug = true           // Activates debugger functions on true

class ViewController: NSViewController, WKUIDelegate, WKNavigationDelegate, NSWindowDelegate, Customizable { //, WKScriptMessageHandler {
    
    // MARK: Objects & Variables
    @IBOutlet var webView: WKWebView!                           // Main Music Web Player
    @IBOutlet var blur: NSVisualEffectView!                     // Main Background Blur Effect
    @IBOutlet weak var imageView: NSImageView!                  // Main Background Image Object
    @IBOutlet var rightConstraint: NSLayoutConstraint!          // WebView+Customizer Constraint
    @IBOutlet var launchLoader: NSProgressIndicator!            // Progress Indicator on Launch
    // Customizer Objects
    @IBOutlet weak var customizerView: NSView!                  // Customizer Container View
    @IBOutlet weak var customizerButton: NSButton!              // Bottom Right Customizer Button
    @IBOutlet var customizerConstraint: NSLayoutConstraint!     // Customizer -> Super Constraint
    
    // Window Objects
    let windowController = WindowController()                   // Window Controller
    
    // Login Controller Objects
    private var loginWebView: WKWebView?                        // Login WebView
    private var loginWindowController: LoginWindowController?   // Login Popup Window
    
    // WebView Observers
    var webViewTitleObserver: NSKeyValueObservation?            // Observer for Web Player Title
    var webViewURLObserver: NSKeyValueObservation?              // Observer for Web Player URL
    var loginWebViewURLObserver: NSKeyValueObservation?         //
    
    //var parser = Parser()
    var player = NowPlaying()                                   // Initialize NowPlaying Class
    
    // ViewController Default Values
    var webAlphaFade = CGFloat(0.7)                             // WebView Alpha Value on Fade
    let consoleDiv = String(repeating: "-", count: 10)          // Console Divider/Separator
    var consoleInit = true                                      // Initial Console Launch Output
    
    // UI Settings
    var logoIsHidden = false                                    // Toggle Hide/Show Logo
    var launchBefore = false
    
    // MARK: View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //clearDefaults()
        launchLoader.isHidden = false
        launchLoader.startAnimation(true)
        // Music Player WebView Setup
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.setValue(false, forKey: "drawsBackground")      // Hide WebView Background
        webView.allowsLinkPreview = false                       // Disable Link Previews
        webView.allowsMagnification = false                     // Disable Magnification (CSS Handled)
        webView.allowsBackForwardNavigationGestures = false     // Disable Back-Forward Navigation
        webView.customUserAgent = Music.userAgent               // WebView Browser UserAgent
        webView.configuration.applicationNameForUserAgent = Music.userAgent // App UserAgent
        // WebKit Preferences & Configuration
        let preferences = WKPreferences()                       // WebKit Preferences
        preferences.javaScriptEnabled = true                    // Enable JavaScript
        preferences.javaScriptCanOpenWindowsAutomatically = true
        let configuration = WKWebViewConfiguration()            // WebKit Configuration
        configuration.preferences = preferences
        configuration.allowsAirPlayForMediaPlayback = true      // Enable WebKit AirPlay
        // Load Apple Music Web Player
        webView.load(Music.url)
        webView.alphaValue = 0
        
        // Additional Setup
        blur.material = .appearanceBased                        // Set Default Blur Effects
        imageView.imageScaling = .scaleAxesIndependently        // Scale Background Image to Fit
        backButton.isHidden = true                              // Hide Back Button by Default
        customizerButton.isHidden = true                        // Hide Customizer Button Until Loaded
        customizerConstraint.constant = 0                       // Set Customizer Blur View Leading to 0
        customizerView.isHidden = true
        
        // OBSERVER: WebView URL (Detect Changes)
        webViewURLObserver = webView.observe(\.url, options: .new) { [weak self] webView, change in
        let url = "\(String(describing: change.newValue))"
        self?.urlDidChange(urlString: url); }
        // OBSERVER: WebView Title (Detect Changes)
        webViewTitleObserver = webView.observe(\.title, options: .new) { [weak self] webView, change in
        let title = "\(String(describing: change.newValue))"
        self?.titleDidChange(pageTitle: title); }
    }
    
    override func viewWillAppear() {
        setLaunchTheme()            // Load Theme & Style from Last Session
    }
    
    override func viewWillDisappear() {
        saveDefaults()              // Save Active.values to Defaults
        saveDefaultSettings()       // Save UI Settings to Defaults
        if debug { print("Saved User Session") }
        if debug { print("Window Size: \(view.window!.frame.size)") }
    }
    
    
    
    // MARK: Customizer

    /// Show/hide Customizer popover menu based on if it's open already (⌘K)
    @IBAction func showCustomizerMenu(_ sender: Any) {
        if !customizerView.isHidden { hideCustomizer() } else { showCustomizer() } }
    /// Hide Customizer popover menu
    @IBAction func hideCustomizerMenu(_ sender: Any) { hideCustomizer() }
    
    /**
    Hides/shows Customizer slide-over menu with animation.
    
     - Parameters:
        - show: `Bool` to show or hide the Customizer menu
        - time: `Double` that specifies animation time
        - alpha: Directly interacts with `webVew.alphaValue`
    
     # Usage
        // Show:
        initCustomizer(true, time: 0.3, alpha: 0.6)
        // Hide:
        initCustomizer(false, time: 0.2, alpha: 1.0)
     */
    func initCustomizer(_ show: Bool, time: Double, alpha: Double) {
        var constraint = 0
        if show { constraint = 280 }
        // Animate Customizer Side Menu (Duration: 0.3 secs)
        let customTimeFunction = CAMediaTimingFunction(controlPoints: 5/6, 0.2, 2/6, 0.9)
        NSAnimationContext.runAnimationGroup({(_ context: NSAnimationContext) -> Void in
            context.timingFunction = customTimeFunction
            context.duration = time
            rightConstraint.animator().constant = CGFloat(constraint)
            webView.animator().alphaValue = CGFloat(alpha)
            customizerView.animator().isHidden = !show
        }, completionHandler: {() -> Void in
        })
    }
    
    /// Fade-in WebView with animation on Launch
    func fadePlayerAtLaunch() {
        launchLoader.isHidden = true
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 2
            //launchLoader.animator().isHidden = true
            webView.animator().alphaValue = 1
            customizerButton.animator().isHidden = false
        }, completionHandler: { () -> Void in
            //self.launchLoader.animator().isHidden = true
            self.launchLoader.stopAnimation(self)
        })
    }
    
    /// Slide-out Customizer menu with animation and slightly fade main player `webView`
    func showCustomizer() {
        customizerView.isHidden = false
        customizerButton.image = NSImage(named: "NSStopProgressFreestandingTemplate")
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 0.2 //length of the animation time in seconds
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
            context.duration = 0.2 //length of the animation time in seconds
            customizerConstraint.animator().constant = 0
            webView.animator().alphaValue = 1
        }, completionHandler: { () -> Void in
            self.customizerView.isHidden = true
        })
    }
    
    
    
    // MARK: WebView Setup
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Evaluate default CSS/JS code
        let css = cssToString(file: "style", inDir: "WebCode")
        let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
        webView.evaluateJavaScript(js, completionHandler: nil)
        //if debug { print("URL CSS Code:", css) }
        
        // UI Settings: UserDefaults
        if Defaults.bool(forKey: "hideLogo") { logoIsHidden = true; toggleLogoMenu(true) }
    }
    
    
    
    // MARK: Manage URL
    
    @IBAction func runJSCode(_ sender: Any) {
        if debug { print("LoginWindow is open: \(loginWindowIsOpen())") }
    }
    
    func updateLoginStatus() {
        _ = loginWindowIsOpen()
        webView?.evaluateJavaScript(Script.loginButton) { (key, err) in
            if let key = key as? Int {
                if key == 0 {User.isSignedIn = true }
                else if key == 1 { User.isSignedIn = false }
            }
            
            if User.isSignedIn { print("User Status: Signed in") }
            else { print("User Status: Signed out") }
            
            if let err = err {
                print(err.localizedDescription)
                //self.userIsSignedIn = true
            } else {
                // No error
            }
        }
    }
    @IBAction func updateLoginStatus(_ sender: Any) {
        updateLoginStatus()
    }
    
    func loginWindowIsOpen() -> Bool {
        let loginWindowState = loginWindowController?.window?.occlusionState.contains(.visible) ?? false
        if loginWindowState { print("Login Window: Open") }
        else { print("Login Window: Closed or Hidden") }
        return loginWindowState
    }
    
    /// Checks to see if the user is logged in and sets `User.isSignedIn`; closes `LoginWindow` if `true`
    func checkLoginAndCloseWindow() {
        var signedIn = true
        let isKeyWindow = loginWindowController?.window?.isKeyWindow ?? false
        let loginWindowState = loginWindowController?.window?.occlusionState.contains(.visible) ?? false
        webView?.evaluateJavaScript(Script.loginButton) { (key, err) in
            if let key = key as? Int {
                if key == 0 { signedIn = true; User.isSignedIn = true }
                else if key == 1 { signedIn = false; User.isSignedIn = false }
            }
            if debug {
                print("signedIn: \(signedIn)")
                print("loginWindowState: \(loginWindowState)")
                print("login isKeyWindow: \(isKeyWindow)")
            }
            
            if signedIn && loginWindowState {
                if isKeyWindow {
                    App.keyWindow?.performClose(self)
                }
            }
            
            if let err = err {
                print(err.localizedDescription) }
            else { /* No error */ }
        }
    }
    
    
    func showBufferIssueMessage() {
        let title = "Issues with Buffering First Song"
        let text = "Due to the fact that Apple Music's Library is public, they make a validation check upon requesting the first song (every new session). This just means that the first song to play, when you load up the app, will buffer for a few seconds as Apple attempts to verify that you're a valid subscriber. Once they've done their checks, the app will continue to stream music fluently. I'm looking into possible fixes, hang tight! \n\nUse ⌘K to show/hide the popover Customizer or use the Customize menu drop down in the menu bar."
        self.showDialog(title: title, text: text)
    }
    
    // MARK: URL didChange
    
    /// Called when the WKWebView's absolute `URL` value changes
    func urlDidChange(urlString: String) {
        let url = cleanURL(urlString)           // Fix Optional URL String
        if debug { print("URL:", url) }         // Debug: Print new URL
        nowURL = url                            // Update nowURL to new URL
        
        // Fades-in Main Player WebView on Launch
        if initLaunch {// && (url.contains("for-you")||url.contains("browser")) {
            // LAST TO CALL
            fadePlayerAtLaunch()
            /* Auto open Customizer 4 seconds after launch
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
                self.showCustomizer()
            })
            */
            initLaunch = false
        }
        
        // Check if User is signed in: if true, keep LoginWindow closed
        checkLoginAndCloseWindow()
        
        if !User.firstLaunch && User.isSignedIn {
            showBufferIssueMessage()
            User.firstLaunch = true
            Defaults.set(true, forKey: "firstLaunch")
        }
        
        /*
        updateLoginStatus()
        // If LoginWindow is open and User is signed in, close LoginWindow
        if loginWindowIsOpen() && User.isSignedIn {
            App.keyWindow?.performClose(self)
        }
        */
        
        // NOT SIGNED IN: https://beta.music.apple.com -> https://beta.music.apple.com/us/browse
        // SIGNED IN: https://beta.music.apple.com -> https://beta.music.apple.com/ca/browse
        // Maybe load Login-only page and see where it redirects in both states?
        
        // LOGIN AUTH CHECKS
        //let loginURLAuth = "https://buy.itunes.apple.com/commerce/account/authenticateMusicKitRequest"  // ==
        //let loginURLToken = "https://idmsa.apple.com/IDMSWebAuth/auth?oauth_token="                     // contains
        // loginURL -> "" -> "about:blank" -> "" ->loginURLAuth -> loginURLToken
        // if nowURL.contains("browse") { (Optional ???)
        // if loginURL.contains(loginAuthToken) && lastLoginURL == loginURLAuth {
        //     print("Login window loaded") }
        
        /*
        let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
        webView.evaluateJavaScript(js, completionHandler: nil) */
        
        // LOGIN POSSIBLE:
        // Error output on every new page load AND click
        // global var pageLoad = false
        // in urlDidChange:
        // var pageLoad = true
        // if pageLoad { [Error output means button pressed]; pageLoad = false }
        /*
        if url.contains("browse") {
            webView?.evaluateJavaScript("document.getElementsByClassName('web-navigation__auth-button').onclick();") { (key, err) in
                if let err = err {
                    print(err.localizedDescription)
                } else {
                    print("JS: You tapped the Sign In button!")
                }}
        }*/
        
        // Save User CountryCode to Defaults
        // if User.isSignedIn {
        let removeBaseURL = url.replacingOccurrences(of: "https://beta.music.apple.com/", with: "")
        var countryCode = removeBaseURL.replacingOccurrences(of: "/for-you", with: "")
        countryCode = countryCode.replacingOccurrences(of: "/browse", with: "")
        countryCode = countryCode.replacingOccurrences(of: "/radio", with: "")      // Remove /radio
        if countryCode.count == 2 {             // Check that country code is length 2
            if debug { print("Country Code: \(countryCode)") }
            Defaults.set(countryCode, forKey: "CountyCode")
        }
        /*
        if userSignedIn && !launchBefore {
            showCustomizer()
            launchBefore = true
        }*/
        
        // First Session Launch Checks
        // if url = "https://beta.music.apple.com/us/browse" - User has not logged in
        
        // Check for Login Success (User clicked "Continue")
        // "https://authorize.music.apple.com/?liteSessionId"
        
        // DEBUG: Compare current URL to last URL
        // if debug { print("LIVE URL:\n    url = \(url)\n    lastURL = \(lastURL)") }
        
        
        // TODO: implement following regex pattern for country code
        // NOTE: this handles country codes 1-2 chars long. For just 2: {2}
        // /music\.apple\.com\/([a-zA-Z]{1,2})\/
        if let countryCode = url.range(of: #"/music\.apple\.com\/([a-zA-Z]{1,2})\/"#, options: .regularExpression) {
            print("CCRegEx: \(countryCode)")
        }
        
        // Web Player URL Flag Markers
        let authURL = "authorize.music.apple.com"
        let mainURL = "beta.music.apple.com"
        
        // Close Apple Music Login Pop-up Window
        if lastURL.contains(authURL) && url.contains(mainURL) {
            print("User logged in successfully, close LoginWindowController")
            updateLoginStatus()  // Upon login, URL will refresh webView, triggering checkLoginAndCloseWindow()
        }
        
        // Web Player does not yet support this radio station, view in Music app:
        // if music.apple.com/XX/station/ <-> beta.music.apple.com/XX/radio
        if (lastURL.contains("station") && url.contains("radio")) || lastURL.contains("radio") && url.contains("station") {
            webView.load(Music.url)
            let message = "We're sorry, Apple Music does not yet support this radio station outside of iTunes."
            showDialog(title: "Radio Station not yet supported", text: message)
            
        }
        
        // ERROR HANDLERS
        // Upon error, URL: https://beta.music.apple.com/.../error
        if url.contains("error") {
            print("Apple Music Web Player: Encountered error")
            let message = "An error occured while connecting to Apple Music. Please try again."
            showDialog(title: "Connection Error", text: message)
            /*
            DispatchQueue.main.asyncAfter(deadline: .now() + 10.0, execute: {
                //self.webView.load(Music.url)
                self.reloadWebView()
            })
            */
        }
        
        let errorFailedToVerify = "ERROR_FAILED_TO_VERIFY"
        let errorInvalidSession = "ERROR_INVALID_SESSION"
        
        // Error while logging in: "ERROR_FAILED_TO_VERIFY"
        // https://authorize.music.apple.com/?liteSessionId=GksrbAU1akPunlvLk5vzo0&error=ERROR_FAILED_TO_VERIFY_JWT&pod=49
        if url.contains(errorFailedToVerify) {
            print("Error: \(errorFailedToVerify)")
        }
        // Unsure what prompted this error:
        // https://authorize.music.apple.com/?liteSessionId=rNgKqSQRJd2JEEFeRtFHJg&error=ERROR_INVALID_SESSION&pod=49
        if url.contains(errorInvalidSession) {
            print("Error: \(errorInvalidSession)")
        }
        
        // Loads URL when login fail:
        let authKit = "https://buy.itunes.apple.com/commerce/account/authenticateMusicKitRequest"
        //if lastURL.contains("buy.itunes.apple.com") {//&& url.contains("authorize.music.apple.com") {
        if lastURL.contains(authKit) {
            print("Auth Notice: User failed to login?")
        }
        
        lastURL = url           // Change lastURL at end of compare function
    }
    
    func reloadWebView() {
        webView.reload()
    }
    
    
    
    // MARK: Title & JS Eval
    
    /// Called when the WKWebView's absolute page `Title` value changes
    func titleDidChange(pageTitle: String) {
        var title = cleanOptional(pageTitle)                            // Clean Optional("Page Title")
        if title.contains("on Apple Music") { title.removeLast(15) }    // Remove "on Apple Music" suffix
        if debug { print("Title: \(title)") }                           // Debug: Print title on change
        
        if webView.canGoBack { backButton.isHidden = false }
        
        if nowURL.contains("playlist") {
            getArtwork()
            backButton.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                self.player.updatePlaylist(name: title, url: nowURL, img: artwork)
            })
        } else if nowURL.contains("album") {
            getArtwork()
            backButton.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                self.player.updateAlbum(name: title, url: nowURL, img: artwork)
            })
        } else if nowURL.contains("artist") {
            getArtistArtwork()
            backButton.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                self.player.updateArtist(name: title, url: nowURL, img: artwork)
            })
        } else {
            backButton.isHidden = true
        }
    }
    
    
    func updateNowPlaying(_ type: String, name: String, url: String, img: String) {
        
    }
    
    @IBAction func getAlbumArtwork(_ sender: Any) { getArtwork() }
    /// Grabs playlist or album artwork (largest sized image from list of optimized artwork) and sends to `setArtwork()`
    func getArtwork() {
        // Confirmed working: [x] Playlists, [x] Album, [ ] Song, [ ] Artist
        // Get playlist and album artwork
        let jsCode = "document.getElementsByClassName('product-lockup__artwork')[0].getElementsByClassName('media-artwork-v2__image')[0].srcset"    // Grab artwork image set
        webView.evaluateJavaScript(jsCode) { (result, error) in
            if let urls = result as? String {
                let cleanURLs = self.cleanOptional(urls)
                let urlArray = cleanURLs.extractURLs()
                let urlStrings = urlArray.map { $0.absoluteString }
                for text in urlStrings {
                    if text.contains("1000") { artwork = text; break }
                    else if text.contains("760") { artwork = text }
                    else if text.contains("600") { artwork = text }
                    else { artwork = text }
                }
                self.setArtwork(artwork)
                
                if (error != nil) {
                    print("Error: \(String(describing: error))")
                }
            }
        }
    }
    /// Grabs the artist header image and sends to `setArtwork()`
    func getArtistArtwork() {
        // Get artist header image
        let jsCode = "document.getElementsByClassName('artist-header')[0].style.getPropertyValue('--background-image')"
        webView.evaluateJavaScript(jsCode) { (result, error) in
            if let header = result as? String {
                var imageURL = header.replacingOccurrences(of: "url(", with: "")
                imageURL.removeLast()
                let image = imageURL.replacingOccurrences(of: "\\", with: "")
                print("Header Image: \(image)")
                self.setArtwork(image)
            }
        }
    }
    /// Sets global variable `artwork` to input image string
    func setArtwork(_ image: String) {
        artwork = image
        if debug { print("setArtwork: \(artwork)") }
    }
    
    // <audio id="apple-music-player" preload="metadata" title="Get Free (feat. Amber Coffman) - Major Lazer - Get Free - Single" src="blob:https://beta.music.apple.com/12e4f769-3bb7-3b4f-ad49-7b1bcf635f1c"></audio>
    func getNowPlaying() {
        let jsCode = "document.getElementsByTagName('audio')[0].title"
        webView.evaluateJavaScript(jsCode) { (result, error) in
            if let title = result as? String {
                metadata = self.formatMetadata(title)
            }
            self.setNowPlaying(metadata)
        }
    }
    func setNowPlaying(_ data: [String]) {
        let song   = data[0]
        let artist = data[1]
        let album  = data[2]
        player.updateSong(name: song, artist: artist, album: album)
    }
    
    
    func runJS(_ code: String) -> String {
        return ""
    }

    func getHTML() {//} -> String {
        // Print all HTML:
        //let jsCode = "document.documentElement.outerHTML.toString()"
        
    }
    
    
    
    // MARK: IB Styles & Themes
    
    // STYLES
    @IBAction func stylePreset(_ sender: Any) { setPresetStyle(Styles.preset) }
    @IBAction func styleFrosty(_ sender: Any) { setStyle(Styles.frosty) }
    @IBAction func styleBright(_ sender: Any) { setStyle(Styles.bright) }
    @IBAction func styleEnergy(_ sender: Any) { setStyle(Styles.energy) }
    @IBAction func styleCloudy(_ sender: Any) { setStyle(Styles.cloudy) }
    @IBAction func styleShadow(_ sender: Any) { setStyle(Styles.shadow) }
    @IBAction func styleVibing(_ sender: Any) { setStyle(Styles.vibing) }
    
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
    
    
    
    // MARK: Setters: Styles & Themes
    
    func setLaunchTheme() {
        loadDefaults()
        setStyle(Active.style)
        if Active.clear { setTransparent() }
        else {
            if Active.image.contains("file://") { Active.image = "" }
            setImage(Active.image)
        }
    }
    
    /// Sets app Style and NSAppearance (Light/Dark - based on Style)
    func setStyle(_ style: Styles) {
        fadeOnStyleSelect(style)
        blur.material = style.fx
        setDarkMode(style.isDark)
        setLiveStyle(style, isDark: style.isDark)
    }
    /// Sets default preset Style (`.appearanceBased`) with system NSAppearance mode
    func setPresetStyle(_ style: Styles) {
        blur.material = style.fx
        setDarkMode(darkModeIsActive())
        setLiveStyle(style, isDark: darkModeIsActive())
    }
    
    /// Set background image from menu bar
    func setImage(_ image: String) {
        setBackground(image)
        setLiveTheme(image, clear: false)
    }
    
    /// Set background image from user selected file (png, jpg or jpeg)
    func setCustomTheme() {
        let imageURL = windowController.selectImageFile()
        setBackground(imageURL)
        let imagePath = imageURL.absoluteString
        setLiveTheme(imagePath, clear: false)
    }
    
    
    
    // MARK: Theme Helpers
    
    /// Set background to transparent System
    func setTransparent() {
        imageView.alphaValue = 0
        transparentWindow(true)
        Active.clear = true
    }
    
    /// Toggle window between transparent and background media
    func transparentWindow(_ toggle: Bool) {
        if toggle { blur.blendingMode = .behindWindow }     // Set blur behind window
        else { blur.blendingMode = .withinWindow }          // Set blur within window
    }
    
    /// Set background image of theme with blur effect
    func setBackground(_ media: Any) {
        imageView.alphaValue = 1                            // Show background imageView
        transparentWindow(false)                            // Switch blending mode to window
        if let object = media as? String {                  // Test media as String
            if !object.isEmpty {                            // Check for empty String
                let image = NSImage(named: object)
                imageView.image = image                     // Set image as background
            } else { imageView.alphaValue = 0 }             // Empty String, hide background
        }
        if let object = media as? URL {                     // Test media as URL
            let image = NSImage(byReferencing: object)      // Set image as custom user file
            imageView.image = image                         // Set custom image as background
            if debug { print("URLObject: \(object)") }
        }
    }
    
    /**
     Set Light or Dark mode and save selection to Defaults
        - Parameters:
        - mode: `true` (Dark Mode), `false` (Light Mode)
     
     */
    func setDarkMode(_ mode: Bool) {
        if mode {
            App.appearance = NSAppearance(named: .darkAqua)     // Force Dark Mode UI
            Defaults.set("dark", forKey: "mode")                // Save Defaults
            Active.mode = true                                  // Set Live Variables
        } else {
            App.appearance = NSAppearance(named: .aqua)         // Force Light Mode UI
            Defaults.set("light", forKey: "mode")               // Save Defaults
            Active.mode = false                                 // Set Live Variables
        }
    }
    
    /// Fades in-and-out Music Player WebView when switching Style modes (`new Style.isDark != Active.style.isDark`)
    func fadeOnStyleSelect(_ style: Styles) {
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
    func changeLogoStyle(_ style: Styles) {
        var css: String
        if style.isDark { css = cssToString(file: "dark", inDir: "WebCode") }
        else { css = cssToString(file: "light", inDir: "WebCode") }
        let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
    
    
    // MARK: Set Live Variables
    
    /**
    Sets `Active` Style values for attributes: `.style` and `.mode`
     - parameters:
        - style: `Styles` object to set as `Active`
        - isDark: `Bool` value for corresponding `Dark ? Light` Style modes
    */
    func setLiveStyle(_ style: Styles, isDark: Bool) {
        Active.style = style
        Active.mode = isDark
        let activeMessage = "Set Active: Style\n  style: \(style.name)\n   dark: \(style.isDark)"
        printWithDiv(activeMessage)
    }
    /**
    Sets `Active` Theme values for attributes: `.image` and `.clear`
     - parameters:
        - image: `NSImage` value for `imageView` object to set as `Active`
        - clear: `Bool` value for corresponding `Transparent ? Image` Theme types
    */
    func setLiveTheme(_ image: String, clear: Bool) {
        Active.image = image
        Active.clear = clear
        let activeMessage = "Set Active: Theme\n  theme: \(image)\n  clear: \(clear)"
        printWithDiv(activeMessage)
    }
    
    
    
    // MARK: Save Defaults
    
    // DEBUG: Save/Load UserDefaults from MenuBar
    @IBAction func saveThemeDefaults(_ sender: Any) { saveDefaults() }
    @IBAction func readThemeDefaults(_ sender: Any) { loadDefaults() }
    
    /// Saves current `Active` (live) values to Defaults:
    /// `Active.[style, clear, mode, image]`
    func saveDefaults() {
        //if User.hasSignedIn { Defaults.set(true, forKey: "hasSignedIn") }
        let themeArray = Theme.toArray(Active.style, clear: Active.clear, mode: Active.mode, image: Active.image)
        Defaults.set(themeArray, forKey: "ActiveTheme")
        Defaults.synchronize()
    }
    /// Loads `Active` (live) values from Defaults, sets them as current `Active` values:
    /// `Active.[style, clear, mode, image]`
    func loadDefaults() {
        let defaultArray = ["vibing", "false", "true", "wave"]
        let themeArray = Defaults.stringArray(forKey: "ActiveTheme") ?? defaultArray
        Theme.toActive(themeArray)
        
        let defaultDescriptors = ["style": Active.theme[0], "clear": Active.theme[1], " dark": Active.theme[2], "theme": Active.theme[3]]
        print("Restoring Theme Settings from Last Session...")
        for (property, value) in defaultDescriptors {
            print("  \(property): \(value)")
        }
        print(consoleDiv)
    }
    
    
    
    // MARK: Custom Funcs & Settings
    /// Save custom settings to defaults
    func saveDefaultSettings() {
        Defaults.set(logoIsHidden, forKey: "hideLogo")
        Defaults.set(User.isSignedIn, forKey: "signedIn")
        Defaults.synchronize()
    }
    
    @IBAction func toggleCustomizerButton(_ sender: NSButton) {
        if !customizerView.isHidden { hideCustomizer()
            sender.image = NSImage(named: "NSSmartBadgeTemplate")
        } else { showCustomizer()
            sender.image = NSImage(named: "NSStopProgressFreestandingTemplate")
        }
    }
    
    /// Open current page in Safari
    @IBAction func openInSafari(_ sender: NSMenuItem) {
        let url = URL(string: nowURL)
        if NSWorkspace.shared.open(url ?? URL(string: "https://beta.music.apple.com/")!) {
            print("Opened URL in Safari: \(nowURL)") }
    }
    
    // TOGGLE LOGO
    @IBAction func toggleLogo(_ sender: NSMenuItem) {
        sender.state = sender.state == .on ? .off : .on
        if sender.state == .on { toggleLogoMenu(true) }
        else { toggleLogoMenu(false) }
    }
    func toggleLogoMenu(_ state: Bool) {
        var css = ""
        if state { logoIsHidden = true  // Set Defaults to hide logo on launch
            css = cssToString(file: "hidelogo", inDir: "WebCode/Custom") }
        else { logoIsHidden = false     // Set Defaults to show logo on launch
            css = cssToString(file: "showlogo", inDir: "WebCode/Custom") }
        let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
    
    // TOGGLE LOGIN
    @IBAction func toggleLogin(_ sender: NSMenuItem) {
        /*
        if User.isSignedIn { sender.title = "Sign Out"
            if toggleLoginMenu(false)
        }
        else { sender.title = "Sign In" } */
        
        if sender.title == "Sign In" {
            if toggleLoginMenu(true) { sender.title = "Sign Out" }
        } else if sender.title == "Sign Out" {
            if toggleLoginMenu(false) { sender.title = "Sign In" }
        }
    }
    func toggleLoginMenu(_ isSignedOut: Bool) -> Bool {
        if isSignedOut {
            webView.evaluateJavaScript(Script.loginUser){ (value, error) in
                if let err = error { print(err) }
            }
            return true
        } else {
            if !clearCacheAndLogout() { return false }
        }
        return true
    }
    func clearCacheAndLogout() -> Bool {
        //WebCacheCleaner()
        let title = "Confirm Sign Out"
        let text = "Are you sure that you want to sign out of Apple Music?"
        if showAlert(title: title, text: text, withAction: true) {
            print("\(consoleDiv)\nAttempting to clear cookies & cache...")
            HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
            print("[WebCacheCleaner] All cookies deleted")
            
            WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
                records.forEach { record in
                    WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                    if debug { print("[WebCacheCleaner] Record \(record) deleted") }
                }
            }
            print("Successfully cleared cookies & cache.")
            webView.load(Music.url)
            return true
        }
        return false    // User clicked cancel
    }
    
    @IBAction func goBack(_ sender: Any) { webView.goBack() }
    @IBOutlet weak var backButton: NSButton!
    
    
    
    // MARK: Login Popup Manager
    
    // Catch Apple auth request and present Login window
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url?.absoluteString
        if !User.isSignedIn {
            // Auth URL for catch: https://idmsa.apple.com/auth
            if let isAuth = url?.contains("idmsa.apple.com/IDMSWebAuth/") { // contains("idmsa.apple.com")
                if webView === loginWebView && isAuth {
                    self.presentLoginScreen(with: loginWebView!)
                }
            }
        }
        decisionHandler(.allow)
    }
    
    // Create new Window with Login Prompt
    private func presentLoginScreen(with loginWebView: WKWebView) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        // Initiate login window view controller from storyboard
        if let loginWindowVC = storyboard.instantiateController(withIdentifier: "LoginWindow") as? LoginWindowController {
            // Keep reference to it in memory
            loginWindowController = loginWindowVC
            if let loginVC = loginWindowVC.window?.contentViewController as? LoginViewController {
                // Set preview webview
                loginVC.setWebView(loginWebView)
            }
            // Present login window to user
            loginWindowVC.showWindow(self)
        }
    }
    
    // LoginWebView: 650 x 710
    // Creates new loginWebView instance
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        let config = WKWebViewConfiguration()
        let js = "document.querySelectorAll('.button-primary signed-in')[0].addEventListener('click', function(){ window.webkit.messageHandlers.clickListener.postMessage('Do something'); })"
        let script = WKUserScript(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: false)

        config.userContentController.addUserScript(script)
        config.userContentController.add(self, name: "clickListener")
        loginWebView = WKWebView(frame: view.bounds, configuration: configuration)
        loginWebView!.frame = view.bounds
        self.setupConstraints(for: loginWebView!)
        loginWebView!.navigationDelegate = self
        loginWebView!.uiDelegate = self

        // OBSERVER: LoginWebView URL did change
        loginWebViewURLObserver = loginWebView!.observe(\.url, options: .new) { [weak self] loginWebView, change in
        let url = "\(String(describing: change.newValue))"
        self?.loginURLDidChange(urlString: url); }
        
        /*
        <div class="buttons-container">
          <button data-targetid="continue" data-pageid="WebPlayerConfirmConnection" class="button-primary signed-in" data-ember-action="" data-ember-action-287="287">Continue</button>
        </div> */
        /*
        loginWebView!.evaluateJavaScript("document.getElementsByClassName('button-primary signed-in').onclick();") { (key, err) in
            if let key = key {
                print("loginKey: \(key)")
            }
        if let err = err {
            print("JS Error Continue: \(err.localizedDescription)")
        } else {
            print("JS: You clicked Continue!")
        }}*/
        view.addSubview(loginWebView!)
        updateLoginStatus()
        return loginWebView!
    }
    
    private func getConfiguredWebview() -> WKWebView {
        let config = WKWebViewConfiguration()
        let js = "document.querySelectorAll('.web-navigation__auth-button')[0].addEventListener('click', function(){ window.webkit.messageHandlers.clickListener.postMessage('Do something'); })"
        let script = WKUserScript(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: false)

        config.userContentController.addUserScript(script)
        config.userContentController.add(self, name: "clickListener")

        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }
    
    /// Called when the WKWebView's absolute `URL` value changes
    func loginURLDidChange(urlString: String) {
        updateLoginStatus()
        //checkLoginAndCloseWindow()
        //let url = cleanURL(urlString)           // Fix Optional URL String
        //if debug { print("Login URL:", url) }         // Debug: Print new URL
        //nowURL = url                            // Update nowURL to new URL
    }

    func webViewDidClose(_ webView: WKWebView) {
        webView.removeFromSuperview()
        loginWebView = nil
    }
    
    
    
    // MARK: Helper Functions
    
    /// Cleans and reformats Optional URL string.
    /// `Optional("rawURL") -> rawURL`
    func cleanURL(_ urlString: String) -> String {
        var url = urlString.replacingOccurrences(of: "Optional", with: "")
        let brackets: Set<Character> = ["(", ")"]
        url.removeAll(where: { brackets.contains($0) })
        return url
    }
    func cleanOptional(_ string: String) -> String {
        var clean = string.replacingOccurrences(of: "Optional", with: "")
        let brackets: Set<Character> = ["(", ")", "\""]
        clean.removeAll(where: { brackets.contains($0) })
        return clean
    }
    func formatMetadata(_ string: String) -> [String] {
        let title = self.cleanOptional(string)
        let metaArray = title.split(separator: "-")
        // Song, Artist, Album
        var songMeta   = metaArray[0]
        var artistMeta = metaArray[1]
        var albumMeta  = metaArray[2]
        if metaArray.indices.contains(3) { albumMeta.append(contentsOf: metaArray[3]) }
        // Handle Song: "feat. X" -> "(feat. X)"
        songMeta.removeLast()
        songMeta.append(")")
        let song = songMeta.replacingOccurrences(of: "feat", with: "(feat")
        // Handle Artist (Spacing)
        artistMeta.removeFirst()
        artistMeta.removeLast()
        let artist = String(artistMeta)
        // Handle Album (regular, EPs and singles): "Get Free  Single" -> "Get Free - Single"
        albumMeta.removeFirst()
        let album = albumMeta.replacingOccurrences(of: "  ", with: " - ")
        print("Now Playing:\n    song: \(song)\n  artist: \(artist)\n   album: \(album)")
        return [song, artist, album]
    }
    
    /// Cleans and reformats Optional CSS String for use in WKWebView.
    func cssToString(_ css: String) -> String {
        var cssString = css
        cssString = cssString.replacingOccurrences(of: "\n", with: "")
        cssString = cssString.replacingOccurrences(of: "\"", with: "'")
        cssString = cssString.replacingOccurrences(of: "Optional(", with: "")
        cssString = cssString.replacingOccurrences(of: "\")", with: "")
        return cssString
    }
    
    /**
    Extracts Optional contents of a CSS file, cleans it and then reformats it as a String for use in WKWebView.
    
     - Parameters:
        - file: Name of the CSS file without the `.css` extension (ie. `style`)
        - inDir: The directory where the CSS file is located (ie. `WebCode`)
     - Returns: A non-Optional String of the CSS file
    
     # Usage
        let css = cssToString(file: "style", inDir: "WebCode")
     */
    func cssToString(file: String, inDir: String) -> String {
        let path = Bundle.main.path(forResource: file, ofType: "css", inDirectory: inDir)
        var cssString: String? = nil
        do { cssString = try String(contentsOfFile: path ?? "", encoding: .ascii) }
        catch { print("Error: Unable to locate custom styles") }
        // Format CSS code properly
        cssString = cssString?.replacingOccurrences(of: "\n", with: "")
        cssString = cssString?.replacingOccurrences(of: "\"", with: "'")
        cssString = cssString?.replacingOccurrences(of: "Optional(", with: "")
        cssString = cssString?.replacingOccurrences(of: "\")", with: "")
        return cssString ?? ""
    }
    
    /// Show dialog alert with title and descriptor text
    func showDialog(title: String, text: String) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = text
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    func showAlert(title: String, text: String, withAction: Bool) -> Bool {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = text
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        let modalResult = alert.runModal()
        
        switch modalResult {
        case .alertFirstButtonReturn: // NSApplication.ModalResponse.alertFirstButtonReturn
            return true
        case .alertSecondButtonReturn:
            return false
        default:
            return false
        }
    }
    
    /*
    func showShareSheet(_ sender: Any, text: String, url: String) {
        let rawURL = URL(string: url)
        let shareItems = [text, rawURL] as [Any]
        let sharingPicker:NSSharingServicePicker = NSSharingServicePicker.init(items: shareItems)
        sharingPicker.show(relativeTo: (sender as AnyObject).bounds, of: sender as! NSView, preferredEdge: .minY)
    }*/
    
    
    
    // MARK: Extra Setup

    // Handle segues
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        //print("Segue performed for \(segue)")
        // Assign Customizer delegate to self
        if segue.identifier == "presentCustomizer" {
            let customizer = segue.destinationController as! CustomizerViewController
            customizer.delegate = self
        }
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    // LIGHT / DARK MODE CHECK
    // currentMode == .Dark ?? .Light
    enum InterfaceStyle: String {
       case Dark, Light
       init() {
          let type = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") ?? "Light"
          self = InterfaceStyle(rawValue: type)!
        }
    }
    let currentMode = InterfaceStyle()
    
    /**
     Returns user's current System NSAppearance
     - returns: `true: Dark; false: Light`
     */
    func darkModeIsActive() -> Bool {
        if currentMode == .Dark { return true }
        else { return false }
    }
    
    /**
     Compares the input `Style.isDark` with current `Active.style.isDark`
     - parameters:
        - style: Style to compare with `Active.style`
     - returns: `true: same; false: different`
     */
    func compareModes(_ style: Styles) -> Bool {
        if style.isDark == Active.style.isDark { return true }
        else { return false }
    }
    
    func setClipboard(text: String) {
        let clipboard = NSPasteboard.general
        clipboard.clearContents()
        clipboard.setString(text, forType: .string)
    }
    
    
    
    
    // MARK: Debug
    
    // Print new window dimensions when resized
    func windowDidResize(_ notification: Notification) {
        if debug { print("WindowDidResize:", view.window!.frame.size) }
    }
    
    var lastConsoleEntry = ""
    func printWithDiv(_ text: String) {
        if !consoleInit { print(consoleDiv) }
        print(text)
        print(consoleDiv)
        if text.contains("Set Active: Style") && lastConsoleEntry.contains("Set Active: Theme") { consoleInit = false }
        if text.contains("Set Active: Theme") && lastConsoleEntry.contains("Set Active: Style") { consoleInit = false }
        lastConsoleEntry = text
    }
    /// WARNING: Clears all active UserDefaults: `hideLogo`, `ActiveTheme`
    func clearDefaults() {
        Defaults.removeObject(forKey: "hideLogo")
        Defaults.removeObject(forKey: "ActiveTheme")
        Defaults.removeObject(forKey: "mode")
    }
    
    @IBAction func printMode(_ sender: Any) {
        //if let mode = currentMode
        print("Current Mode: \(currentMode)")
    }

    // DEBUG FUNCTION:
    // An all-purpose function, accessible from the menu, for running debugger code
    @IBAction func customDebugFunction(_ sender: Any) {
        //getNowPlaying()
        getArtistArtwork()
    }
    
    

}



// MARK: Extensions

// WKWebView Extension
extension WKWebView {
    /// Quick load a URL in the WebView with ease
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            load(request)
        }
    }
    /// Quick load a `file` (without `.html`) and `path` to the directory
    func loadFile(_ name: String, path: String) {
        if let url = Bundle.main.url(forResource: name, withExtension: "html", subdirectory: path) {
            self.loadFileURL(url, allowingReadAccessTo: url)
            let request = URLRequest(url: url)
            load(request)
        }
    }
}

// String Extension to handle URL as String
extension String {
    /// Get the name of a file, from a `Sring`, without path or file extension
    /// # Usage
    ///     let path = "/dir/file.txt"
    ///     let file = path.fileName()
    /// - returns: `"/dir/file.txt" -> "file"`
    func fileName() -> String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }
    /// Get the extension of a file (`html`, `txt`, etc.), from a `Sring`, without path or name
    /// # Usage
    ///     let name = "index.html"
    ///     let ext = name.fileExtension()
    /// - returns: `"file.txt" -> "txt"`
    func fileExtension() -> String {
        return URL(fileURLWithPath: self).pathExtension
    }
    /// Get the file name and extension (`file.txt`), from a `Sring`, without path component
    /// # Usage
    ///     let path = "/path/to/file.txt"
    ///     let file = path.removePath()
    /// - returns: `"/path/to/file.txt" -> "file.txt"`
    func removePath() -> String {
        return URL(fileURLWithPath: self).lastPathComponent
    }
    /// Extracts URLs from a `String` and returns them as an `array` of `[URLs]`
    /// # Usage
    ///     let html = [HTML as String]
    ///     let urls = html.extractURLs()
    /// - returns: `["url1", "url2", ...]`
    func extractURLs() -> [URL] {
        var urls : [URL] = []
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            detector.enumerateMatches(in: self, options: [], range: NSMakeRange(0, self.count), using: { (result, _, _) in
                if let match = result, let url = match.url {
                    urls.append(url)
                }
            })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return urls
    }
    /// Returns true if the `String` is either empty or only spaces
    func isBlank() -> Bool {
        if (self.isEmpty) { return true }
        return (self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) == "")
    }
}

// ViewController Extension for sharing objects
extension ViewController: NSSharingServicePickerDelegate {
    func sharingServicePicker(_ sharingServicePicker: NSSharingServicePicker, sharingServicesForItems items: [Any], proposedSharingServices proposedServices: [NSSharingService]) -> [NSSharingService] {
        guard let image = NSImage(named: NSImage.Name("copy")) else {
            return proposedServices
        }
        
        var share = proposedServices
        let customService = NSSharingService(title: "Copy Text", image: image, alternateImage: image, handler: {
            if let text = items.first as? String {
                self.setClipboard(text: text)
                
            }
        })
        share.insert(customService, at: 0)
        
        return share
    }
}

extension ViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("WKScriptMessage: \(message.body)")
    }
}

