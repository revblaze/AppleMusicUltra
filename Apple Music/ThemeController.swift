//
//  ThemeController.swift
//  Ultra for Apple Music
//
//  Created by Justin Bush on 2020-03-07.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Cocoa
import Foundation


// MARK: Theme Data Setup

enum Type: String {
    case plain      // theme
    case image      // themeWithImage
    case video      // themeWithVideo
    case url        // themeWithURL
}

/*
struct Type {
    static let theme            = "theme"
    static let themeWithURL     = "themeWithURL"
    static let themeWithImage   = "themeWithImage"
    static let themeWithVideo   = "themeWithVideo"
}*/

struct ThemeTemplate {
    var style: String
    var theme: String
    var type:  String
    var image: String
    var video: String
    var url:   String
}


struct ThemeValue {
    let wave    = "wave"
    let spring  = "spring"
    let bubbles = "bubbles"
    let dunes   = "dunes"
    let quartz  = "quartz"
    // Old Themes
    let silk    = "silk"
    let goblin  = "goblin"
    let purple  = "purple"
}

enum Image: String {
    case wave
    case spring
    case bubbles
    case dunes
    case quartz
    // Old Theme Images
    case silk
    case goblin
    case purple
}

enum Video: String {
    case videotitle
}

struct ThemeStructure {
    var style: String
    var theme: String
    var type:  String
    var image: String
    var video: String
    var url:   String
}

let fx = NSVisualEffectView.Material.self
struct Style {
    static let defaultStyle = fx.sheet
    static let vibrant      = fx.toolTip
    static let light        = fx.mediumLight
    static let vibrantLight = fx.light
    static let dark         = fx.ultraDark
    static let vibrantDark  = fx.dark
    static let frosty       = fx.appearanceBased
    static let flat         = fx.titlebar
    static let plain        = fx.headerView
    static let opaque       = fx.underPageBackground
    static let temp         = fx.underWindowBackground
    
    static let values       =
        ["Name": ["defaultStyle", "vibrant", "light", "vibrantLight", "dark", "vibrantDark", "frosty", "flat", "plain", "opaque", "temp"],
        "Value": [11, 17, 8, 1, 9, 2, 0, 3, 10, 22, 21],
     "Material": [".sheet", ".toolTip", ".mediumLight", ".light", ".ultraDark", ".dark", ".appearanceBased", ".titlebar", ".headerView", ".underPageBackground", ".underWindowBackground"]]
}

// blur.material.rawValue = Int
// NSVisualEffect.Material.rawValue = Int
struct GetStyle {
    static let defaultStyle = 11    // .sheet
    static let vibrant      = 17    // .toolTip
    static let light        = 8     // .mediumLight
    static let vibrantLight = 1     // .light
    static let dark         = 9     // .ultraDark
    static let vibrantDark  = 2     // .dark
    static let frosty       = 0     // .appearanceBased
    static let flat         = 3     // .titlebar
    static let plain        = 10    // .headerView
    static let opaque       = 22    // .underPageBackground
    static let temp         = 21    // .underWindowBackground
    
    static let values       =
        ["Name": ["defaultStyle", "vibrant", "light", "vibrantLight", "dark", "vibrantDark", "frosty", "flat", "plain", "opaque", "temp"],
        "Value": [11, 17, 8, 1, 9, 2, 0, 3, 10, 22, 21],
     "Material": [".sheet", ".toolTip", ".mediumLight", ".light", ".ultraDark", ".dark", ".appearanceBased", ".titlebar", ".headerView", ".underPageBackground", ".underWindowBackground"]]
}


class ThemeController {
    
    func setTheme(_ style: Style) {
        // Set theme with Style and transparent background
    }
    
    func setTheme(_ style: Style, withImage: Image) {
        // Set theme with Style and Image background
    }
    
    func setTheme(_ style: Style, withVideo: Video) {
        // Set theme with Style and Video background
    }
    
    func setTheme(_ style: Style, withURL: URL) {
        // Set theme with Style and custom image (from URL)
    }
    
    func printTheme() {
        for i in GetStyle.values {
            print(i)
        }
    }
    
}




