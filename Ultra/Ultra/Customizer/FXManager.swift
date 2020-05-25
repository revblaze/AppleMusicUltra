//
//  FXManager.swift
//  Ultra
//
//  Created by Justin Bush on 2020-05-25.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Cocoa

struct FXManager {
    
    let path = "/Contents/Resources/WebFX"
    
    /// Returns HTML of image to be loaded into FX WebView
    static func setImage(_ image: String) -> String {
        let html = "<!DOCTYPE html><html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"><style>body, html { height: 100%; margin: 0; }.bg { background-image: url(\"Contents/Resources/WebFX/images/\(image).jpg\"); height: 100%; background-position: center; background-repeat: no-repeat; background-size: cover; } </style></head><body><div class=\"bg\"></div></body></html>"
        return html
    }
    
    /// Returns HTML of image to be loaded into FX WebView
    static func setCustomImage(_ file: String) -> String {
        let html = "<!DOCTYPE html><html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"><style>body, html { height: 100%; margin: 0; }.bg { background-image: url(\"\(file)\"); height: 100%; background-position: center; background-repeat: no-repeat; background-size: cover; } </style></head><body><div class=\"bg\"></div></body></html>"
        return html
    }
    
    /// Returns HTML of image to be loaded into FX WebView
    static func setCustomImage(_ file: URL) -> String {
        let image = file.absoluteString
        let html = "<!DOCTYPE html><html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"><style>body, html { height: 100%; margin: 0; }.bg { background-image: url(\"\(image)\"); height: 100%; background-position: center; background-repeat: no-repeat; background-size: cover; } </style></head><body><div class=\"bg\"></div></body></html>"
        return html
    }
    
}
