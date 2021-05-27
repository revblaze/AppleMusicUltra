//
//  JavaScript Extensions
//  JSExtensions.swift
//
//  SwiftyStarterKits
//  Swift 5.2 (Xcode 12.4)
//
//  Created by Justin Bush © 2021
//  https://github.com/revblaze/SwiftyStarterKits
//  

import Foundation
import WebKit

extension WKWebView {
    enum EvaluateJavaScriptError: String, Error {
        case typeMismatchError
    }
    /// (**DEFAULT**) `String` : Evaluates JavaScript code in some WKWebView object and waits for a callback.
    /// - parameters:
    ///     - script: JavaScript code to evaluate as a `String`
    ///     - completionHandler: Awaits a return value, `(String)`, from the function call
    /// # Usage
    ///     // Callbacks (String)
    ///     webView.evaluateCallback("func();") { (result) in
    ///         switch result {
    ///         case .failure(let error): print(error)
    ///         case .success(let value): print(value)
    ///         }
    ///     }
    /// # Callbacks (default)
    /// The default implementation, with an optional completion parameter (as seen in the Usage example above), will return the JavaScript `String` literal
    /// of the callback value.
    ///
    /// **Note:** Some functions, like those with a declared return value of a non-`String` type, may not return to the console.
    func evaluateCallback(_ javaScriptString: String, completionHandler: ((Result<String, Error>) -> Void)? = nil) {
        evaluateJavaScript(javaScriptString) { (result, error) in
            guard let result = result else {
                completionHandler?(.failure(error!))
                return
            }
            
            completionHandler?(.success(String(format: "%@", result as! NSObject)))
        }
    }
    /// Evaluates JavaScript code in some WKWebView object and waits for a callback.
    /// - parameters:
    ///     - script: The TypeScript code to run
    ///     - completionHandler: Awaits a return value from the function call
    /// # Usage
    ///     // Callbacks
    ///     webView.evaluateCallback("boolFunc();") { (result: Result<Bool, Error>) in
    ///         switch result {
    ///         case .failure(let error): print(error)
    ///         case .success(let value): print(value)
    ///         }
    ///     }
    func evaluateCallback<T>(_ javaScriptString: String, completionHandler: ((Result<T, Error>) -> Void)? = nil) {
        evaluateJavaScript(javaScriptString) { (result, error) in
            guard let result = result else {
                completionHandler?(.failure(error!))
                return
            }
            
            if let result = result as? T {
                completionHandler?(.success(result))
            } else {
                completionHandler?(.failure(EvaluateJavaScriptError.typeMismatchError))
            }
        }
    }
}

// Reference: https://gist.github.com/ahmedk92/f279a49fa2a8d7b3b887f433e42cb612
