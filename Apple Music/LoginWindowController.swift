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
        //window!.backgroundColor = NSColor.windowFrameColor
        window!.backgroundColor = NSColor.white
        window!.titlebarAppearsTransparent = true
        window!.isMovableByWindowBackground  = true
        //window!.titleVisibility = .hidden
        window!.title = "Apple Music Login"
        window!.isReleasedWhenClosed = true
        
        /*
        if let screen = window?.screen ?? NSScreen.main {
            window?.setFrame(screen.visibleFrame, display: true)
        }
 */
    }
    
    func closeLoginPrompt() {
        print("url we made it to windowController")
        //self.window?.performClose(nil)
        self.window?.close()
        dismissController(self)
        //self.window?.performClose(nil)
        //NSApp.abortModal()
        /*
        self.window?.windowController?.close()
        self.window?.performClose(nil)
        self.window?.performClose(self) // Fatal error
        self.window?.close()
        self.close()
        */
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        //self.close()
        //self.window?.close()
        print("url windowShouldClose")
        return true
    }

}

