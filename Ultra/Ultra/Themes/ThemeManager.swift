//
//  ThemeManager.swift
//  Ultra
//
//  Created by Justin Bush on 2020-08-27.
//

import Foundation

struct ThemeManager {
    
    static func toArray(_ name: String, type: ThemeType, raw: String, style: Style, isTransparent: Bool) -> [String] {
        //var transparentString = "false"
        //if isTransparent { transparentString = "true" }
        let transparentString = boolToString(isTransparent)
        
        return [name, type.toString, raw, style.name, transparentString]
    }
    
    static func toObject(_ array: [String]) {
        // Extract String Values
        let name                = array[0]
        let typeString          = array[1]
        let raw                 = array[2]
        let styleString         = array[3]
        let transparentString   = array[4]
        // Set necessary Strings to correlating Object values
        let type = ThemeType.get(typeString)
        let style = Style.get(styleString)
        let isTransparent = stringToBool(transparentString)
        
        Theme.set(name, type: type, raw: raw, style: style, isTransparent: isTransparent)
        printObject(name, type: type, raw: raw, style: style, isTransparent: isTransparent)
    }
    
    static func printObject(_ name: String, type: ThemeType, raw: String, style: Style, isTransparent: Bool) {
        if debug {
            let console = """
            ThemeManager.printObject:
                     name = \(name)
                     type = \(type.toString)
                      raw = \(raw)
                    style = \(style.name)
            isTransparent = \(isTransparent)
            """
            print(console)
        }
    }
    
    static func boolToString(_ value: Bool) -> String {
        if value { return "true" }
        else { return "false" }
    }
    static func stringToBool(_ value: String) -> Bool {
        if value.contains("true") { return true }
        else { return false }
    }
    
    
}
