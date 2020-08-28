//
//  Appearance.swift
//  Ultra
//
//  Created by Justin Bush on 2020-08-27.
//

import Cocoa

// MARK: Appearance Manager
// Light/Dark Appearance Mode Modifier

extension ViewController {
    /**
     Set Light or Dark mode and save selection to Defaults
        - Parameters:
        - mode: `true` (Dark Mode), `false` (Light Mode)
     
     */
    func setDarkMode(_ mode: Bool) {
        if #available(OSX 10.14, *) {
            var css = ""
            let app = NSApplication.shared
            if mode {
                app.appearance = NSAppearance(named: .darkAqua)     // Force Dark Mode UI
                css = "dark-logo"
            } else {
                app.appearance = NSAppearance(named: .aqua)         // Force Light Mode UI
                css = "light-logo"
            }
            let js = Script.toJS(file: css, path: "WebContent/WebCode/Custom")
            webView.evaluateJavaScript(js, completionHandler: nil)
        } else {
            setDarkModeLegacy(mode)                                 // Force Light/Dark Mode via CSS
        }
        
    }
    /**
    Legacy (macOS 10.13 and lower): Set Light or Dark mode and save selection to Defaults
       - Parameters:
       - mode: `true` (Dark Mode), `false` (Light Mode)
    
    */
    func setDarkModeLegacy(_ mode: Bool) {
        var css = ""
        if mode { css = "dark-mode" }       // Force Dark Mode CSS
        else { css = "light-mode" }         // Force Light Mode CSS
        let js = Script.toJS(file: css, path: "WebContent/WebCode/Legacy")
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
    /// Changes logo style (light/dark) on NSAppearance mode change - also briefly "flashes" the webView with animation
    /*
    func changeLogoStyle(_ style: Style) {
        var js: String
        if style.isDark { js = Script.toJS("dark") }
        else { js = Script.toJS("light") }
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
    */
}
