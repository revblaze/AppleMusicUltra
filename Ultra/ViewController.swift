//
//  ViewController.swift
//  Ultra
//  Client for Music
//
//  Created by Justin Bush on 2020-08-01.
//

import Cocoa
import WebKit

class ViewController: NSViewController {

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
    var webViewTitleObserver: NSKeyValueObservation?        // Observer for Web Player Title
    var webViewURLObserver: NSKeyValueObservation?          // Observer for Web Player URL
    var webViewProgressObserver: NSKeyValueObservation?     // Observer for Web Player Progress
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        //Theme.save()
    }
    
    // Handles Reopening of Main Window
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            for window in sender.windows {
                print(sender.windows)
                window.makeKeyAndOrderFront(self)
            }
        }
        return true
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

