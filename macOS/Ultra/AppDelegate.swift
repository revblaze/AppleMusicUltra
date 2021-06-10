//
//  AppDelegate.swift
//  Ultra
//
//  Created by Justin Bush on 2021-06-10.
//

import Cocoa

let debug = true
let prod = !debug

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet var window: NSWindow!
    @IBOutlet weak var debugMenu: NSMenuItem!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if prod { debugMenu.isHidden = true }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
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


}
