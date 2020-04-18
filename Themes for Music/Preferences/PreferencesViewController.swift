//
//  PreferencesViewController.swift
//  Themes for Music
//
//  Created by Justin Bush on 2020-04-18.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController {

    @IBOutlet var applySettingsButton: NSButton!
    @IBOutlet var restoreDefaultsButton: NSButton!
    
    @IBAction func applySettings(_ sender: Any) {
        let title = "Under Development"
        let text = "Preferences are currently being developed. Due to the limited functionality, changing preferences has been temporarily disabled.\n\nCheck back over the next few updates!"
        showDialog(title: title, text: text)
    }
    
    @IBAction func restoreDefaults(_ sender: Any) {
        applySettings(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    /// Show dialog alert with title and descriptor text
    func showDialog(title: String, text: String) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = text
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    
}
