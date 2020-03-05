//
//  Settings.swift
//  Apple Music
//
//  Created by Justin Bush on 2020-03-05.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Foundation

struct Settings {
    
}

// NSVisualEffect.Material.rawValue = Int
// blur.material.rawValue = Int
struct Style {
    static let defaultStyle = 11
    static let vibrant      = 17
    static let light        = 8
    static let vibrantLight = 1
    static let dark         = 9
    static let vibrantDark  = 2
    static let frosty       = 0
    static let flat         = 3
    static let plain        = 10
    static let opaque       = 22
    static let temp         = 21
    
    static let values       =
        ["Name": ["defaultStyle", "vibrant", "light", "vibrantLight", "dark", "vibrantDark", "frosty", "flat", "plain", "opaque", "temp"],
        "Value": [11, 17, 8, 1, 9, 2, 0, 3, 10, 22, 21],
     "Material": [".sheet", ".tooltip", ".mediumLight", ".light", ".ultraDark", ".dark", ".appearanceBased", ".titlebar", ".headerView", ".underPageBackground", ".underWindowBackground"]]
}

class Styles {
    
    func helloWorld() {
        print("Hello, World")
    }
    
}


