//
//  Script+EventListeners.swift
//  Ultra
//
//  Created by Justin Bush on 2020-08-25.
//

import Foundation

extension Script {
    
    /// Checks to see if the Player is active or disabled for `activeEventListeners`
    /// ~~~
    /// "true"  = disabled
    /// "false" = active
    /// ~~~
    static let isPlayerDisabled = "document.getElementsByClassName('button-reset web-chrome-playback-controls__secondary-btn')[0].getAttribute('aria-disabled');"
    
    
    // MARK:- Active Event Listeners
    /// All event listeners that require the Player to be active
    static let addActiveListeners = audioEventListeners // + controlListener
    
    static let audioEventListeners = EventManager.getAudioListeners()
    
    // DEPRECATED
    //static let audioListener = "document.getElementsByTagName('audio')[0].addEventListener('playing', function() { window.webkit.messageHandlers.audioListener.postMessage('Audio is playing'); });"
    //static let audioPlayingListener = "document.getElementsByTagName('audio')[0].addEventListener('playing', function() { window.webkit.messageHandlers.audioListener.postMessage('Audio is playing'); });"
}

struct EventManager {
    // Audio Events
    // https://developer.mozilla.org/en-US/docs/Web/Guide/Events/Media_events
    static let eventsToListenFor = [
        "loadstart",    // Media did begin loading
        "canplay",      // Sent when enough media has loaded to begin playing
        "play",         // Audio did start to play (!paused)
        "pause",        // Audio did pause
        "playing",      // Play + stall recovery, media restart and seeking
        "waiting",      // Sent when the requested task is delayed
        "volumechange", // Volume of player has changed (including mute)
        "abort",        // Sent when playback is aborted (ie. restart song)
        "error"]        // Sent when error occurs (see Error return in console)
    
    
    static var audioEventsCode = ""
    static func getAudioListeners() -> String {
        for event in eventsToListenFor {
            audioEventsCode = audioEventsCode + "document.getElementsByTagName('audio')[0].addEventListener('\(event)', function() { window.webkit.messageHandlers.audioListener.postMessage('\(event)'); });"
        }
        return audioEventsCode
    }
    
}
