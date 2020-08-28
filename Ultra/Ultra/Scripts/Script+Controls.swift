//
//  Script+Controls.swift
//  Ultra
//
//  Created by Justin Bush on 2020-08-20.
//

import Foundation

extension Script {
    
    // MARK: Basic Controls
    /// Play current song
    static let playSong = "document.querySelectorAll('[data-test-playback-control-play]')[0].click();"
    /// Pause current song
    static let pauseSong = "document.querySelectorAll('button[data-test-playback-control-pause]')[0].click();"
    /// Play previous song
    static let backSong = "document.getElementsByClassName('web-chrome-playback-controls__playback-btn')[0].click();"
    /// Play next song
    static let nextSong = "document.getElementsByClassName('web-chrome-playback-controls__playback-btn')[2].click();"
    
    
    
    // MARK: Shuffle Controls
    // document.getElementsByClassName('web-chrome-playback-controls__secondary-btn')[0].getAttribute('aria-label')
    //      >> "Shuffle"        'aira-checked' = Shuffle OFF
    /// Toggles shuffle button click
    static let toggleShuffle = "document.getElementsByClassName('web-chrome-playback-controls__secondary-btn')[0].click();"
    /// Returns Shuffle status: `true` Shuffle on; `false` Shuffle off
    static let shuffleOn = "document.getElementsByClassName('web-chrome-playback-controls__secondary-btn')[0].getAttribute('aria-checked');"
    
    
    
    // MARK: Repeat Controls
    /// Return Repeat status:
    /// `Repeat`: Repeat OFF
    /// `Repeat all`: Repeat ON
    /// `Repeat one`: Repeat ON single song
    static let toggleRepeat = "document.getElementsByClassName('web-chrome-playback-controls__secondary-btn')[1].click();"
    static let repeatStatus = "document.getElementsByClassName('web-chrome-playback-controls__secondary-btn')[1].getAttribute('aria-label')"
    static let repeatOn = "document.getElementsByClassName('web-chrome-playback-controls__secondary-btn')[1].getAttribute('aria-checked')"
    
    
    
    // MARK: Up Next Controls
    /// Show Up Next popover
    static let toggleUpNext = "document.getElementsByClassName('web-chrome-playback-controls__up-next-btn')[0].click();"
    
}
