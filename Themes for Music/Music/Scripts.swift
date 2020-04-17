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
    // UI Scripts
    /// Hide left side bar
    
    /// Show Up Next popover
    static let toggleUpNext = "document.getElementsByClassName('web-chrome-playback-controls__up-next-btn')[0].click();"
    /// Check if Up Next popover is open; returns: `true` or `false`
    static let isUpNextOpen = "document.getElementsByClassName('web-chrome-playback-controls__up-next-btn')[0].getAttribute('aria-expanded');"
    
    
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
    
    // Getting attribute labels
    // document.getElementsByClassName('web-chrome-playback-controls__playback-btn')[0].getAttribute('aria-label')
    //      >> "Previous"
    // document.getElementsByClassName('web-chrome-playback-controls__playback-btn')[1].getAttribute('aria-label')
    //      >> "Pause" / "Play"
    // document.getElementsByClassName('web-chrome-playback-controls__playback-btn')[2].getAttribute('aria-label')
    //      >> "Next"
    
    /// Checks current audio state, returns: "Play" (music is paused) or "Pause" (music is playing)
    static let getMusicStatus = "document.getElementsByClassName('web-chrome-playback-controls__playback-btn')[1].getAttribute('aria-label')"
    /// Play / Pause toggle
    static let controlMusic = "document.getElementsByClassName('web-chrome-playback-controls__playback-btn')[1].click();"
    /// Play previous song
    static let backSong = "document.getElementsByClassName('web-chrome-playback-controls__playback-btn')[0].click();"
    /// Play next song
    static let nextSong = "document.getElementsByClassName('web-chrome-playback-controls__playback-btn')[2].click();"
    
    // Shuffle Music
    // document.getElementsByClassName('web-chrome-playback-controls__secondary-btn')[0].getAttribute('aria-label')
    //      >> "Shuffle"        'aira-checked' = Shuffle OFF
    /// Toggles shuffle button click
    static let toggleShuffle = "document.getElementsByClassName('web-chrome-playback-controls__secondary-btn')[0].click();"
    /// Returns Shuffle status: `true` Shuffle on; `false` Shuffle off
    static let shuffleOn = "document.getElementsByClassName('web-chrome-playback-controls__secondary-btn')[0].getAttribute('aria-checked')"
    
    // Repeat Music
    /// Return Repeat status:
    /// `Repeat`: Repeat OFF
    /// `Repeat all`: Repeat ON
    /// `Repeat one`: Repeat ON single song
    static let toggleRepeat = "document.getElementsByClassName('web-chrome-playback-controls__secondary-btn')[1].click();"
    static let repeatStatus = "document.getElementsByClassName('web-chrome-playback-controls__secondary-btn')[1].getAttribute('aria-label')"
    static let repeatOn = "document.getElementsByClassName('web-chrome-playback-controls__secondary-btn')[1].getAttribute('aria-checked')"
    
    /// Set Music Player to mute (slider value = 0)
    /// TODO: Only changes appearance value of volume slider – have yet to figure out how to trigger event that accepts said value
    // var volume = document.getElementsByClassName('web-chrome-playback-lcd__volume-scrubber')[0]; x.value = 0; x.nodeValue = 0; ???x.dispatchEvent(Audio)???;
    static let muteSong = "document.getElementsByClassName('web-chrome-playback-lcd__volume-scrubber')[0].value = ('0');"
    
    
    
    
    static func cssToJavaScript(_ css: String) -> String {
        let jsCode = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
        return jsCode
    }
}
