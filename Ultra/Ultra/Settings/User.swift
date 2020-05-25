//
//  User.swift
//  Ultra
//
//  Created by Justin Bush on 2020-05-25.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Foundation

struct User {
    // Bool Values
    static let firstLaunch = Defaults.bool(forKey: Keys.firstLaunch)        // First Launch
    static let hasLaunchedBefore = Defaults.bool(forKey: Keys.hasLaunched)  // Has Launched Before
    static let isSignedIn = Defaults.bool(forKey: Keys.isSignedIn)          // User isSignedIn
    static let neverShowAgain = Defaults.bool(forKey: Keys.neverAgain)      // Never Show Again
    // String Values
    static let countryCode = Defaults.string(forKey: Keys.countryCode)      // Country Code
    static let lastSessionURL = Defaults.string(forKey: Keys.lastURL)       // Last Session URL
    // Theme & Style
    static let theme = Defaults.stringArray(forKey: Keys.theme)
    //static let style = Defaults.array(forKey: Keys.style)
    
    static func save(_ value: Any, forKey: String) {
        Keys.saveToDefaults(value, forKey: forKey)
        Defaults.synchronize()
    }
    
    static func setDefault() {
        save(true, forKey: Keys.firstLaunch)
        save(true, forKey: Keys.hasLaunched)
    }
    
}
