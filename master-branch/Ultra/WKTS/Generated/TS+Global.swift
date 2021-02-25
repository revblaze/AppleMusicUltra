//
//  TS+Global.swift
//  Ultra
//
//  Created by Justin Bush on 2021-02-10.
//

import Foundation

extension TypeScript.global {
    
    var js: String {
        switch self {
        case .play: return "play();"
        case .pause: return "pause();"
        case .loginStatus: return "loginStatus();"
        case .async(let await): return "await new Promise((r) => setTimeout(r, \(await)));"
        }
    }
    
    var key: String {
        switch self {
        case .play: return "playKey"
        case .pause: return "pauseKey"
        case .loginStatus: return "loginStatusKey"
        case .async(_): return ""
        }
    }
    
    public enum Builder {
        public static func loginStatus() -> TypeScript.global { return TypeScript.global.loginStatus }
    }
    
    public static var make: TypeScript.global.Builder.Type {
        return TypeScript.global.Builder.self
    }
}
