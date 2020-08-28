//
//  Theme.swift
//  Ultra
//
//  Created by Justin Bush on 2020-08-01.
//

import Foundation

struct Theme {
    
    static var name = ThemeSettings.name ?? "wave"
    static var type = ThemeType.get()
    static var raw = ThemeSettings.rawURL ?? "wave.jpg"
    static var style = Style.get()
    static var isTransparent = ThemeSettings.isTransparent
    
    static var package = ThemeSettings.package
    
    
    // MARK: Set & Save
    /// Theme variables
    static func set(_ name: String, type: ThemeType, raw: String, style: Style, isTransparent: Bool) {
        Theme.name = name
        Theme.type = type
        Theme.raw = raw
        Theme.style = style
        Theme.isTransparent = isTransparent
        save()
    }
    
    static func save() {
        let package = ThemeManager.toArray(name, type: type, raw: raw, style: style, isTransparent: isTransparent)
        Settings.save(package, forKey: Keys.themePackage)
        ThemeManager.printObject(name, type: type, raw: raw, style: style, isTransparent: isTransparent)
    }
    
    // MARK: Launch Loader
    
    static func initLaunch() {
        if ThemeSettings.package == nil { setDefault() }
        else {
            let package = ThemeSettings.package as! [String]
            ThemeManager.toObject(package)
        }
    }
    
    static func setDefault() {
        Theme.name = "wave"
        Theme.type = ThemeType.image
        Theme.raw = "wave.jpg"  // WebContent/WebFX/images/wave.jpg
        Theme.style = Style.preset
        Theme.isTransparent = false
        save()
    }
}

struct ThemeSettings {
    static let name = Defaults.string(forKey: Keys.themeName)
    static let type = Defaults.string(forKey: Keys.themeType)
    static let rawURL = Defaults.string(forKey: Keys.themeRawURL)
    static let style = Defaults.string(forKey: Keys.styleName)
    static let isTransparent = Defaults.bool(forKey: Keys.transparentWindow)
    
    static let package = Defaults.array(forKey: Keys.themePackage)
}

extension Keys {
    static let themeName = "ThemeNameKey"
    static let themeType = "ThemeTypeKey"
    static let themeRawURL = "ThemeRawURLKey"
    static let styleName = "StyleNameKey"
    static let transparentWindow = "TransparentWindowKey"
    
    static let themePackage = "ThemePackageKey"
    
}

