//
//  AppDelegate.swift
//  Apple Music
//
//  Created by Justin Bush on 2020-03-03.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    lazy var windows = NSWindow()
    var mainWindow: NSWindow!
    var viewController: ViewController!
    var windowController: WindowController!
    
    var loginViewController: LoginViewController!
    var loginWindowController: LoginWindowController!
    

    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        //Defaults.set(Bool(), forKey: "hasLaunchedBefore")
    }
    
    // Handles Reopening of Main Window
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            for window in sender.windows {
                window.makeKeyAndOrderFront(self)
            }
        }
        return true
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

