//
//  Settings.swift
//  Ultra
//
//  Created by Justin Bush on 2020-08-01.
//

import Foundation

struct Settings {
    
    // MARK: User Settings
    static let isSignedIn = Defaults.bool(forKey: Keys.isSignedIn)
    
    
    
    // MARK: Default Settings
    static func setDefaults() {
        save(Service.appleBeta.id, forKey: Keys.musicService)   // Set Default Service
    }
    
    
    
    // MARK: Save to Defaults
    /// Saves any `value` with corresponding `key` to `UserDefaults` iff the value is an allowed type.
    /// # Usage
    ///     DefaultsManager.save(true, forKey: Keys.hasLaunchedBefore
    /// - Parameters:
    ///     - value: The value to be saved to UserDefaults (see `allowedTypes` in `DefaultsManager`)
    static func save(_ value: Any, forKey: String) {
        DefaultsManager.save(value, forKey: forKey)
    }
    
}

