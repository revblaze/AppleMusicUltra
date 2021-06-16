//
//  Theme.swift
//  Ultra
//
//  Created by Justin Bush on 2021-06-16.
//

import Cocoa

@available(OSX 10.14, *)
struct Theme {
    
    var isTransparent = false               // Default window blur type
    var media = Media.image                 // Default media type
    var source = "monterey"                 // Default media source
    var material = Material.none            // Default material
    
    enum Media {
        case image
        case video
        case web
    }
    
    enum Material {
        case none
        case glass
        case cloudy
        case frosty
        
        var effect: NSVisualEffectView.Material {
            switch self {
            case .none:     return .windowBackground
            case .glass:    return .fullScreenUI
            case .cloudy:   return .appearanceBased
            case .frosty:   return .menu
            }
        }
    }
    
    struct Default {
        static let isTransparent = Defaults.bool(forKey: Keys.Theme.isTransparent)
        static let media = Defaults.integer(forKey: Keys.Theme.media)
        static let source = Defaults.string(forKey: Keys.Theme.source)
        static let material = Defaults.integer(forKey: Keys.Theme.material)
    }
    
}


extension Keys {
    struct Theme {
        static let isTransparent = "TransparentThemeKey"
        static let media = "MediaThemeKey"
        static let source = "MediaSourceThemeKey"
        static let material = "MaterialThemeKey"
    }
}
