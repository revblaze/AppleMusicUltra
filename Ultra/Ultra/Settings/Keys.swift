//
//  Keys.swift
//  Ultra
//
//  Created by Justin Bush on 2020-05-25.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Foundation

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
