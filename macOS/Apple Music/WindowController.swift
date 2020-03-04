//
//  WindowController.swift
//  Apple Music
//
//  Created by Justin Bush on 2020-03-03.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController, NSWindowDelegate {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        window!.delegate = self
        window!.titlebarAppearsTransparent = true
        window!.isMovableByWindowBackground  = true
        window!.titleVisibility = .hidden
        //window!.styleMask = .fullSizeContentView
        //window!.backgroundColor = NSColor(red:0.14, green:0.14, blue:0.15, alpha:1.0)

        //window!.titleVisibility = .hidden
        //window!.title = "Apple Music"
        
        // BG Hex: #242425
        
        /*
        if let screen = window?.screen ?? NSScreen.main {
            window?.setFrame(screen.visibleFrame, display: true)
        }
        */
    }
    
    func windowDidBecomeMain(_ notification: Notification) {
        /* Full Screen Window
        if let screen = window?.screen ?? NSScreen.main {
            window?.setFrame(screen.visibleFrame, display: true)
        } */
    }
    
    /*
    func windowWillEnterFullScreen(_ notification: Notification) {
        if let controller = contentViewController as? ViewController {
            window!.titleVisibility = .visible
            controller.updateForFullscreenMode()
        }
    }
    
    func windowWillExitFullScreen(_ notification: Notification) {
        if let controller = contentViewController as? ViewController {
            window!.titleVisibility = .hidden
            controller.updateForWindowedMode()
        }
    }
    */

}
