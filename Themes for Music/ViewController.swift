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
    static let url = "https://music.apple.com"
    static let userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.1 Safari/605.1.15"
    static var isPlaying = false
}

struct User {
    static var co = Defaults.string(forKey: "CountryCode")
    static var isSignedIn = Defaults.bool(forKey: "signedIn")
    static var firstLaunch = Defaults.bool(forKey: "firstLaunch")
    static var neverShowAgain = Defaults.bool(forKey: "NeverAgain")
    static var lastSessionURL = Defaults.string(forKey: "LastSessionURL")
}

var metadata = ["", "", ""] // Saves requested metadata to memory
var artwork = ""            // Saves current artwork to memory
var nowURL  = ""            // Saves current URL to memory
var lastURL = ""            // Saves previous URL to memory
var initLaunch = true       // Determines if app just launched

let debug = true           // Activates debugger functions on true

class ViewController: NSViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler, NSWindowDelegate, Customizable {
    
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
    
    var introWindowController: WalkthroughWindowController?
    
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
    var appWillResetSettings = false                            // Reset Settings Flag
    var openUpNextBeta = false
    
    
    
    // MARK: View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //clearDefaults()                                       // WARNING: Clears UserDefaults
        launchLoader.isHidden = false                           // Show Launch Loader
        launchLoader.startAnimation(true)                       // Animate Launch Loader
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
        let webController = WKUserContentController()
        webView.configuration.userContentController = webController
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
    
