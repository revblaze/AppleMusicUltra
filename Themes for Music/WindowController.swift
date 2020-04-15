//
//  WindowController.swift
//  Themes for Music
//
//  Created by Justin Bush on 2020-03-21.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController, NSWindowDelegate {

    //var maxScreen = false
    var viewController: ViewController!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        window!.delegate = self
        window!.titlebarAppearsTransparent = true
        window!.isMovableByWindowBackground  = true
        window!.titleVisibility = .hidden
    }
    
    func windowWillClose(_ notification: Notification) {
        //viewController.saveDefaults()
    }
    
    func selectImageFile() -> URL {
        let dialog = NSOpenPanel()
        dialog.title = "Upload Custom Background"
        dialog.allowsMultipleSelection = false
        dialog.showsResizeIndicator = false
        dialog.canCreateDirectories = true
        dialog.showsHiddenFiles = false
        dialog.allowedFileTypes = ["png", "jpg", "jpeg"]
        
        if dialog.runModal() == NSApplication.ModalResponse.cancel {
            //return nil
            return URL(string: "file://.cancel")!
        }
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            if let result = dialog.url?.absoluteURL {
                //let fileManager = FileManager.default
                return result }
        } /*else { return URL(string: "") ?? "" } // User clicked cancel
        */
        return URL(string: "file://.cancel")!
    }

}
