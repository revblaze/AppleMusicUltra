//
//  ThemeType.swift
//  Ultra
//
//  Created by Justin Bush on 2020-08-27.
//

import Foundation

// MARK: Theme Type

enum ThemeType: CaseIterable {
    case image
    case video
    case webContent
    case custom
    
    static func get() -> ThemeType {
        let typeString = ThemeSettings.type
        switch typeString {
        case "image":       return .image
        case "video":       return .video
        case "webContent":  return .webContent
        case "custom":      return .custom
        default:            return .image
        }
    }
    
    static func get(_ typeString: String) -> ThemeType {
        switch typeString {
        case "image":       return .image
        case "video":       return .video
        case "webContent":  return .webContent
        case "custom":      return .custom
        default:            return .image
        }
    }
    
    var toString: String {
        switch self {
        case .image:        return "image"
        case .video:        return "video"
        case .webContent:   return "webContent"
        case .custom:       return "custom"
        }
    }
    
}

