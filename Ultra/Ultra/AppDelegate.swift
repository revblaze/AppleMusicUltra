//
//  AppDelegate.swift
//  Ultra
//
//  Created by Justin Bush on 2020-05-25.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    lazy var windows = NSWindow()
    var viewController: ViewController!
    var windowController: WindowController!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
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


}

