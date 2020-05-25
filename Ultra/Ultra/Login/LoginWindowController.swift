//
//  LoginWindowController.swift
//  Themes for Music
//
//  Created by Justin Bush on 2020-03-21.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Cocoa

class LoginWindowController: NSWindowController, NSWindowDelegate {

    override func windowDidLoad() {
        super.windowDidLoad()
        window!.delegate = self
        window!.backgroundColor = NSColor.white
        window!.titlebarAppearsTransparent = true
        window!.isMovableByWindowBackground  = true
        window!.title = "Apple Music Login"
        window!.isReleasedWhenClosed = false
        window!.level = .floating                       // Keep as key window (front)
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        return true
    }

}
