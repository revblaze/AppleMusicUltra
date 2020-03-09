//
//  LoginWindowController.swift
//  Apple Music
//
//  Created by Justin Bush on 2020-03-03.
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
        //window!.titleVisibility = .hidden
        window!.title = "Apple Music Login"
        window!.isReleasedWhenClosed = false
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        //self.close()
        //self.window?.close()
        print("url windowShouldClose")
        return true
    }

}

