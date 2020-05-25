//
//  Scripts.swift
//  Ultra Lite
//
//  Created by Justin Bush on 2020-05-22.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Foundation

struct Script {
    
    
    
    
    
    // MARK:- Login Scripts
    
    /// Checks for "Sign In" button: 0 = Signed in, 1 = Signed out
    static let loginButton = "document.querySelector('.web-navigation__auth-button').classList.contains('web-navigation__auth-button--sign-in')"
    
    
    /// Grabs CSS from `cssFile` (inside `WebCode`) and outputs the executable JS code
    static func toJS(_ cssFile: String) -> String {
        let css = JSHelper.cssToString(file: cssFile, inDir: "WebCode")
        let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
        return js
    }
}
