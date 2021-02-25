//
//  WKWebView+Extension.swift
//  Ultra
//
//  Created by Justin Bush on 2021-02-10.
//

import Foundation
import WebKit

struct Utility {
    
    static func extractBool(_ code: Any) -> Bool {
        if let code = code as? Bool { return code }
        if let code = code as? String {
            if code.contains("true") { return true } else
            if code.contains("false") { return false }
        }
        if let code = code as? Int {
            if code == 0 { return false } else
            if code == 1 { return true }
        }
    }
    
}

extension WKWebView {
    
    func ts(_ function: TypeScript) {
        evaluateJavaScript(function.js)
    }
    
    // if webView.ts(.isSignedIn) { }
    func ts(_ function: TypeScript) -> Bool {
        evaluateJavaScript(function.js) { (result, error) in
            if result != nil {
                return Utility.extractBool(result)
            }
            if error != nil {
                if debug {
                    print("[WKTS] Error: \(String(describing: error))")
                    return false
                }
            }
        }
    }
    
    //func ts(index: TypeScript.index) { evaluateJavaScript(index) }
    
    
    //func ts(loadFile: TypeScript) { load(loadFile) }
    func load(_ file: TypeScript) {
        evaluateJavaScript(WKWebView.get(file: file.js, path: "dist/"))
    }
    
    //func ts(loadFile: TypeScript, path: String) { load(loadFile, path: path) }
    func load(_ file: TypeScript, path: String) {
        evaluateJavaScript(WKWebView.get(file: file.js, path: path))
    }
    
    /// Returns the generated JavaScript code for a specified JavaScript `file`.
    /// - parameters:
    ///     - file: The name of the JavaScript file you wish to retrieve (file extension is optional)
    ///     - path: The path to the directory where the JavaScript file is located
    /// - returns: The contents of the input JavaScript file as a String
    /// # Usage
    ///     let code = JS.get(file: "index")
    ///     webView.evaluateJavaScript(code)
    static func get(file: String, path: String) -> String {
        if let filePath = Bundle.main.path(forResource: "\(path)\(file.removeExtension())", ofType: "js") {
            do {
                let contents = try String(contentsOfFile: filePath)
                return contents
            } catch {
                print("Error: contents could not be loaded")
            }
        } else {
            print("Error: \(file.removeExtension()).js not found")
        }
        return "Error"
    }
    
    
    
}
