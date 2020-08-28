//
//  Keys.swift
//  Ultra
//
//  Created by Justin Bush on 2020-08-01.
//

import Foundation

struct Keys {
    
    // MARK: User Keys
    static let isSignedIn = "UserSignInKey"
    
    // MARK: System Keys
    static let hasLaunchedBefore = "HasLaunchedBeforeKey"
    static let hasLaunchedUpdate = "HasLaunchedUpdateKey\(Client.version)"
    
}
