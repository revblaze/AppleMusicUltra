//
//  WindowController.swift
//  Apple Music
//
//  Created by Justin Bush on 2020-03-03.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController, NSWindowDelegate {
    
    var maxScreen = false
    var viewController: ViewController!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        // BG Hex: #242425
        window!.delegate = self
        window!.titlebarAppearsTransparent = true
        window!.isMovableByWindowBackground  = true
        window!.titleVisibility = .hidden
    }
    
    func windowDidBecomeMain(_ notification: Notification) {
        // windowDidBecomeMain
    }
    
    func windowWillClose(_ notification: Notification) {
        viewController.saveBeforeClosing()
    }
    
    /**
     Prompts user to select an image file for custom background image
     
     - Returns: `URL` path to image file

     Allowed file types: `.png` `.jpg` `.jpeg`
     */
    func selectImageFile() -> URL {
        let dialog = NSOpenPanel()
        dialog.title = "Upload Custom Background"
        dialog.allowsMultipleSelection = false
        dialog.showsResizeIndicator = false
        dialog.canCreateDirectories = true
        dialog.showsHiddenFiles = false
        dialog.allowedFileTypes = ["png", "jpg", "jpeg"]
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            if let result = dialog.url?.absoluteURL { return result }
        } else {
            return URL(string: "")! // User clicked cancel
        }
        return URL(string: "")!
    }

}

/* TO DO:
    - Copy custom image from user-selected path to app's Documents or Resources directory
    - Replace stored custom image with new user-selected image
 */
extension FileManager {
    /// Securely copies an item from one destination to another
    open func secureCopyItem(at srcURL: URL, to dstURL: URL) -> Bool {
        do {
            if FileManager.default.fileExists(atPath: dstURL.path) {
                try FileManager.default.removeItem(at: dstURL)
            }
            try FileManager.default.copyItem(at: srcURL, to: dstURL)
        } catch (let error) {
            print("Cannot copy item at \(srcURL) to \(dstURL): \(error)")
            return false
        }
        return true
    }

}

