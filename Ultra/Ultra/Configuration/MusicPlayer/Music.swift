//
//  Music.swift
//  Ultra
//
//  Created by Justin Bush on 2020-08-01.
//

import Foundation

struct Music {
    
    static var service = Settings.musicService
    
    // URL of Web Player to Load
    static let url = Service.appleBeta.url // + "/browse"
    // TODO: new let url =
    static let serviceURL = Service.get().url   // This will be new url value after setDefaults check
    
    // MARK: Music Status
    static var isPlaying = false
    static var isPaused = false //!isPlaying
    
    
    
    // MARK:- Music Service
    
}

extension Settings {
    static let musicService = Defaults.string(forKey: Keys.musicService)
}
extension Keys {
    static let musicService = "MusicServiceKey"
}

enum Service {
    
    case apple
    case appleBeta
    /// `URL` as `String` for music service provider
    var url: String {
        switch self {
        case .apple:        return "https://music.apple.com"
        case .appleBeta:    return "https://beta.music.apple.com"
        }
    }
    /// `String literal` identifier for music service provider
    var id: String {
        switch self {
        case .apple:        return "Apple"
        case .appleBeta:    return "AppleBeta"
        }
    }
    /// Get `Service` type based on saved key-value: `Settings.musicService`
    static func get() -> Service {
        if let service = Settings.musicService {
            if service == "AppleBeta" {
                return Service.appleBeta
            } else {
                return Service.apple
            }
        }
        return Service.apple
    }
    /// Sets new `Service` case for `Music.service` and saves to UserDefaults
    /// - Parameters:
    ///     - service: Music service provider (ie. `.appleBeta`)
    static func set(_ service: Service) {
        let serviceString = service.id
        Music.service = serviceString
        Settings.save(serviceString, forKey: Keys.musicService)
    }
    
}
