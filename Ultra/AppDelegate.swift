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

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

