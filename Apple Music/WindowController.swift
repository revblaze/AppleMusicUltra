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
    
    func selectImageFile() -> URL {
        let dialog = NSOpenPanel()
        dialog.title = "Upload Custom Background"
        dialog.allowsMultipleSelection = false
        dialog.showsResizeIndicator = false
        dialog.canCreateDirectories = true
        dialog.showsHiddenFiles = false
        dialog.allowedFileTypes = ["png", "jpg", "jpeg"]
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            if let result = dialog.url?.absoluteURL {
                //let fileManager = FileManager.default
                return result

            }
        /* BUG: Saves Documents directory as image (Documents image file)
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            if let result = dialog.url?.absoluteURL {
                let fileManager = FileManager.default
                var imageURL = result
                // get URL to the the documents directory in the sandbox
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
                fileManager.secureCopyItem(at: imageURL, to: documentsURL)
                print("imageURL:", imageURL)
                var imagePath = URL(string: "\(documentsURL)\(imageURL.lastPathComponent)")!
                print("imagePathURL:", imagePath)
                return imagePath //result
            }*/
            
        } else {
            return URL(string: "")! // User clicked cancel
        }
        return URL(string: "")!
    }

}


extension FileManager {

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

