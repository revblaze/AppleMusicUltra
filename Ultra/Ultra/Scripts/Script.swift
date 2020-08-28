//
//  Script.swift
//  Ultra
//
//  Created by Justin Bush on 2020-08-10.
//

import Foundation

// MARK: JavaScript Core

struct Script {

    /// Takes CSS `code` as a String and returns JavaScript code for `innerHTML` injection
    static func toJS(_ code: String) -> String {
        let css = CSS.toString(code)
        let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
        return js
    }
    
    /// Grabs CSS from `file` (inside `WebCode`) and outputs the executable JS code
    static func toJS(file: String) -> String {
        let css = CSS.toString(file: file, inDir: "WebContent/WebCode")
        let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
        return js
    }
    /// Grabs CSS from `file`, within directory `path`, and outputs the executable JS code
    static func toJS(file: String, path: String) -> String {
        let css = CSS.toString(file: file, inDir: path)
        let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
        return js
    }
    
}
