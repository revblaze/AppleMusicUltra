//
//  ViewController.swift
//  Apple Music
//
//  Created by Justin Bush on 2020-03-03.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Cocoa
import WebKit
import AVKit
import MediaPlayer

// MediaPlayer Control Centre
// https://developer.apple.com/documentation/mediaplayer/remote_command_center_events

// System Variables
let App = NSApplication.shared
let Defaults = UserDefaults.standard
let Notification = NotificationCenter.default

struct Music {
    static let app = "Apple Music Web Client"
    static let url = "https://beta.music.apple.com"
    static let userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_3) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.5 Safari/605.1.15"
}

// ie. Style.preset
struct Style {                                                          //                          rawValue
    static let preset = NSVisualEffectView.Material.appearanceBased     // Default Preset               0
    // Light Mode                                                       LIGHT
    static let frosty   = NSVisualEffectView.Material.sheet             // Frosty       (Opaque)        11
    static let bright   = NSVisualEffectView.Material.mediumLight       // Bright       (Middle)        8
    static let energy   = NSVisualEffectView.Material.light             // Vibrant      (Transparent)   1
    // Dark Mode                                                        DARK
    static let cloudy   = NSVisualEffectView.Material.ultraDark         // Cloudy       (Opaque)        9
    static let dark     = NSVisualEffectView.Material.toolTip           // Dark         (Middle)        17
    static let vibrant  = NSVisualEffectView.Material.dark              // Vibrant      (Transparent)   2
}

// ie. User.type
struct User {
    static let darkMode = Defaults.bool(forKey: "darkMode")                     // dark ? light
    static let type     = Defaults.string(forKey: "type")   ?? "transparent"    // tansparent, image, video, dynamic, url
    static let style    = Defaults.object(forKey: "style")  as? NSVisualEffectView.Material ?? .appearanceBased
    static let image    = Defaults.string(forKey: "image")  ?? ""               // "wave"
    static let video    = Defaults.string(forKey: "video")  ?? ""               // "poly"
    static let url      = Defaults.url(forKey: "url")       ?? URL(string: "")  // "file://"
    static let dynamic  = Defaults.string(forKey: "dynamic")                    // TBD
}


let debug = true
var lastURL = ""

class ViewController: NSViewController, WKUIDelegate, WKNavigationDelegate, NSWindowDelegate, URLSessionDelegate, NSAlertDelegate {
    
    var firstOpen = false

    let hasLaunched = Defaults.bool(forKey: "hasLaunchedBefore")
    let build = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    
    var liveType    = User.type
    var liveStyle   = NSVisualEffectView.Material.sheet //User.style
    var liveMode    = User.darkMode
    var liveImage   = User.image
    
    // MARK: Variables
    @IBOutlet var webView: WKWebView!
    @IBOutlet var blur: NSVisualEffectView!
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet var topConstraint: NSLayoutConstraint!
    @IBOutlet var dynamicWebView: WKWebView!        // Reminder: not connected to anything
    
    // WebView URL Observer
    var webViewURLObserver: NSKeyValueObservation?
    var webViewTitleObserver: NSKeyValueObservation?
    
    private var window: WindowController?
    let windowController: WindowController = WindowController()
    
    private var loginWebView: WKWebView?
    private var loginWindowController: LoginWindowController?
    
    let themeController = ThemeController()
    
    var nowURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if debug {
            print("url hasLaunchedBefore: \(hasLaunched)")
            print("urlDidLoad Defaults(type: \(User.type), style: \(User.style.rawValue)")
            //Defaults.set(false, forKey: "hasLaunchedBefore")
        }
        
        // WebView Configuration
        webView.setValue(false, forKey: "drawsBackground")
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsLinkPreview = false
        webView.allowsMagnification = false
        webView.allowsBackForwardNavigationGestures = false
        webView.customUserAgent = Music.userAgent
        webView.configuration.applicationNameForUserAgent = Music.userAgent
        
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        configuration.allowsAirPlayForMediaPlayback = true
        webView.configuration.allowsAirPlayForMediaPlayback = true
        
