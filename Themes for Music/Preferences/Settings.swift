//
//  Settings.swift
//  Themes for Music
//
//  Created by Justin Bush on 2020-04-04.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import AppKit
import Foundation

struct Settings {
    static let hideLogo = Defaults.bool(forKey: Keys.hideLogo)                  // Hide Logo
    static let restoreSession = Defaults.bool(forKey: Keys.restoreSession)      // Restore Last Session
    
    static func save() {
        Defaults.set(Settings.hideLogo, forKey: Keys.hideLogo)
        Defaults.set(Settings.restoreSession, forKey: Keys.restoreSession)
    }
}

struct Keys {
    static let hideLogo = "HideLogo"                                            // Hide Logo Key
    static let restoreSession = "RestoreLastSession"                            // Restore Last Session Key
}

