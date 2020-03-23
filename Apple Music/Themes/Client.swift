//
//  Client.swift
//  Ultra for Apple Music
//
//  Created by Justin Bush on 2020-03-23.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import AppKit
import Foundation

struct Music {
    static let app = "Apple Music Web Client"
    static let url = "https://beta.music.apple.com"
    static let userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_3) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.5 Safari/605.1.15"
}

// ie. User.type
struct User {
    static let darkMode = Defaults.bool(forKey: "darkMode")                     // dark ? light
    static let type     = Defaults.string(forKey: "type")   ?? "transparent"    // tansparent, image, video, dynamic, url
    static let style    = Defaults.object(forKey: "style")  as? NSVisualEffectView.Material ?? .appearanceBased
    static let image    = Defaults.string(forKey: "image")  ?? ""               // "wave"
    static let video    = Defaults.string(forKey: "video")  ?? ""               // "poly"
    static let url      = Defaults.url(forKey: "url")       ?? URL(string: "")  // "file://"
    static let dynamic  = Defaults.string(forKey: "dynamic")                    // TBD
}