        // Load Apple Music Web Beta
        webView.load(Music.url)
        
        setLaunchTheme()
        
        //setupDynamicWebView()
        
        // WebView URL Observer (Detect Changes)
        webViewURLObserver = webView.observe(\.url, options: .new) { webView, change in
            let url = "\(String(describing: change.newValue))"
            ViewController().urlChange(urlString: url)
        }
        
        // WebView Title Observer
        webViewTitleObserver = self.observe(\.webView.title, options: .new) { webView, change in
            let title = "\(String(describing: change.newValue))"
            ViewController().titleChange(pageTitle: title)
        }
        
        // Background image fit window
        imageView.imageScaling = .scaleAxesIndependently
        
        if debug {
            topConstraint.constant = 0
        }
        
        // Get latest version number from server (wait 5-10 seconds due to init crash errors)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
            self.updateCheck()
        })
    }
    
    
    override func viewWillAppear() {
        self.view.window?.delegate = self
        if debug { print("urlWillAppear style: \(User.style.rawValue)") }
    }
    
    override func viewWillDisappear() {
        saveBeforeClosing()
    }
    
    /// Sets the Theme at app launch
    func setLaunchTheme() {
        let preset = NSVisualEffectView.Material.appearanceBased
        
        let safeURL = User.url
        let fileManager = FileManager()
        
        var darkMode: Bool
        let appearance = (currentMode.rawValue == "Dark")    // Light ? Dark
        if appearance { darkMode = true } else { darkMode = false }
        
        if hasLaunched {
            let type = User.type
            switch type {
            case "image":
                setTheme(User.style, darkMode: User.darkMode, media: User.image, type: type)
            case "video":
                setTheme(User.style, darkMode: User.darkMode, media: User.video, type: type)
            case "dynamic":
                setTheme(User.style, darkMode: User.darkMode, media: User.dynamic, type: type)
            case "url":
                if fileManager.fileExists(atPath: safeURL!.absoluteString) {    // if File exists
                    setTheme(User.style, darkMode: User.darkMode, media: safeURL ?? "", type: type)
                } else {
                    setTheme(User.style, darkMode: User.darkMode, media: "", type: "transparent")
                }
            default:
                setTheme(User.style, darkMode: User.darkMode, media: "", type: type)
            }
        } else {
            setTheme(preset, darkMode: darkMode, media: "", type: "transparent")
            Defaults.set(true, forKey: "hasLaunchedBefore")
        }
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.delegate = self
    }
    
    func windowDidResize(_ notification: Notification) {
        // This will print the window's size each time it is resized.
        if debug { print("urlWindowSize:", view.window!.frame.size) }
    }
    
    func setupDynamicWebView() {
        // WebView Configuration
        dynamicWebView.allowsLinkPreview = false
        dynamicWebView.allowsMagnification = false
        dynamicWebView.allowsBackForwardNavigationGestures = false
        dynamicWebView.customUserAgent = Music.userAgent
        dynamicWebView.configuration.applicationNameForUserAgent = Music.userAgent
        
        dynamicWebView.load("about:blank")      // Load about:blank until set
        
        // Hide until working
        dynamicWebView.isHidden = true
        
        if let url = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "dynamic/gradient") {
            let urlRequest = URLRequest(url: url)
            dynamicWebView.load(urlRequest)
        }
        
        //dynamicWebView.isHidden = true
    }
    
    // Check for new version
    // Make sure to edit update.devsec.ca/applemusic/version.txt
    // BUG: Fetching TXT data from server caches number, resulting in outdated checks
    func updateCheck() {
        // Get latest version number from server
        var url = URL(string:"https://update.devsec.ca/applemusic/version.txt")!
        //url.removeAllCachedResourceValues()     // Doesn't work
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                if let textFile = String(data: data!, encoding: .utf8) {
                    //self.checkUpdate(text: textFile)
                    let latest = Int(textFile) ?? 0
                    let current = Int(self.build) ?? 0
                    print("URLUpdateBuild, Current: \(current), Latest: \(latest)")
                    if latest > current {
                        /* BUG: Unable to release TXT file cache */
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
                            self.updateAlert()
                        })
                    }
                }
            }
        }
        task.resume()
    }
    
    
    // MARK: WKWebView
    
    func titleChange(pageTitle: String) {
        // Fix Optional URL String
        // START: Optional("Apple Music")
        var title = pageTitle.replacingOccurrences(of: "Optional", with: "")    // Remove Optional
        let brackets: Set<Character> = ["(", ")"]                               // Now: ("Apple Music")
        title.removeAll(where: { brackets.contains($0) })                       // Remove ( )
        title.removeFirst()                                                     // Remove first "
        title.removeLast()                                                      // Remove last "
        if debug { print("URL Page Title:", title) }                            // END: Apple Music
        self.view.window?.title = title
        self.view.window?.update()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Add default CSS stylesheet
        let path = Bundle.main.path(forResource: "style", ofType: "css", inDirectory: "Resources")
        var cssString: String? = nil
        do {
            cssString = try String(contentsOfFile: path ?? "", encoding: .ascii)
        } catch {
            // Error
        }
        cssString = cssString?.replacingOccurrences(of: "\n", with: "")
        cssString = cssString?.replacingOccurrences(of: "\"", with: "'")
        cssString = cssString?.replacingOccurrences(of: "Optional(", with: "")
        cssString = cssString?.replacingOccurrences(of: "\")", with: "")
        
        let css = cssString!
        // if debug { print("URL CSS:", css) }
        let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
    
    
    // TO DO:
    // Close login popup on this button click:
    // <button data-targetid="continue" data-pageid="WebPlayerConfirmConnection" class="button-primary signed-in" data-ember-action="" data-ember-action-286="286">Continue</button>
    // style: button.button-primary.signed-in
    
    // LoginWebView: 650 x 710
    // Creates new loginWebView instance
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        loginWebView = WKWebView(frame: view.bounds, configuration: configuration)
        loginWebView!.frame = view.bounds
        self.setupConstraints(for: loginWebView!)
        loginWebView!.navigationDelegate = self
        loginWebView!.uiDelegate = self
        view.addSubview(loginWebView!)
        return loginWebView!
    }

    func webViewDidClose(_ webView: WKWebView) {
        webView.removeFromSuperview()
        loginWebView = nil
    }
    
    // Website URL Changes Here
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url?.absoluteString
        //guard let isAuth = url?.contains("https://idmsa.apple.com/IDMSWebAuth/") else { return nil }
        // Auth URL for catch: https://idmsa.apple.com/auth
        if let isAuth = url?.contains("idmsa.apple.com/IDMSWebAuth/") { // contains("idmsa.apple.com")
            if webView === loginWebView && isAuth {
                self.presentLoginScreen(with: loginWebView!)
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
    
    /// Called when the WKWebView's absolute URL value changes
    func urlChange(urlString: String) {
        // Fix Optional URL String
        var url = urlString.replacingOccurrences(of: "Optional", with: "")
        let brackets: Set<Character> = ["(", ")"]
        url.removeAll(where: { brackets.contains($0) })
        
        print("URL:", url)
        
        // First Session Launch Checks
        // if url = "https://beta.music.apple.com/us/browse" - User has not logged in
        
        // Check for Login Success (User clicked "Continue")
        // "https://authorize.music.apple.com/?liteSessionId"
        if lastURL.contains("authorize.music.apple.com") && url.contains("beta.music.apple.com") { //url.contains(Music.url) {
            print("URL detected, close Login")
            // Temp workaround: close current key window
            App.keyWindow?.performClose(self)
        }
        
        // Loads URL when login fail:
        // https://buy.itunes.apple.com/commerce/account/authenticateMusicKitRequest
        if lastURL.contains("buy.itunes.apple.com") {//&& url.contains("authorize.music.apple.com") {
            print("User failed to login")
        }
        
        if debug { print("lastURL:", lastURL)}
        
        lastURL = url
        nowURL = url
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    /// Forces System Appearance to Light Mode
    func forceLightMode() {
        App.appearance = NSAppearance(named: .aqua)
        Defaults.set("light", forKey: "mode")
    }
    /// Forces System Appearance to Dark Mode
    func forceDarkMode() {
        App.appearance = NSAppearance(named: .darkAqua)
        Defaults.set("dark", forKey: "mode")
    }
    
    // Force System Appearance Mode (Light/Dark)
    //@IBAction func forceLight(_ sender: Any) { forceLightMode() }
    //@IBAction func forceDark(_ sender: Any) { forceDarkMode() }
    
    
    // MARK: Themes
    
    // Default / Preset Style
    @IBAction func themeDefault(_ sender: Any) { setDefaultTheme() }
    // Light Mode Styles
    @IBAction func themeBright(_ sender: Any) { setTheme(Style.bright, dark: false) }
    @IBAction func themeFrosty(_ sender: Any) { setTheme(Style.frosty, dark: false) }
    @IBAction func themeEnergy(_ sender: Any) { setTheme(Style.energy, dark: false) }
    // Dark Mode Styles
    @IBAction func themeCloudy(_ sender: Any) { setTheme(Style.cloudy, dark: true) }
    @IBAction func themeDark(_ sender: Any) { setTheme(Style.dark, dark: true) }
    @IBAction func themeVibrant(_ sender: Any) { setTheme(Style.vibrant, dark: true) }
    
    // Themes
    @IBAction func themeTransparent(_ sender: Any) { setTransparentTheme() }
    @IBAction func themeWave(_ sender: Any) { setImage("wave") }
    @IBAction func themePurple(_ sender: Any) { setImage("purple") }
    @IBAction func themeSilk(_ sender: Any) { setImage("silk") }
    @IBAction func themeBubbles(_ sender: Any) { setImage("bubbles") }
    @IBAction func themeGoblin(_ sender: Any) { setImage("goblin") }
    @IBAction func themeSpring(_ sender: Any) { setImage("spring") }
    @IBAction func themeQuartz(_ sender: Any) { setImage("quartz") }
    @IBAction func themeDunes(_ sender: Any) { setImage("dunes") }
    
    // Custom User Theme
    @IBAction func themeCustom(_ sender: Any) { setCustomTheme() }
    
    
    // MARK: Theme Manager
    
    /**
    Receives Style parameters and sends to proper set functions while handling a lot in the middle
    
     - Parameters:
        - type: `default`, `image`, `video`, `url` (type of theme to set)
        - style: NSVisualEffect.Material object (ie. fx.sheet)
        - media: String or URL of image
        - mode: `Light` or `Dark`. User selected theme mode.
    
     # Types Explained
     - `default:` fx, transparent window, no media
     - `image:` fx, opaque window, image String, image view
     - `video:` fx, opaque window, video url or file (see HTML5 animations)
     - `url:`fx, opaque window
     
     # Purpose
     - Save Presets (`UserDefaults`) for next launch
     - Send valid elements to proper setter functions
     A description.
     */
    func setMedia(type: String, style: String, media: Any, mode: String) {
        
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
            liveMode = true                                     // Set Live Variables
        } else {
            App.appearance = NSAppearance(named: .aqua)         // Force Light Mode UI
            Defaults.set("light", forKey: "mode")               // Save Defaults
            liveMode = false                                    // Set Live Variables
        }
    }
    
    /// Toggle window between transparent and background media
    func transparentWindow(_ toggle: Bool) {
        if toggle { blur.blendingMode = .behindWindow }     // Set blur behind window
        else { blur.blendingMode = .withinWindow }          // Set blur within window
    }
    
    /// Set background image of theme with blur effect
    func setBackground(_ media: Any) {
        imageView.alphaValue = 1                        // Show background imageView
        //var mediaString = ""
        if let object = media as? String {              // Test media as String
            if !object.isEmpty {                        // Check for empty String
                let image = NSImage(named: object)
                imageView.image = image                 // Set image as background
            } else { imageView.alphaValue = 0 }         // Empty String, hide background
        }
        if let object = media as? URL {                 // Test media as URL
            let image = NSImage(byReferencing: object)  // Set image as custom user file
            imageView.image = image                     // Set custom image as background
            if debug { print("URLObject: \(object)") }
            //mediaString = "\(object)"
        }
    }
    
    /*
    setStyle(_ style: NSVisualEffectView) {
        setTheme(style, darkMode: User.darkMode, media: User, type: User.type)
    }
 */
    
    /// Set background image from menu bar
    func setImage(_ image: String) {
        liveImage = image
        setTheme(liveStyle, darkMode: liveMode, media: image, type: "image")
    }
    
    /// Sets default theme with Style `.appearanceBased` and Type `transparent`
    func setDefaultTheme() {
        setTheme(liveStyle, darkMode: liveMode, media: "", type: "transparent")
    }
    
    /// Sets window to `transparent` without affecting other settings
    func setTransparentTheme() {
        setTheme(liveStyle, darkMode: liveMode, media: "", type: "transparent")
    }
    
    /// Set background image from user selected file (png, jpg or jpeg)
    func setCustomTheme() {
        let imageURL = windowController.selectImageFile()
        //setTheme(User.style, darkMode: User.darkMode, media: imageURL, type: User.type)
        setTheme(liveStyle, darkMode: liveMode, media: imageURL, type: "image")
    }
    
    /// Set new Style to Theme (without affecting current settings)
    func setTheme(_ style: NSVisualEffectView.Material, dark: Bool) {
        //imageView.alphaValue = 0
        //transparentWindow(true)
        liveStyle = style
        liveMode  = dark
        if debug { print("url setBoolLiveStyle: \(liveStyle.rawValue)") }
        blur.material = style
        setDarkMode(dark)
        //saveDefaults(style, darkMode: dark, media: true, type: liveType)
        /*
        Defaults.set(style, forKey: "style")                // SET STYLE    (Material)
        Defaults.set(dark, forKey: "darkMode")              // SET MODE     (Light/Dark)
        */
        saveDefaults(style, darkMode: dark, type: liveType)
        //saveBeforeClosing()
    }
    
    /// Set new transparent Style (without background media)
    func setTheme(_ style: NSVisualEffectView.Material, darkMode: Bool, withMedia: Bool) {
        if !withMedia {     // Check if Style has Media
            setTheme(style, darkMode: darkMode, media: "", type: "transparent")
        }
    }
    
    // let imageURL = windowController.selectImageFile()        custom image code
    
    func setTheme(_ style: NSVisualEffectView.Material, darkMode: Bool, media: Any, type: String) {
        // TEMP VARIABLES
        liveType    = type
        liveStyle   = style
        liveMode    = darkMode
        
        if debug { print("url setLiveStyle: \(liveStyle.rawValue)") }
        
        // STYLE SETUP
        setDarkMode(darkMode)       // Activate Light/Dark mode
        blur.material = style       // Activate Style
        imageView.alphaValue = 0    // Hide background image until needed
        
        // Check for Transparent Window
        if type == "transparent" {
            //imageView.alphaValue = 0
            transparentWindow(true)             // Activate blur fx behind window
            saveDefaults(style, darkMode: darkMode, media: "", type: "transparent")
        } else { transparentWindow(false) }     // Activate blur fx within window
        
        // Activate Theme Switch
        switch type {
        case "image":
            print("urlTypeImage: \(media)")
            setBackground(media)
        case "video":
            print("Video code here")
            // setVideo("videoName")
        case "url":
            print("urlTypeURL: \(media)")
            setBackground(media)
        case "dynamic":
            print("Dynamic code here")
            // setDynamic("dynamicName")
        default:
            setBackground(media)
        }
        
        saveDefaults(style, darkMode: darkMode, media: media, type: type)
    }
    
    func saveDefaults(_ style: NSVisualEffectView.Material, darkMode: Bool, media: Any, type: String) {
        // Blank Media variables: set one with value, save all to Defaults
        var image = "", video = "", dynamic = ""
        var url   = URL(string: "")
        
        // SET TYPE
        if let object = media as? String {                                      // Check if Media is empty
            if object.isEmpty { Defaults.set("transparent", forKey: "type") }   //  true: set transparent type
            else { Defaults.set(type, forKey: "type")                           // false: set proper type
                // SET MEDIA (String)
                if type == "image" { image = object }       // SET MEDIA: image
                else if type == "video" { video = object }  // SET MEDIA: video
                else { dynamic = object }                   // SET MEDIA: dynamic
            }
        }
        if let object = media as? URL { url = object }      // SET MEDIA: url
        if media is Bool { image = liveImage }
        // SAVE DEFAULTS
        //if !firstOpen {
        DispatchQueue.main.async {
            //Defaults.set(style, forKey: "style")                // SET STYLE    (Material)
            Defaults.set(darkMode, forKey: "darkMode")          // SET MODE     (Light/Dark)
            Defaults.set(image, forKey: "image")                // SET IMAGE
            Defaults.set(video, forKey: "video")                // SET VIDEO
            Defaults.set(dynamic, forKey: "video")              // SET DYNAMIC
            Defaults.set(url, forKey: "url")                    // SET URL
        }
        //firstOpen = true
    }
    
    /// Save Defaults without media
    func saveDefaults(_ style: NSVisualEffectView.Material, darkMode: Bool, type: String) {
        Defaults.set(type, forKey: "type")                  // SET TYPE
        Defaults.set(style, forKey: "style")                // SET STYLE    (Material)
        Defaults.set(darkMode, forKey: "darkMode")          // SET MODE     (Light/Dark)
    }
    
    func saveBeforeClosing() {
        if debug { print("url CLOSING APP, style: \(liveStyle.rawValue)") }
        DispatchQueue.main.async {
            Defaults.set(self.liveType, forKey: "type")              // SET TYPE
            Defaults.set(self.liveStyle, forKey: "style")            // SET STYLE    (Material)
            Defaults.set(self.liveMode, forKey: "darkMode")          // SET MODE     (Light/Dark)
            Defaults.synchronize()
        }
    }

    
    
    
    
    
    @IBAction func dynamicGradient(_ sender: Any) { setDynamic() }
    
    func setDynamic() {
        imageView.alphaValue = 0
        blur.material = .sheet
        transparentWindow(false)
        //blur.blendingMode = .withinWindow
        
        //dynamicWebView.isHidden = false
        // Open CustomLaunchView
        let url = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "gradient")!
        print("url DYNAMIC: \(url)")
        dynamicWebView.loadFileURL(url, allowingReadAccessTo: url)
        let request = URLRequest(url: url)
        dynamicWebView.load(request)
        
    }
 
    
    
    
    
    /*
    /// Set Style with transparent background
    func setStyle(_ style: NSVisualEffectView.Material) {
        imageView.alphaValue = 0
        transparentWindow(true)
        blur.material = style
        colorModeCheck(style)
        setDefaults(style: style, type: "none", media: "")
    }
    
    func setStyle(_ style: NSVisualEffectView.Material, type: String, media: String) {
        imageView.alphaValue = 1
        transparentWindow(false)
        blur.material = style
        colorModeCheck(style)
        setBackground(media)
        
    }
    
    // Save UserDefaults to restore next session
    func setDefaults(style: NSVisualEffectView.Material, type: String, media: String) {
        //let style = themeToString(theme)
        //print("urlRAW: \(theme.rawValue)")
        //Defaults.set(style, forKey: "style")
        Defaults.set(type, forKey: "type")
        //Defaults.set(theme, forKey: "theme")      // Crash
        Defaults.set(media, forKey: "media")
        if debug { print("urlDefaults(type: \(type), style: \("style"), media: \(media)") }
    }
    
    
    func setThemeManager(theme: NSVisualEffectView.Material, type: String, media: Any) {
        // Media is an app background image (String)
        if let image = media as? String {
            if !(image.isEmpty) {
                setTheme(theme: theme, withMedia: image)
            } else {
                // Media is just theme
                setTheme(theme: theme)
            }
        }
        // Media is a custom user-selected image (URL)
        if let url = media as? URL {
            let urlString = url.absoluteString.removingPercentEncoding
            print("urlString: \(urlString)")
            let newURL = URL(string: urlString ?? url.absoluteString)
            setCustomTheme(theme: theme, withURL: newURL!)
        }
    }
    
    /// Set the active theme
    func setTheme(theme: NSVisualEffectView.Material) {
        imageView.alphaValue = 0
        blur.material = theme
        //blur.blendingMode = .behindWindow
        transparentWindow(true)
        colorModeCheck(theme)
        saveDefaults(theme: theme, type: "setTheme", media: "")
    }
    /// Set active theme with image String
    func setTheme(theme: NSVisualEffectView.Material, withMedia: String) {
        blur.material = theme
        //blur.blendingMode = .withinWindow
        transparentWindow(false)
        setBackground(withMedia)
    }
    /// Set active theme with image URL
    func setTheme(theme: NSVisualEffectView.Material, withURL: URL) {
        blur.material = theme
        //blur.blendingMode = .withinWindow
        transparentWindow(false)
        setBackground(withURL)
    }
    func setCustomTheme(theme: NSVisualEffectView.Material) {
        let imageURL = windowController.selectImageFile()
        //blur.blendingMode = .withinWindow
        transparentWindow(false)
        setBackground(imageURL)
    }
    func setCustomTheme(theme: NSVisualEffectView.Material, withURL: URL) {
        //let imageURL = withURL
        //blur.blendingMode = .withinWindow
        transparentWindow(false)
        setBackground(withURL)
    }
    */
    
    /// Check and compare style to user's System appearance -> alert user if clash
    func colorModeCheck(_ style: NSVisualEffectView.Material) {
        //let styleInts = [1, 2, 8, 9]
        let light = [1, 8]
        let dark  = [2, 9]
        if light.contains(style.rawValue) {
            forceLightMode()
        } else {
            forceDarkMode()
        }
    }
    
    /// Notify user of styles specific to their System Appearance (paramaters: "Dark" and "Light)
    func colorModeAlert(_ mode: String) {
        let user = currentMode.rawValue
        //let message = "The Light & Dark styles work best when your Mac is in "
        let title   = "You're currently in \(user) Mode"
        let message = "The \(mode) styles look best when your Mac is in \(mode) Mode. Your Mac is currently in \(user) Mode.\n\nYou can change this in System Preferences... General... Appearance"
        if user == "Light" && mode == "Dark" {
            showDialog(title: title, text: message)
        }
        if user == "Dark" && mode == "Light" {
            showDialog(title: title, text: message)
        }
    }
    
    
    // MARK: Settings
    
    // Check for Update
    @IBAction func checkForUpdate(_ sender: NSMenuItem) {
        updateCheck()
    }
    
    // Toggle NSMenuItem state
    @IBAction func toggleState(_ sender: NSMenuItem) {
        sender.state = sender.state == .on ? .off : .on
    }
    
    // Toggle Music Logo (logo is at 0px top parent onShow notHidden again)
    @IBAction func toggleLogo(_ sender: NSMenuItem) {
        sender.state = sender.state == .on ? .off : .on
        if sender.state == .on {
            let css = ".web-navigation__logo-container { opacity: 0; }"
            let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
            webView.evaluateJavaScript(js, completionHandler: nil)
        } else {
            let css = ".web-navigation__logo-container { opacity: 100; }"
            let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
            self.webView.evaluateJavaScript(js, completionHandler: nil)
        }
    }
    
    // Open current page in Safari
    @IBAction func openInSafari(_ sender: NSMenuItem) {
        let url = URL(string: nowURL)
        if NSWorkspace.shared.open(url ?? URL(string: "https://beta.music.apple.com/")!) {
            print("default browser was successfully opened")

        }
    }
    
    // WindowController did enter fullscreen mode
    public func updateForFullscreenMode() {
        //titleBar.isHidden = true
        topConstraint.constant = 0
    }
    
    // WindowController did enter window mode
    public func updateForWindowedMode() {
        //titleBar.isHidden = false
        topConstraint.constant = 0//22.0
    }

    
    // MARK: Extra Setup
    
    // Light / Dark Mode Check
    enum InterfaceStyle: String {
       case Dark, Light

       init() {
          let type = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") ?? "Light"
          self = InterfaceStyle(rawValue: type)!
        }
    }

    let currentMode = InterfaceStyle()
    
    
    
    // MARK: Alerts
    
    // NSAlert for new update available
    func updateAlert() {
        let alert = NSAlert()
        alert.messageText = "Update Available"
        alert.informativeText = "There is an update available for Apple Music Ultra."
        alert.alertStyle = .informational
        alert.addButton(withTitle: "Update Now")
        alert.addButton(withTitle: "Remind Me Later")
        let modalResult = alert.runModal()
        
        switch modalResult {
        case .alertFirstButtonReturn: // NSApplication.ModalResponse.alertFirstButtonReturn
            print("url First button clicked")
            let url = URL(string: "https://github.com/revblaze/AppleMusicUltra/releases/")
            if NSWorkspace.shared.open(url ?? URL(string: "https://github.com/revblaze/AppleMusicUltra/")!) {
                print("User's default browser was successfully opened")
            }
        case .alertSecondButtonReturn:
            print("User clicked Remind Me Later")
        default:
            print("Default")
        }
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
    
    /// Show alert with title and descriptor text; returns true if user clicks "OK"
    func showAlert(title: String, text: String) -> Bool {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = text
        alert.alertStyle = .informational
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
    
}


// MARK: Extensions

// WKWebView Extension
extension WKWebView {
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            load(request)
        }
    }
}

