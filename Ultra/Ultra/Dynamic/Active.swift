//
//  Active.swift
//  Ultra
//
//  Created by Justin Bush on 2020-04-20.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Foundation

// Observe Struct property (maybe trigger FX function on Active.name change?)
// https://stackoverflow.com/questions/54231759/is-it-possible-to-add-an-observer-on-struct-variable-in-swift
struct Active {
    static var style = Style.shadow         // Theme: Style
    static var clear = false                // Theme: Transparent Window
    static var mode  = true                 // Theme: Mode (Dark ? Light)
    
    static var image = "wave"
    
    static var type  = Theme.FX.image       // Theme: Type
    static var name  = "wave"               // Theme: Name
    
    static var path  = URL(string: "")      // Theme: Custom Image URL Path
    static var isURL = false                // Theme: is Custom Image
    
    static var theme = [style, clear, mode, type, name] as [Any]
    //static var theme = [style, clear, mode, image] as [Any]
    
    static var url = Ultra.url
    
    static var isSignedIn = false
    
    /**
    Sets `Active` Style values for attributes: `.style` and `.mode`
     - parameters:
        - style: `Style` object to set as `Active`
    */
    static func setStyle(_ styleObject: Style) {
        style = styleObject
        mode = style.isDark
        print("Set Active: Style\n  name: \(style.name)\n  dark: \(style.isDark)")
    }
    
    /**
    Sets `Active` Theme values for attributes: `.image` and `.clear`
     - parameters:
        - image: `NSImage` value for `imageView` object to set as `Active`
        - clear: `Bool` value for corresponding `Transparent ? Image` Theme types
    */
    static func setTheme(_ themeString: String, isType: Theme.FX, isClear: Bool) {
        name = themeString      // Set Theme name
        type = isType           // Set Theme type
        clear = isClear         // Set Theme transparency
        isURL = false           // Theme is not URL (custom image)
        print("Set Active: Theme\n  name: \(name)\n  type: \(type.toString)\n clear: \(clear)")
    }
    static func setCustomTheme(_ imageURL: URL) {
        name = "custom"
        path = imageURL
        isURL = true
        print("Set Active: Custom Theme\n  path: \(String(describing: path?.absoluteString))")
    }
    
    
    static func saveDefaults() {
        // User.save(isSignedIn
        //let themeArray = Theme.toArray(Active.style, clear: Active.clear, mode: Active.mode, image: Active.image)
        //let themeArray = Theme.toArray(Active.style, clear: Active.clear, mode: Active.mode, type: Active.type, name: Active.name)
        let themeArray = Theme.toArray(style, clear: clear, mode: mode, type: type, name: name)
        User.save(themeArray, forKey: Keys.theme)
    }
    
    static func loadDefaults() {
        let defaultArray = ["shadow", "false", "true", "image", "wave"]      // Default
        //let themeArray = Defaults.stringArray(forKey: "ActiveTheme") ?? defaultArray
        let themeArray = User.theme ?? defaultArray
        Theme.toActive(themeArray)
    }
}

