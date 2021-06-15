//
//  WK+JavaScript.swift
//  https://github.com/TypeSwift
//
//  Created by Justin Bush on 2021-06-10.
//
//  Generated with TypeSwift v0.0.1
//  THIS FILE WAS AUTOMATICALLY GENERATED. DO NOT TOUCH.
//

import Foundation
import WebKit

extension WKWebView {
    
    // MARK:- Load File
    /// Load the generated JavaScript code, of the input TypeScript file, to be evaluated in some WKWebView object.
    /// - parameters:
    ///     - file: The Swift-generated name of the specified TypeScript file
    /// # Usage
    ///     webView.load(.index)
    func loadTS() {
        evaluateJavaScript(scriptString())
    }
    
    func ts(_ function: TypeSwift) {
        evaluateJavaScript(function.js)
    }
    
    func loadCSS() {
        evaluateJavaScript(styleString())
    }
    
    
    
    
    
    // MARK:- Controller Functions
    
    /// Evalutes raw JavaScript code in a `WKWebView` object
    /// - parameters:
    ///     - script: The JavaScript code that you wish to execute
    /// # Usage
    ///     let code = "console.log(var);"
    ///     webView.js(code)
    func js(_ script: String) {
        evaluateJavaScript(script)
    }
    /*
    /// Evaluates the input TypeScript file as JavaScript code in some WKWebView object.
    func evaluateTypeScript(file: String) {
        evaluateJavaScript(getScriptString(file: file))
    }
    */
    
    
    static func toString(_ variable: String) -> String {
        return "\(variable);" // .toString();"
    }
    /// Removes the `.js` (or `.ts`) extension from the file name (ie. `"index.js" -> "index"`).
    static func removeExtension(_ file: String) -> String {
        let fileName = file.replacingOccurrences(of: ".js", with: "")
        return fileName.replacingOccurrences(of: ".ts", with: "")
    }
    /// Returns the raw JavaScript generated-code, as a `String`, from the core TypeScript file.
    /// - returns: The contents of the JavaScript file as a `String`
    /// # Usage
    ///     let code = webView.scriptString()
    ///     webView.js(code) // or
    ///     webView.evaluateTypeScript(code)
    func scriptString() -> String {
        return getScriptString(fromFile: "index", path: TSConfig.dir)
    }
    /// Returns the raw JavaScript generated-code, as a `String`, from the specified JavaScript `file`.
    /// - parameters:
    ///     - file: The name of the JavaScript file you wish to retrieve (file extension is optional)
    ///     - path: The path to the directory where the JavaScript file is located, relative to your project directory
    /// - returns: The contents of the JavaScript file as a `String`
    /// # Usage
    ///     let code = getScriptString(file: "index", path: "dist/")
    ///     webView.js(code) // or
    ///     webView.evaluateJavaScript(code)
    func getScriptString(fromFile: String, path: String) -> String {
        let fileName = TSUtility.removeExtension(fromFile)
        if let filePath = Bundle.main.path(forResource: "\(path)\(fileName)", ofType: "js") {
            do {
                print("Success: Found \(path)\(fileName).js")
                let contents = try String(contentsOfFile: filePath)
                return contents
            } catch {
                print("Error: contents could not be loaded")
            }
        } else {
            print("Error: \(fileName).js not found")
        }
        return "Error"
    }
    
    
    
    // MARK:- CSS
    
    func styleJS() -> String {
        return "var style = document.createElement('style'); style.innerHTML = '\(styleString())'; document.head.appendChild(style);"
    }
    
    func styleString() -> String {
        return getStyleString(fromFile: "style", path: TSConfig.dir)
    }
    
    func getStyleString(fromFile: String, path: String) -> String {
        let fileName = TSUtility.removeExtension(fromFile)
        if let filePath = Bundle.main.path(forResource: "\(path)\(fileName)", ofType: "css") {
            do {
                print("Success: Found \(path)\(fileName).css")
                let contents = try String(contentsOfFile: filePath)
                return contents
            } catch {
                print("Error: contents could not be loaded")
            }
        } else {
            print("Error: \(fileName).js not found")
        }
        return "Error"
    }
}