// Checks to see if input file has contents or not
public extension String {
func isValidFile() -> String {
    if let path = Bundle.main.path(forResource:self , ofType: nil) {
        do {
            let text = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
            return text
            } catch { print("Failed to read text from bundle file \(self)") }
    } else { print("Failed to load file from bundle \(self)") }
    return ""
}
}

/// MARK: NSViewController extantion for constraints
extension NSViewController {
    /// Setup constraints for webview, it should be clip to bounds of the screen
    func setupConstraints(for webview: WKWebView) {
        
        webview.translatesAutoresizingMaskIntoConstraints = false
        // Add constraints to main ViewController view
        if let superView = webview.superview {
            // Top
            superView.addConstraints([NSLayoutConstraint(item: webview,
                                                         attribute: .top,
                                                         relatedBy: .equal,
                                                         toItem: superView,
                                                         attribute: .top,
                                                         multiplier: 1.0,
                                                         constant: 0.0)])
            // Bottom
            superView.addConstraints([NSLayoutConstraint(item: webview,
                                                         attribute: .bottom,
                                                         relatedBy: .equal,
                                                         toItem: superView,
                                                         attribute: .bottom,
                                                         multiplier: 1.0,
                                                         constant: 0.0)])
            // Left
            superView.addConstraints([NSLayoutConstraint(item: webview,
                                                         attribute: .left,
                                                         relatedBy: .equal,
                                                         toItem: superView,
                                                         attribute: .left,
                                                         multiplier: 1.0,
                                                         constant: 0.0)])
            // Right
            superView.addConstraints([NSLayoutConstraint(item: webview,
                                                         attribute: .right,
                                                         relatedBy: .equal,
                                                         toItem: superView,
                                                         attribute: .right,
                                                         multiplier: 1.0,
                                                         constant: 0.0)])
            
        }
    }
    
}

