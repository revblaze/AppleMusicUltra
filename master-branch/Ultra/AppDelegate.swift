//
//  AppDelegate.swift
//  Ultra
//  Client for Music
//
//  Created by Justin Bush on 2020-08-01.
//

import Cocoa

let debug = true

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet var window: NSWindow!
    @IBOutlet weak var menuDebug: NSMenuItem!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        menuDebug.isHidden = !debug
    }

    internal func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
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


}

