//
//  TSUtility.swift
//  https://github.com/TypeSwift
//
//  Created by Justin Bush on 2021-06-10.
//
//  Generated with TypeSwift v0.0.1
//  THIS FILE WAS AUTOMATICALLY GENERATED. DO NOT TOUCH.
//

import Foundation

/// **JavaScript Utility Functions:** Helper functions to format the JavScript code before execution.
struct TSUtility {
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
    ///     let code = TSUtility.scriptString()
    ///     webView.js(code) // or
    ///     webView.evaluateTypeScript(code)
    func scriptString() -> String {
        return getScriptString(fromFile: "index", path: TSConfig.dir)
    }
    
    /// Returns the raw JavaScript generated-code, as a `String`, from the TypeScript `file`.
    /// - parameters:
    ///     - file: The name of the TypeScript file you wish to retrieve (file extension is optional)
    /// - returns: The contents of the JavaScript file as a `String`
    /// # Usage
    ///     let code = getScriptString(file: .index)
    ///     webView.js(code) // or
    ///     webView.evaluateTypeScript(code)
//    func getScriptString(file: TypeSwift.File) -> String {
//        return getScriptString(fromFile: file.rawValue, path: TSConfig.dir)
//        //return
//    }
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
