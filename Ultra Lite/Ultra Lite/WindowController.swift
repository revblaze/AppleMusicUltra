//
//  WindowController.swift
//  Ultra Lite
//
//  Created by Justin Bush on 2020-05-22.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController, NSWindowDelegate {

    // MARK: Objects & Variables
        var viewController: ViewController!
        
        override func windowDidLoad() {
            super.windowDidLoad()
            window!.delegate = self
            window!.titlebarAppearsTransparent = true
            window!.isMovableByWindowBackground  = true
            window!.titleVisibility = .hidden
            window!.title = "Ultra Lite"
        }
        
        func windowWillClose(_ notification: Notification) {
            // Prepare for Window close
        }
        
        
        /// Prompts user to select an image file for custom theme background
        /// # Usage
        ///     let imagePath = selectImageFile()
        /// - returns: `URL` to image path on user's device
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
