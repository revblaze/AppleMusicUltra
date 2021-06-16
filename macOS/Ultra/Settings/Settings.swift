//
//  Settings.swift
//  Ultra
//
//  Created by Justin Bush on 2021-06-16.
//

import Foundation

struct Settings {
    
    // MARK: User Events
    static let isSignedIn = Defaults.bool(forKey: Keys.isSignedIn)                  // User Sign In status
    static let hasLaunchedBefore = Defaults.bool(forKey: Keys.hasLaunchedBefore)    // App has launched before
    //static let hasLaunchedUpdate = Defaults.bool(forKey: Keys.hasLaunchedUpdate)    // Latest update has launched before
    
    // MARK: User Settings
    static let theme = Defaults.string(forKey: Keys.theme)
    static let dontShowAgain = Defaults.bool(forKey: Keys.dontShowAgain)
    
    static let mobileBetaDidAppear = Defaults.bool(forKey: Keys.mobileBetaDidAppear)
    
    // MARK: Default Settings
    /// Reset to default app settings
    static func setDefaults() {
        //User.setDefault()
        //Preferences.setDefault()
        sync()
    }
    /// Print current app settings
    static func printDefaults() {
        let defaults = """
        Settings.theme: \(String(describing: Settings.theme))
        Settings.isSignedIn: \(String(describing: Settings.isSignedIn))
        """
        print(defaults)
    }
    
    static func restoreDefaults() {
        Settings.save(false, forKey: Keys.isSignedIn)
        Settings.save(false, forKey: Keys.hasLaunchedBefore)
        //Settings.save(false, forKey: Keys.hasLaunchedUpdate)
        Settings.save(false, forKey: Keys.dontShowAgain)
        Settings.save(false, forKey: Keys.mobileBetaDidAppear)
        sync()
    }
    
    static func sync() {
        Defaults.synchronize()
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
