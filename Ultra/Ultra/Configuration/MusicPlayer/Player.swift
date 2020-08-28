//
//  Player.swift
//  Ultra
//
//  Created by Justin Bush on 2020-08-01.
//

import Foundation

struct Player {
    
    /// Determines if Player is active and ready for activeEventListeners
    static var isActive = false
    
    /// Called when the Player is ready, no longer disabled and has music loaded up.
    ///
    /// Updates `Player.isActive = true`
    /// and determines if webView is ready for `activeEventListeners`
    static func didBecomeActive() {
        isActive = true
        Music.isPlaying = true
    }
    
}
