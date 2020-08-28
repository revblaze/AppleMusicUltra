//
//  User.swift
//  Ultra
//
//  Created by Justin Bush on 2020-08-10.
//

import Foundation

struct User {
    
    static var isSignedIn = Settings.isSignedIn
    
    ///
    static func updateStatus(_ signedIn: Bool) {
        if signedIn { Debug.log("User is signed in") }
        else { Debug.log("User is signed OUT") }
        save(signedIn, forKey: Keys.isSignedIn)
    }
    
    
    // MARK: Functions
    
    static func save(_ value: Any, forKey: String) {
        Settings.save(value, forKey: forKey)
    }
    
}

