//
//  Script+Login.swift
//  Ultra
//
//  Created by Justin Bush on 2020-08-20.
//

import Foundation

// MARK: Login Scripts

extension Script {
    
    // MARK: Login Status
    /// `0 = Signed-in | 1 = Signed-out`
    /// # Process
    /// Once the script is run through webView, it will return one of two results as a `String`.
    ///
    ///     if result.contains("0") { User.isSignedIn }
    ///     else if result.contains("1") { !User.isSignedIn }
    ///     else { print("webView returned error") }
    static let loginStatus = "document.getElementsByClassName('web-navigation__auth-button')[0].classList.contains('web-navigation__auth-button--sign-in');" //"document.querySelector('.web-navigation__auth-button').classList.contains('web-navigation__auth-button--sign-in');"
    
}
