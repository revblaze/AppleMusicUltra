//
//  DefaultsManager.swift
//  Ultra
//
//  Created by Justin Bush on 2020-08-01.
//

import Foundation

let Defaults = UserDefaults.standard

struct DefaultsManager {
    
    static func allowedType(_ object: Any) -> Bool {
        switch object {
        case is Bool: return true
        case is String: return true
        case is URL: return true
        case is Int: return true
        case is Double: return true
        case is Float: return true
        case is Array<String>: return true
        default: return false
        }
    }
    /// Saves any `value` with corresponding `key` to `UserDefaults` iff the value is an allowed type.
    /// # Usage
    ///     DefaultsManager.save(true, forKey: Keys.hasLaunchedBefore
    /// - Parameters:
    ///     - value: The value to be saved to UserDefaults (see `allowedTypes` in `DefaultsManager`)
    ///     - forKey: The key-value `String` that corresponds with the value saved
    static func save(_ value: Any, forKey: String) {
        if allowedType(value) {
            if debug { print("Setting Default: \(value), forKey: \(forKey)") }
            Defaults.set(value, forKey: forKey)
        } else {
            if debug { print("Error: invalid Default type\nUnable to set Default: \(value), forKey: \(forKey)") }
        }
    }
    
}