    override func viewDidAppear() {
        // Show User Walkthrough with "Never Show Again" option
        if !User.neverShowAgain {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                // Show Welcome/Intro/Walkthrough View
                let storyboard = NSStoryboard(name: "Main", bundle: nil)
                if let introWC = storyboard.instantiateController(withIdentifier: "IntroWindow") as? WalkthroughWindowController {
                    // Keep reference to it in memory
                    self.introWindowController = introWC
                    /*
                    if let introVC = introWC.window?.contentViewController as? WalkthroughViewController {
                        // Do something?
                    }
 */
                    // Present Walkthrough window to user
                    introWC.showWindow(self)
                }
            })
        }
    }
    
    override func viewWillDisappear() {
        if !appWillResetSettings {
            saveDefaults()              // Save Active.values to Defaults
            saveDefaultSettings()       // Save UI Settings to Defaults
            if debug { print("Saved User Session") }
            if debug { print("Window Size: \(view.window!.frame.size)") }
        } else {
            print("User successfully reset application settings.\nApplication restored to default state.")
        }
    }
    
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
    
    
    
    // MARK: WebView Setup
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Evaluate default CSS/JS code
        if debug { print("webView didFinish") }
        let css = cssToString(file: "style", inDir: "WebCode")
        let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
        webView.evaluateJavaScript(js, completionHandler: nil)
        // if debug { print("URL CSS Code:", css) }
        // Fades-in Main Player WebView on Launch
        if initLaunch {
            fadePlayerAtLaunch()
            initLaunch = false
        }
        // UI Settings: UserDefaults
        if Defaults.bool(forKey: "hideLogo") { logoIsHidden = true; toggleLogoMenu(true) }
        else { logoIsHidden = false; toggleLogoMenu(false) }
    }
    /// Debug menu: run custom JS code to test
    @IBAction func runJSCode(_ sender: Any) {
        if debug { print("LoginWindow is open: \(loginWindowIsOpen())") }
        
    }
    
    @IBAction func forceLightMode(_ sender: Any) {
        let css = cssToString(file: "light-mode", inDir: "WebCode/Legacy")
        let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
    
    @IBAction func forceDarkMode(_ sender: Any) {
        let css = cssToString(file: "dark-mode", inDir: "WebCode/Legacy")
        let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
    
    func showBufferIssueMessage() {
        let title = "Issues with Buffering First Song"
        let text = "Due to the fact that Apple Music's Library is public, they make a validation check upon requesting the first song (every new session). This just means that the first song to play, when you load up the app, will buffer for a few seconds as Apple attempts to verify that you're a valid subscriber. Once they've done their checks, the app will continue to stream music fluently. I'm looking into possible fixes, hang tight! \n\nUse ⌘K to toggle the popover Customizer or select the Customize menu in the top bar."
        self.showDialog(title: title, text: text)
    }
    
    
    
    // MARK: URL Manager
    // Used for managing Login, Error handling and setting UserDefaults
    
    /// Called when the WKWebView's absolute `URL` value changes
    func urlDidChange(urlString: String) {
        let url = cleanURL(urlString)           // Fix Optional URL String
        if debug { print("URL:", url) }         // Debug: Print new URL
        nowURL = url                            // Update nowURL to new URL
        
        // Fades-in Main Player WebView on Launch
        /* Move to titleDidchange
        if initLaunch {
            fadePlayerAtLaunch()
            initLaunch = false
        }
 */
        
        // Check if User is signed in: if true, keep LoginWindow closed
        checkLoginAndCloseWindow()
        
        // Set firstLaunch
        if !User.firstLaunch && User.isSignedIn {
            // Show init song buffer warning
            showBufferIssueMessage()
            // User first launch, set first launch to false
            User.firstLaunch = true
            Defaults.set(true, forKey: "firstLaunch")
        }
        
        // Save User CountryCode to Defaults
        // NEW
        //let baseURLSlash = "\(Music.url)/"
        //let removeBaseURL = url.replacingOccurrences(of: baseURLSlash, with: "")
        // OLD
        //let removeBaseURL = url.replacingOccurrences(of: "https://beta.music.apple.com/", with: "")
        let removeBaseURL = url.replacingOccurrences(of: "https://music.apple.com/", with: "")
        var countryCode = removeBaseURL.replacingOccurrences(of: "/for-you", with: "")
        countryCode = countryCode.replacingOccurrences(of: "/browse", with: "")
        countryCode = countryCode.replacingOccurrences(of: "/radio", with: "")      // Remove /radio
        if countryCode.count == 2 {             // Check that country code is length 2
            if debug { print("Country Code: \(countryCode)") }
            User.co = countryCode
            if User.isSignedIn && (User.co != Defaults.string(forKey: "CountryCode")) {
                Defaults.set(countryCode, forKey: "CountyCode")
            }
        }
        
        // Web Player URL Flag Markers
        let authURL = "authorize.music.apple.com"
        let mainURL = "music.apple.com"
        // Close Apple Music Login Pop-up Window
        if lastURL.contains(authURL) && url.contains(mainURL) {
            if debug { print("User logged in successfully, close LoginWindowController") }
            updateLoginStatus()  // Upon login, URL will refresh webView, triggering checkLoginAndCloseWindow()
        }
        
        // UNSUPPORTED HANDLERS
        // Web Player does not yet support this radio station, view in Music app:
        // if music.apple.com/XX/station/ <-> music.apple.com/XX/radio
        if (lastURL.contains("station") && url.contains("radio")) || lastURL.contains("radio") && url.contains("station") {
            webView.load(Music.url)
            let message = "We're sorry, Apple Music does not yet support this radio station outside of iTunes."
            showDialog(title: "Radio Station not yet supported", text: message)
            
        }
        // ERROR HANDLERS
        // Upon error, URL: https://music.apple.com/.../error
        if url.contains("error") {
            print("Apple Music Web Player: Encountered error")
            let message = "An error occured while connecting to Apple Music. Please try again."
            showDialog(title: "Connection Error", text: message)
        }
        // Web Player Error Flags
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
            print("Auth Notice: User failed to login")
        }
        
        lastURL = url           // Change lastURL at end of compare function
    }
    
    
    
    // MARK: Title Manager
    // Mostly used for grabbing Apple Music metadata to share (under development) and back button management
    
    /// Called when the WKWebView's absolute page `Title` value changes
    func titleDidChange(pageTitle: String) {
        var title = cleanOptional(pageTitle)                            // Clean Optional("Page Title")
        if title.contains("on Apple Music") { title.removeLast(15) }    // Remove "on Apple Music" suffix
        if debug { print("Title: \(title)") }                           // Debug: Print title on change
        
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
    }
    
    
    
    // MARK: Metadata Manager
    
    func updateNowPlaying(_ type: String, name: String, url: String, img: String) {
        
    }
    
    // DEBUG: Triggers getArtwork() from Debug menu
    @IBAction func getAlbumArtwork(_ sender: Any) { getArtwork() }
    /// Grabs playlist or album artwork (largest sized image from list of optimized artwork) and sends to `setArtwork()`
    func getArtwork() {
        // Confirmed working: [x] Playlists, [x] Album, [ ] Song, [ ] Artist
        // Get playlist or album artwork image set
        webView.evaluateJavaScript(Script.albumArtwork) { (result, error) in
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
                    if debug { print("Error: \(String(describing: error))") }
                }
            }
        }
    }
    /// Grabs the artist header image and sends to `setArtwork()`
    func getArtistArtwork() {
        // Get artist header image
        webView.evaluateJavaScript(Script.artistHeader) { (result, error) in
            if let header = result as? String {
                var imageURL = header.replacingOccurrences(of: "url(", with: "")
                if !imageURL.isEmpty { imageURL.removeLast() }
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
        webView.evaluateJavaScript(Script.nowPlaying) { (result, error) in
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
    
    
    
    // MARK: IB Themes & Styles
    // TO DO: Move to MenuManager.swift and retain active menu
    
    // STYLES
    @IBAction func stylePreset(_ sender: Any) { setPresetStyle(Style.preset) }
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
    
    
    
    // MARK: Setters: Themes & Styles
    /// Sets theme at launch and uses settings from previous session if user has launched before
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
    func setStyle(_ style: Style) {
        fadeOnStyleSelect(style)
        blur.material = style.fx
        setDarkMode(style.isDark)
        setLiveStyle(style, isDark: style.isDark)
    }
    /// Sets default preset Style (`.appearanceBased`) with system NSAppearance mode
    func setPresetStyle(_ style: Style) {
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
        //let image = String(imageURL.absoluteString)
        //if !image.isEmpty && image.isBlank() {
        if imageURL.absoluteString == "file//.cancel" {
            setBackground(imageURL)
            let imagePath = imageURL.absoluteString
            setLiveTheme(imagePath, clear: false)
        }
    }
    
    
    
    // MARK: Helpers: Themes & Styles
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
        let css = cssToString(file: cssFile, inDir: "WebCode/Legacy")
        let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
        webView.evaluateJavaScript(js, completionHandler: nil)
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
    /// Changes logo style (light/dark) on NSAppearance mode change - also briefly "flashes" the webView with animation
    func changeLogoStyle(_ style: Style) {
        var css: String
        if style.isDark { css = cssToString(file: "dark", inDir: "WebCode") }
        else { css = cssToString(file: "light", inDir: "WebCode") }
        let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
    
    
    
    // MARK: Set Live Variables
    // Sets live Theme & Style to Active struct
    // Active properties are saved to UserDefaults on app closure
    /**
    Sets `Active` Style values for attributes: `.style` and `.mode`
     - parameters:
        - style: `Style` object to set as `Active`
        - isDark: `Bool` value for corresponding `Dark ? Light` Style modes
    */
    func setLiveStyle(_ style: Style, isDark: Bool) {
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
    
    // DEBUG: Save/Load UserDefaults from Debug menu
    @IBAction func saveThemeDefaults(_ sender: Any) { saveDefaults() }
    @IBAction func readThemeDefaults(_ sender: Any) { loadDefaults() }
    /// Saves current `Active` (live) values to Defaults:
    /// `Active.[style, clear, mode, image]`
    func saveDefaults() {
        let themeArray = Theme.toArray(Active.style, clear: Active.clear, mode: Active.mode, image: Active.image)
        Defaults.set(themeArray, forKey: "ActiveTheme")
        Defaults.synchronize()
    }
    /// Loads `Active` (live) values from Defaults, sets them as current `Active` values:
    /// `Active.[style, clear, mode, image]`
    func loadDefaults() {
        let defaultArray = ["shadow", "false", "true", "wave"]      // Default
        let themeArray = Defaults.stringArray(forKey: "ActiveTheme") ?? defaultArray
        Theme.toActive(themeArray)
        
        let defaultDescriptors = ["style": Active.theme[0], "clear": Active.theme[1], " dark": Active.theme[2], "theme": Active.theme[3]]
        print("Restoring Theme Settings from Last Session...")
        for (property, value) in defaultDescriptors {
            print("  \(property): \(value)")
        }
        print(consoleDiv)
    }
    /// Save User attributes and custom settings to Defaults
    func saveDefaultSettings() {
        Defaults.set(logoIsHidden, forKey: "hideLogo")
        Defaults.set(User.isSignedIn, forKey: "signedIn")
        Defaults.synchronize()
    }
    
    
    
    // MARK: Custom Settings
    
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
        if NSWorkspace.shared.open(url ?? URL(string: Music.url)!) {
            print("Opened URL in Safari: \(nowURL)") }
    }
    
    // CUSTOM: Hide/Show Logo
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
    
    // SYSTEM: Login User from Menu
    @IBAction func toggleLogin(_ sender: NSMenuItem) {
        if sender.title == "Sign In" {
            if toggleLoginMenu(true) { sender.title = "Sign Out" }
        } else if sender.title == "Sign Out" {
            if toggleLoginMenu(false) { sender.title = "Sign In" }
        }
    }
    func toggleLoginMenu(_ isSignedOut: Bool) -> Bool {
        if isSignedOut {
            webView.evaluateJavaScript(Script.loginUser) { (value, error) in
                if let err = error { print(err) }
            }
            return true
        } else {
            if !clearCacheAndLogout() { return false }
        }
        return true
    }
    /// Clear WebView cookies & cache (forcing user logout), then reloads base Music URL in WebView
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
    
    /// RESET & CLEAR: All UserDefaults, WebKit cache and WebKit storage
    @IBAction func resetAllSettings(_ sender: Any) {
        let appDelegate = App.delegate as! AppDelegate
        let title = "Confirm Reset"
        let text = "Are you sure that you would like to reset all settings? Any themes, styles and preferences will be restored to their default state. You will also be signed out of Apple Music and will need to sign in again.\n\nUpon clicking OK, wait for the app to quit itself and then reopen it."
        if showAlert(title: title, text: text, withAction: true) {
            appWillResetSettings = true
            appDelegate.clearDefaults()
            appDelegate.removeDefaults()
            clearAllWKStorage()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                App.terminate(self)
            })
        }
    }
    
    
    
    // MARK: Music Controls
    @IBAction func getMusicStatus(_ sender: Any) {
        if musicIsPlaying() { print("Music is playing") }
        else { print("Music is NOT playing") }
        
    }
    
    // TODO: Join + minify JS
    // NOTE: Multiple evaluateJavaScript statements happen on main thread, cause app to stall
    //       Either group evaluate JS statements together - ie. musicIsPlaying(string: jsCode)
    @IBAction func playMusic(_ sender: Any) {
        webView.evaluateJavaScript(Script.controlMusic)
        //if !musicIsPlaying() { webView.evaluateJavaScript(Script.controlMusic) }
    }
    @IBAction func pauseMusic(_ sender: Any) {
        webView.evaluateJavaScript(Script.controlMusic)
        //if musicIsPlaying() { webView.evaluateJavaScript(Script.controlMusic) }
    }
    @IBAction func goRewindSong(_ sender: Any) {
        goBackSong(self); goNextSong(self)
    }
    @IBAction func goBackSong(_ sender: Any) {
        webView.evaluateJavaScript(Script.backSong)
    }
    @IBAction func goNextSong(_ sender: Any) {
        webView.evaluateJavaScript(Script.nextSong)
    }
    @IBAction func toggleUpNext(_ sender: Any) {
        /* TODO: Add Observer & Toggle to NSMenuItem
        if !upNextIsOpen() { webView.evaluateJavaScript(Script.toggleUpNext) }
        else { webView.evaluateJavaScript(Script.toggleUpNext) } */
        let title = "Issues with Up Next"
        let text = "Apple Music's Up Next panel is still very buggy and may cause the app to stall – in some cases, crash. Please use this feature at your own risk."
        if showAlert(title: title, text: text, withAction: true) {
            openUpNextBeta = true
            webView.evaluateJavaScript(Script.toggleUpNext)
        }
    }
    @IBAction func toggleShuffle(_ sender: Any) {
        webView.evaluateJavaScript(Script.toggleShuffle)
    }
    @IBAction func toggleRepeat(_ sender: Any) {
        webView.evaluateJavaScript(Script.toggleRepeat)
    }
    @IBAction func repeatSingle(_ sender: Any) {
        
    }
    @IBAction func goMuteSong(_ sender: Any) {
        webView.evaluateJavaScript(Script.muteSong)
    }
    
    
    // MARK: Music Control Helpers
    // Handles JS calls from Music Web Player
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let jsName = message.name
        let jsMessage = message.body
        print("\(jsName): \(jsMessage)")
        /*
        if message.name == "jsHandler" {                            // Check if JS call is from jsHandler
        if debug { print("JS: \(message.body)") }                   // Debug: Print jsHandler.value
        if var jsCall = message.body as? String {                   // jsCall: JS callback value
            if jsCall == "close" {  }
            }
        }
        */
    }
    /// Checks if Music is currently playing
    func musicIsPlaying() -> Bool {
        webView.evaluate(script: Script.getMusicStatus, completion: { (value, error) in
            if let value = value as? String {
                if value == "Play" { Music.isPlaying = false }
                else if value == "Pause" { Music.isPlaying = true }
            }
        })
        print("isMusicPlaying (Music.isPlaying): \(Music.isPlaying)")
        return Music.isPlaying
    }
    /// Checks if Up Next menu is currently open
    var upNextOpen = false
    func upNextIsOpen() -> Bool {
        webView.evaluate(script: Script.isUpNextOpen, completion: { (value, error) in
            if let value = value as? String {
                if value == "true" { self.upNextOpen = true }
                else if value == "false" { self.upNextOpen = false }
            }
        })
        print("UpNext isOpen: \(upNextOpen)")
        return upNextOpen
    }
    
    
    
    
    // MARK: Manage Customizer
    
    /// Show/hide Customizer popover menu based on if it's open already (⌘K)
    @IBAction func showCustomizerMenu(_ sender: Any) {
        if !customizerView.isHidden { hideCustomizer() } else { showCustomizer() } }
    /// Hide Customizer popover menu
    @IBAction func hideCustomizerMenu(_ sender: Any) { hideCustomizer() }
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
    
    
    
    // MARK: Account Status Manager
    
    /// Checks and updates user login status, updating `User.isSignedIn` when applicable
    func updateLoginStatus() {
        _ = loginWindowIsOpen()
        webView?.evaluateJavaScript(Script.loginButton) { (key, err) in
            if let key = key as? Int {
                if key == 0 { User.isSignedIn = true }
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
    // DEBUG: Updates user login status via Debug menu
    @IBAction func updateLoginStatus(_ sender: Any) {
        updateLoginStatus()
    }
    /// Checks if LoginWindow is currently open
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
                if isKeyWindow { App.keyWindow?.performClose(self) }
            }
            if let err = err { print(err.localizedDescription) }
            else { /* No error */ }
        }
    }
    
    
    
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
        //let url = cleanURL(urlString)             // Fix Optional URL String
        //if debug { print("Login URL:", url) }     // Debug: Print new URL
        //nowURL = url                              // Update nowURL to new URL
    }
    // Release loginWebView on closure
    /*
    func webViewDidClose(_ webView: WKWebView) {
        webView.removeFromSuperview()
        loginWebView = nil
    }
    */
    
    
    
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
    /// Show alert and return values of `true` or `false` based on user selection
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
    // TODO: Just make a custom share sheet, segues to custom ViewControllers look sick...
    //       You can control popover/sheet view size, appearance, etc.
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
    func compareModes(_ style: Style) -> Bool {
        if style.isDark == Active.style.isDark { return true }
        else { return false }
    }
    
    func setClipboard(text: String) {
        let clipboard = NSPasteboard.general
        clipboard.clearContents()
        clipboard.setString(text, forType: .string)
    }
    
    
    
    // MARK: Debug
    
    /// Clear all WKWebView Cache and Storage
    @IBAction func clearWKCache(_ sender: Any) {
        clearAllWKStorage()
    }
    func clearAllWKStorage() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        print("[WebCacheCleaner] All cookies deleted")
        
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                if debug { print("[WebCacheCleaner] Record \(record) deleted") }
            }
        }
    }
    
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

// TODO: USE OR DELETE
extension NSStoryboardSegue.Identifier {
    static let walkthroughVC = NSStoryboardSegue.Identifier("WalkthroughVC")
    static let openIntroWindow = NSStoryboardSegue.Identifier("OpenIntroWindow")
}


extension WKWebView {
    func evaluate(script: String, completion: @escaping (Any?, Error?) -> Void) {
        var finished = false

        evaluateJavaScript(script, completionHandler: { (result, error) in
            if error == nil {
                if result != nil {
                    completion(result, nil)
                }
            } else {
                completion(nil, error)
            }
            finished = true
        })

        while !finished {
            RunLoop.current.run(mode: RunLoop.Mode(rawValue: "NSDefaultRunLoopMode"), before: NSDate.distantFuture)
        }
    }
}

