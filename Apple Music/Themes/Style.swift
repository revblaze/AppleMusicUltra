//
//  Style.swift
//  Ultra for Apple Music
//
//  Created by Justin Bush on 2020-03-23.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import AppKit
import Foundation

// ie. Style.preset
struct Style {                                                          // NAME         TYPE             rawValue
    static let preset = NSVisualEffectView.Material.appearanceBased     // Default       -                  0
    static let frosty   = NSVisualEffectView.Material.sheet             // Frosty       Light Opaque        11
    static let bright   = NSVisualEffectView.Material.mediumLight       // Bright       Light Middle        8
    static let energy   = NSVisualEffectView.Material.light             // Vibrant      Light Transparent   1
    static let cloudy   = NSVisualEffectView.Material.ultraDark         // Cloudy       Dark Opaque         9
    static let dark     = NSVisualEffectView.Material.toolTip           // Dark         Dark Middle         17
    static let vibrant  = NSVisualEffectView.Material.dark              // Vibrant      Dark Transparent    2
}
