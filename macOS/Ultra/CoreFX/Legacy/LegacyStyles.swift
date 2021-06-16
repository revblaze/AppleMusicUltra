//
//  LegacyStyles.swift
//  Ultra
//
//  Created by Justin Bush on 2021-06-16.
//

import Cocoa

@available(OSX 10.14, *)
var darkMode  = NSAppearance(named: .darkAqua) ?? .init()
var lightMode = NSAppearance(named: .aqua) ?? .init()


enum Style {       // NAME         TYPE                     rawValue           Material
    case preset     // Preset       (Default)                   0           .appearanceBased
    case frosty     // Frosty       (Light Opaque)              11          .sheet
    case bright     // Bright       (Light Middle)              8           .mediumLight
    case energy     // Energy       (Light Transparent)         1           .light
    case cloudy     // Cloudy       (Dark Opaque)               9           .ultraDark
    case shadow     // Shadow       (Dark Middle)               17          .toolTip
    case vibing     // Vibing       (Dark Transparent)          2           .dark

    var fx: NSVisualEffectView.Material {
        switch self {
        case .preset: return .appearanceBased
        case .bright: return .mediumLight
        case .energy: return .light
        case .cloudy: return .ultraDark
        case .vibing: return .dark
        // macOS 10.12+ Compatibility
        case .frosty: if #available(OSX 10.14, *) { return .sheet }
            else { return .mediumLight }
        case .shadow: if #available(OSX 10.14, *) { return .toolTip }
            else { return .dark }
        }
    }
    
    var isDark: Bool {
        switch self {
        case .preset: return false
        case .frosty: return false
        case .bright: return false
        case .energy: return false
        case .cloudy: return true
        case .shadow: return true
        case .vibing: return true
        }
    }
    
    var name: String {
        switch self {
        case .preset: return "preset"
        case .frosty: return "frosty"
        case .bright: return "bright"
        case .energy: return "energy"
        case .cloudy: return "cloudy"
        case .shadow: return "shadow"
        case .vibing: return "vibing"
        }
    }
    
    var raw: Int {
        switch self {
        case .preset: return 0
        case .frosty: return 11
        case .bright: return 8
        case .energy: return 1
        case .cloudy: return 9
        case .shadow: return 17
        case .vibing: return 2
        }
    }
}


struct StyleHelper {                                                    // NAME         TYPE         rawValue
    static let preset = NSVisualEffectView.Material.appearanceBased     // Preset       (Default)       0
    @available(OSX 10.14, *)
    static let frosty = NSVisualEffectView.Material.sheet               // Frosty       (Opaque)        11
    static let bright = NSVisualEffectView.Material.mediumLight         // Bright       (Middle)        8
    static let energy = NSVisualEffectView.Material.light               // Energy       (Transparent)   1
    static let cloudy = NSVisualEffectView.Material.ultraDark           // Cloudy       (Opaque)        9
    @available(OSX 10.14, *)
    static let shadow = NSVisualEffectView.Material.toolTip             // Shadow       (Middle)        17
    static let vibing = NSVisualEffectView.Material.dark                // Vibing       (Transparent)   2
    
    
    
    // Deprecated Styles (macOS 10.12+)
    // BUG: Crash upon calling
    static func legacyStyle(_ style: Style) -> NSVisualEffectView.Material {
        if #available(OSX 10.14, *) { return style.fx }
        else {
            switch style {
            case .frosty: return StyleHelper.bright
            case .shadow: return StyleHelper.vibing
            default: return StyleHelper.preset
            }
        }
    }
    
    static func stringToStyle(_ style: String) -> NSVisualEffectView.Material {
        switch style {
        case "preset": return preset
        case "frosty": if #available(OSX 10.14, *) { return frosty } else { return bright }
        case "bright": return bright
        case "energy": return energy
        case "cloudy": return cloudy
        case "shadow": if #available(OSX 10.14, *) { return shadow } else { return vibing }
        case "vibing": return vibing
        default: return preset
        }
    }
    
    static func toMaterial(_ style: String) -> Style {
        switch style {
        case "preset": return Style.preset
        case "frosty": return Style.frosty
        case "bright": return Style.bright
        case "energy": return Style.energy
        case "cloudy": return Style.cloudy
        case "shadow": return Style.shadow
        case "vibing": return Style.vibing
        default: return Style.preset
        }
    }
}

