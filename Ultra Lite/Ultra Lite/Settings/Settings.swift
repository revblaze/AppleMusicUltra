//
//  Settings.swift
//  Ultra
//
//  Created by Justin Bush on 2020-04-20.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Cocoa

// System Variable Shortcuts
let App = NSApplication.shared
let Defaults = UserDefaults.standard

var appWillResetSettings = false

struct Settings {
    // Bool Values
    static let restoreLastSession = Defaults.bool(forKey: Key.restoreLastSession)
    static let hideLogo = Defaults.bool(forKey: Key.hideLogo)
    
    struct Key {
        static let restoreLastSession = "RestoreLastSession"
        static let hideLogo = "HideLogo"
    }
    
    static func save(_ value: Any, forKey: String) {
        Keys.saveToDefaults(value, forKey: forKey)
        Defaults.synchronize()
    }
    
    static func setDefault() {
        Settings.save(true, forKey: Key.restoreLastSession)
    }
    
    static func reset() {
        if appWillResetSettings {
            
        }
       // appWillResetSettings code
    }
    
}
