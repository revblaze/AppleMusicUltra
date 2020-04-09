//
//  Scripts.swift
//  Themes for Music
//
//  Created by Justin Bush on 2020-04-07.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import AppKit
import Foundation

struct Script {
    /// Checks for "Sign In" button: 0 = Signed in, 1 = Signed out
    //static let loginButton = "document.getElementsByClassName('web-navigation__auth-button').classList.contains('web-navigation__auth-button--sign-in');"
    static let loginButton = "document.querySelector('.web-navigation__auth-button').classList.contains('web-navigation__auth-button--sign-in')"
    static let signInOut = "document.querySelector('.web-navigation__auth-button').click();"
    /// Prompt user to Sign in
    static let loginUser = "document.querySelector('.web-navigation__auth-button').click();"
    /// Sign out user
    static let logoutUser = "document.querySelector('.web-navigation__auth-button').click();"
    //static let logoutUser = "document.querySelector('.web-navigation__auth-button')[0].click();"
    //static let logoutUser = "document.querySelector('.web-navigation__auth-button').classList.contains('web-navigation__auth-button').click();"
    //static let logoutUser = "document.querySelector('.web-navigation__auth-button').click(); document.querySelector('.context-menu__option-text').click();"
    //static let logoutUser = "document.querySelector('.web-navigation__auth-button').classList.contains('web-navigation__auth-button--sign-out')"
    //static let logoutUser = "document.querySelector('.context-menu__option-text')[0].click();"
    //static let logoutUser = "document.querySelector('.web-navigation__auth-button').querySelector('.context-menu__option-text').click();"
    //static let logoutUser = "document.querySelector('.web-navigation__auth-button .context-menu__option-text').click();"
    //static let logoutUser = "document.querySelector('.context-menu__option-text').textContent('Sign Out').click();"
}
