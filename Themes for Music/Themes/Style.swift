//
//  Style.swift
//  Themes for Music
//
//  Created by Justin Bush on 2020-03-21.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import AppKit
import Foundation

var lightMode = NSAppearance(named: .aqua) ?? .init()
var darkMode  = NSAppearance(named: .darkAqua) ?? .init()

struct Style {                                                          // NAME         TYPE         rawValue
    static let preset = NSVisualEffectView.Material.appearanceBased     // Preset       (Default)       0
    static let frosty = NSVisualEffectView.Material.sheet               // Frosty       (Opaque)        11
    static let bright = NSVisualEffectView.Material.mediumLight         // Bright       (Middle)        8
    static let energy = NSVisualEffectView.Material.light               // Energy       (Transparent)   1
    static let cloudy = NSVisualEffectView.Material.ultraDark           // Cloudy       (Opaque)        9
    static let shadow = NSVisualEffectView.Material.toolTip             // Shadow       (Middle)        17
    static let vibing = NSVisualEffectView.Material.dark                // Vibing       (Transparent)   2
    
    static func stringToStyle(_ style: String) -> NSVisualEffectView.Material {
        switch style {
        case "preset":
            return preset
        case "frosty":
            return frosty
        case "bright":
            return bright
        case "energy":
            return energy
        case "cloudy":
            return cloudy
        case "shadow":
            return shadow
        case "vibing":
            return vibing
        default:
            return preset
        }
    }
    
    static func toMaterial(_ style: String) -> Styles {
        switch style {
        case "preset":
            return Styles.preset
        case "frosty":
            return Styles.frosty
        case "bright":
            return Styles.bright
        case "energy":
            return Styles.energy
        case "cloudy":
            return Styles.cloudy
        case "shadow":
            return Styles.shadow
        case "vibing":
            return Styles.vibing
        default:
            return Styles.preset
        }
    }
}

enum Styles {       // NAME         TYPE                     rawValue           Material
    case preset     // Preset       (Default)                   0           .appearanceBased
    case frosty     // Frosty       (Light Opaque)              11          .sheet
    case bright     // Bright       (Light Middle)              8           .mediumLight
    case energy     // Energy       (Light Transparent)         1           .light
    case cloudy     // Cloudy       (Dark Opaque)               9           .ultraDark
    case shadow     // Shadow       (Dark Middle)               17          .toolTip
    case vibing     // Vibing       (Dark Transparent)          2           .dark

    var fx: NSVisualEffectView.Material {
        switch self {
        case .preset:
            return .appearanceBased
        case .frosty:
            return .sheet
        case .bright:
            return .mediumLight
        case .energy:
            return .light
        case .cloudy:
            return .ultraDark
        case .shadow:
            return .toolTip
        case .vibing:
            return .dark
        }
    }
    
    var isDark: Bool {
        switch self {
        case .preset:
            return false
        case .frosty:
            return false
        case .bright:
            return false
        case .energy:
            return false
        case .cloudy:
            return true
        case .shadow:
            return true
        case .vibing:
            return true
        }
    }
    
    var name: String {
        switch self {
        case .preset:
            return "preset"
        case .frosty:
            return "frosty"
        case .bright:
            return "bright"
        case .energy:
            return "energy"
        case .cloudy:
            return "cloudy"
        case .shadow:
            return "shadow"
        case .vibing:
            return "vibing"
        }
    }
    
    var raw: Int {
        switch self {
        case .preset:
            return 0
        case .frosty:
            return 11
        case .bright:
            return 8
        case .energy:
            return 1
        case .cloudy:
            return 9
        case .shadow:
            return 17
        case .vibing:
            return 2
        }
    }
}

