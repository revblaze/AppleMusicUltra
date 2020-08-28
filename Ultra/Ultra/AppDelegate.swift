//
//  AppDelegate.swift
//  Ultra
//
//  Created by Justin Bush on 2020-08-01.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet var window: NSWindow!
    
    @IBOutlet weak var menuDebug: NSMenuItem!
    

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        menuDebug.isHidden = !debug
        initMyAccount()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        Theme.save()
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
    
    
    // MARK:- Account Menu
    @IBOutlet var menuMyAccount: NSMenuItem!
    @IBOutlet weak var menuSignIn: NSMenuItem!
    @IBOutlet weak var menuSignOut: NSMenuItem!
    
    func initMyAccount() {
        menuMyAccount.isEnabled = User.isSignedIn
        menuSignIn.isHidden = User.isSignedIn
        menuSignOut.isHidden = !User.isSignedIn
        
    }


}

