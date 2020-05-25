//
//  WKHandler.swift
//  Ultra
//
//  Created by Justin Bush on 2020-04-20.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Foundation

struct URLHandler {
    /// Get `User.countryCode` via input `URL`
    static func getCountryCode(_ urlString: String) -> String {
        let removeBaseURL = urlString.replacingOccurrences(of: "\(Ultra.url)/", with: "")
        let countryCode = String(removeBaseURL.prefix(2))
        if countryCode.count == 2 { return countryCode }
        return User.countryCode ?? "us"
    }
    /// Get & save `User.countryCode` to `Defaults` via input `String(URL)`
    static func setCountryCode(_ urlString: String) {
        let countryCode = getCountryCode(urlString)
        if User.isSignedIn && User.countryCode != countryCode {
            User.save(countryCode, forKey: Keys.countryCode)
        }
    }
    
    static let authURL = "authorize.music.apple.com"
    static let mainURL = "music.apple.com"
    /// Check if User login was successful
    static func userDidLogin(_ url: String, last: String) -> Bool {
        if url.contains(mainURL) && last.contains(authURL) { print("User Login Successful"); return true }
        else { return false }
    }
}

