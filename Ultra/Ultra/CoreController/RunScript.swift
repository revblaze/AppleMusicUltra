//
//  RunScript.swift
//  Ultra
//
//  Created by Justin Bush on 2020-08-10.
//

import Foundation

var jsReturn = ""                       // JS Console Response

// MARK: Run Script
// Run JavaScript in WKWebView and handle return values
let runDebug = debug     // Set to false to disable Result and Error console logs

extension ViewController {
    /// Run JavaScript code in WKWebView with completion handlers `result` and `error`
    /// - Parameters:
    ///     - script: JavaScript code to run (see `Script.swift`)
    ///
    /// **Enable Console Logs:** `debug = true`
    func run(_ script: String) {
        webView.evaluateJavaScript(script) { (result, error) in
            if let result = result as? String {
                if runDebug { print("Result: \(String(describing: result))") }
            }
            if error != nil {
                if runDebug { print("Error: \(String(describing: error))") }
            }
        }
    }
    /// Run JavaScript code in WKWebView with return completion handler `result` and `error`
    /// - Parameters:
    ///     - script: JavaScript code to run (see `Script.swift`)
    /// - Returns: `result` or  `error` as String
    ///
    /// **Enable Console Logs:** `debug = true`
    func runWithResult(_ script: String) -> String {
        webView.evaluateJavaScript(script) { (result, error) in
            if let result = result as? String {
                //if runDebug { print("Result: \(String(describing: result))") }
                jsReturn = result
            }
            if error != nil {
                if runDebug { print("Error: \(String(describing: error))") }
            }
        }
        return jsReturn
    }
    
}
