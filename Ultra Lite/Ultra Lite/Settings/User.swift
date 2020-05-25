//
//  User.swift
//  Ultra
//
//  Created by Justin Bush on 2020-04-20.
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
        //save(
        // Set Last
        save(true, forKey: Keys.hasLaunched)
    }
}

struct Keys {
    static let theme = "ThemeArray"
    static let style = "StyleArray"
    
    static let firstLaunch = "FirstLaunch"
    static let hasLaunched = "HasLaunchedBefore"
    static let isSignedIn = "SignedIn"
    static let neverAgain = "NeverShowAgain"
    static let countryCode = "CountryCode"
    static let lastURL = "LastSessionURL"
    
    static func allowedType(_ object: Any) -> Bool {
        switch object {
        case is Bool: return true
        case is String: return true
        case is URL: return true
        case is Int: return true
        case is Double: return true
        case is Float: return true
        default: return false
        }
    }
    
    static func saveToDefaults(_ value: Any, forKey: String) {
        if allowedType(value) {
            print("Setting Default: \(value), forKey: \(forKey)")
            Defaults.set(value, forKey: forKey)
        } else {
            print("Error: invalid Default type\nUnable to set Default: \(value), forKey: \(forKey)")
        }
    }
}

