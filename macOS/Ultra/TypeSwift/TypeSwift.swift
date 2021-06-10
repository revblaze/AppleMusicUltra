//
//  TypeSwift.swift
//  https://github.com/TypeSwift
//
//  Created by Justin Bush on 2021-06-10.
//
//  Generated with TypeSwift v0.0.1
//  THIS FILE WAS AUTOMATICALLY GENERATED. DO NOT TOUCH.
//

import Foundation

/// **Core TypeSwift Controller:** All things TypeScript go thorugh this structure.
enum TypeSwift {
    
    // MARK: Functions
    case didLoad(Void = ())
    
    
    /// Raw JavaScript-generated code to `evaluate` in some WKWebView.
    var js: String {
        switch self {
        case .didLoad: return JSU.function("didLoad()")
        
            
            
        case .anchorDelay: return JSU.variable("anchorDelay")
        case .actionDelay: return JSU.variable("actionDelay")
        case .toggle: return JSU.function("toggle()")
        case .setLabel(let text): return JSU.function("setLabel(\"\(text)\")")
        case .hideObject(let hidden): return JSU.function("hideObject(\(hidden))")
        case .addNumbers(let a, let b): return JSU.function("addNumbers(\(a), \(b))")
        case .selectDevice(let device): return JSU.function("selectDevice(\(device.js))")
        }
    }
    
    // MARK: Variables
    case anchorDelay
    case actionDelay
    // MARK: Functions
    case toggle(Void = ())
    case setLabel(_ text: String)
    case hideObject(_ hidden: Bool = false)
    case addNumbers(_ a: Double, _ b: Double)
    case selectDevice(_ device: Device)
    
    // MARK:- enums
    enum Device: String {
        case phone = "iOS"
        case pad = "iPadOS"
        case mac = "macOS"
        
        var js: String {
            switch self {
            case .phone: return "Device.Phone"
            case .pad: return "Device.Pad"
            case .mac: return "Device.Mac"
            }
        }
    }
}

/*
struct TypeSwift {
    
    /// The type-safe Swift code equivalent of the parsed and generated TypeScript files. ie. `index.ts` → `index` (camelCase)
    enum File: String {
        /// `global.ts`
        case global = "global"
        /// `index.ts`
        case index = "index"
    }
    
    enum Body {
        /// `global.ts`
        case global(global)
        /// `index.ts`
        case index(index)
        
        /// The executable JavaScript code, transpiled from TypeScript, to be evaluated in some WKWebView object.
        var js: String {
            switch self {
            case .global(let io): return io.js
            case .index(let io): return io.js
            }
        }
    }
    
}
 */

