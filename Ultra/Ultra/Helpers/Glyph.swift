//
//  Glyph.swift
//  Ultra
//
//  Created by Justin Bush on 2020-08-27.
//

import Cocoa

struct Glyph {
    
    //static let gear = NSImage(named: "NSActionTemplate")
    static let gear = icon(.gear)
    static let close = icon(.close)
    
    
    static func icon(_ name: GlyphLibrary) -> NSImage {
        return name.system
        /*
        // When were Glyphs first introduced?
        if #available(OSX 10.14, *) {
            return name.custom
        } else {
            return name.system
        }
        */
    }
    
    
}



enum GlyphLibrary: CaseIterable {
    
    case close
    case gear
    
    var system: NSImage {
        switch self {
        case .close:    return NSImage(named: "NSStopProgressFreestandingTemplate")!
        case .gear:     return NSImage(named: "NSActionTemplate")!
        }
    }
    
    var custom: NSImage {
        switch self {
        case .close:    return NSImage(named: "Close")!
        case .gear:     return NSImage(named: "Gear")!
        }
    }
}

 

struct GlyphColor {
    
    //static let bw = UIColor.init(named: "BlackWhite")
 
}
