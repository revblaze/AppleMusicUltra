//
//  FXLoader.swift
//  Ultra
//
//  Created by Justin Bush on 2020-08-27.
//

import Foundation

// MARK: FXLoader
let webContentPath = "WebContent/WebFX/fx"

extension ViewController {
    
    func loadFX() {
        fadeOnSelect()
        //setDarkMode(Theme.style.isDark)
        
        if Theme.isTransparent {
            fxWebView.isHidden = true
            blurView.blendingMode = .behindWindow
        } else {
            fxWebView.isHidden = false
            blurView.blendingMode = .withinWindow
        }
        
        let html = ThemeHTML.get(Theme.raw, forType: Theme.type)
        
        print("html: \(html)")
        
        let appContents = "Contents/Resources/"
        let fullPath = Bundle.main.bundleURL.absoluteString + appContents + webContentPath
        
        print(fullPath)
        //print("pathString = \(pathString)\nfullPath = \(fullPath)")
        
        switch Theme.type {
        case .image:        fxWebView.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
        case .video:        fxWebView.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
        case .webContent:   fxWebView.loadFile(Theme.name, path: webContentPath)    // getRawPath()
        case .custom:       fxWebView.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
        }
        
        print("\(Theme.raw), path: \(fullPath), webContent: \(webContentPath)")
        
        blurView.material = Theme.style.material
        
        if Theme.style != Style.preset {
            setDarkMode(Theme.style.isDark)
        }
    }
    
    func updateTheme() {
        loadFX()
    }
    
    
    func getRawPath() -> String {
        let file = Theme.raw.removePath()
        let path = Theme.raw.replacingOccurrences(of: file, with: "")
        return path ?? webContentPath
    }
    
}
