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
    /// Get title/metadata of audio that's current playing
    static let nowPlaying = "document.getElementsByTagName('audio')[0].title"
    /// Get album and/or playlist artwork set (should return array of artwork URLs)
    static let albumArtwork = "document.getElementsByClassName('product-lockup__artwork')[0].getElementsByClassName('media-artwork-v2__image')[0].srcset"
    /// Get artist header image
    static let artistHeader = "document.getElementsByClassName('artist-header')[0].style.getPropertyValue('--background-image')"
    /// Checks for "Sign In" button: 0 = Signed in, 1 = Signed out
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
    
    
    static func cssToJavaScript(_ css: String) -> String {
        let jsCode = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
        return jsCode
    }
}
