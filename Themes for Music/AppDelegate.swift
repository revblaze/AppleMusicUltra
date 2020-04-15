//
//  AppDelegate.swift
//  Themes for Music
//
//  Created by Justin Bush on 2020-03-21.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    // Variables
    lazy var windows = NSWindow()
    var viewController: ViewController!
    var windowController: WindowController!
    var loginViewController: LoginViewController!
    var loginWindowController: LoginWindowController!
    
    @IBOutlet weak var debugMenu: NSMenuItem!
    @IBOutlet weak var toggleLogoMenu: NSMenuItem!
    @IBOutlet weak var toggleLoginMenu: NSMenuItem!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        //removeDefaults()
        /*
        Defaults.reset()                    // WARNING: RESETS DEFAULTS
        Defaults.synchronize()*/
        let hasLaunched = Defaults.bool(forKey: hasLaunchedKey)
        if !hasLaunched { clearDefaults(); Defaults.set(true, forKey: hasLaunchedKey) }
        if !debug { debugMenu.isHidden = true }
        
        // Hide Logo
        if hideLogo { toggleLogoMenu.state = .on }
        else { toggleLogoMenu.state = .off }
        
        if debug { print("User is signed in: \(signedIn)") }
        
        if signedIn { toggleLoginMenu.title = "Sign Out" }
        else { toggleLoginMenu.title = "Sign In" }
        
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

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    // MARK: Defaults
    let hasLaunchedKey = "hasLaunchedBefore1"
    let signedIn = Defaults.bool(forKey: "signedIn")
    let hideLogo = Defaults.bool(forKey: "hideLogo")

    
    /// WARNING: Clears all active UserDefaults: `hideLogo`, `ActiveTheme`
    func clearDefaults() {
        Defaults.removeObject(forKey: "signedIn")
        Defaults.removeObject(forKey: "hideLogo")
        Defaults.removeObject(forKey: "ActiveTheme")
        Defaults.removeObject(forKey: "mode")
        Defaults.removeObject(forKey: "firstLaunch")
    }
    func removeDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
}

