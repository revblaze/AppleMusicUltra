//
//  UserActive.swift
//  Themes for Music
//
//  Created by Justin Bush on 2020-04-18.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import AppKit
import Foundation

struct Active {
    static var style = Style.shadow     // OLD: Style.preset
    static var clear = false            // OLD: true
    static var mode  = true             // OLD: true
    static var image = "wave"           // OLD: ""
    static var theme = [style, clear, mode, image] as [Any]
    
    static var url = Music.url          // Save current URL to memory
}

struct User {
    static var co = Defaults.string(forKey: UserKeys.countryCode)           // Country Code
    static var isSignedIn = Defaults.bool(forKey: UserKeys.isSignedIn)      // User isSignedIn
    static var firstLaunch = Defaults.bool(forKey: UserKeys.firstLaunch)    // First Launch
    static var neverShowAgain = Defaults.bool(forKey: UserKeys.neverAgain)  // Never Show Again
    static var lastSessionURL = Defaults.string(forKey: UserKeys.lastURL)   // Last Session URL
}

struct UserKeys {
    static let countryCode = "CountryCode"                                  // Country Code Key
    static let isSignedIn = "signedIn"                                      // User isSignedIn Key
    static let firstLaunch = "firstLaunch"                                  // First Launch Key
    static let neverAgain = "NeverAgain"                                    // Never Show Again Key
    static let lastURL = "LastSessionURL"                                   // Last Session URL Key
}

