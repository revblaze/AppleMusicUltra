//
//  ThemeHTML.swift
//  Ultra
//
//  Created by Justin Bush on 2020-08-27.
//

import Foundation

struct ThemeHTML {
    
    //let path = "/Contents/Resources/WebContent/WebFX"
    static let imgPath = "Contents/Resources/WebContent/WebFX/images"
    static let path = "Contents/Resources/WebContent/WebFX"
    
    static func get(_ raw: String, forType: ThemeType) -> String {
        
        switch forType {
        case .image:        return imageHTML(raw)
        case .video:        return videoHTML(raw)
        case .webContent:   return webContentHTML(raw)
        case .custom:       return customImageHTML(raw)
        }
        
    }
    
    static func imageHTML(_ file: String) -> String {
        let html = "<!DOCTYPE html><html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"><style>body, html { height: 100%; margin: 0; }.bg { background-image: url(\"\(imgPath)/\(file)\"); height: 100%; background-position: center; background-repeat: no-repeat; background-size: cover; } </style></head><body><div class=\"bg\"></div></body></html>"
        return html
    }
    
    static func videoHTML(_ urlString: String) -> String {
        let html = "<body style=\"margin: 0px; background-color: black;\"><video autoplay playsinline loop height=\"100%\"  src=\"\(urlString)\"> </video>"
        return html
    }
    
    static func webContentHTML(_ urlString: String) -> String {
        let html = "LOAD: \(urlString)"
        return html
    }
    
    /// Returns HTML of image to be loaded into FX WebView
    static func customImageHTML(_ urlString: String) -> String {
        let html = "<!DOCTYPE html><html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"><style>body, html { height: 100%; margin: 0; }.bg { background-image: url(\"\(urlString)\"); height: 100%; background-position: center; background-repeat: no-repeat; background-size: cover; } </style></head><body><div class=\"bg\"></div></body></html>"
        return html
    }
    /// Returns HTML of image to be loaded into FX WebView (user-selected file)
    static func customImageHTML(_ file: URL) -> String {
        let image = file.absoluteString
        let html = "<!DOCTYPE html><html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"><style>body, html { height: 100%; margin: 0; }.bg { background-image: url(\"\(image)\"); height: 100%; background-position: center; background-repeat: no-repeat; background-size: cover; } </style></head><body><div class=\"bg\"></div></body></html>"
        return html
    }
    
    static func customVideoHTML(_ urlString: String) -> String {
        let html = videoHTML(urlString)
        return html
    }
}
