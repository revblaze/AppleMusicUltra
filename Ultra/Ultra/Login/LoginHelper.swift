//
//  LoginHandler.swift
//  Ultra
//
//  Created by Justin Bush on 2020-04-21.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Foundation

struct LoginHelper {
    
    static func checkStatusAndUpdate(_ key: Int) {
        if key == 0 { Active.isSignedIn = true
            User.save(true, forKey: Keys.isSignedIn)
        }
        else if key == 1 { Active.isSignedIn = false
            User.save(false, forKey: Keys.isSignedIn)
        }
    }
    
    /// Returns `true` if either `User.isSignedIn` or `Active.isSignedIn` are true
    static func activeAccount() -> Bool {
        if User.isSignedIn || Active.isSignedIn {
            return true
        } else {
            return false
        }
    }
    
    static func isWindowVisible(key: Bool, visible: Bool) -> Bool {
        if key || visible { return true }
        else { return false }
    }
    
    static func printDebug(key: Bool, vis: Bool) {
        print("User.isSignedIn (Defaults): \(User.isSignedIn), Active.isSignedIn")
        print("LoginWindow.isKey: \(key), LoginWindow.isVisible: \(vis)")
    }
    
}
