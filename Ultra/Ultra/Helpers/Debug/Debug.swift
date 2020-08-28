//
//  Debug.swift
//  Ultra
//
//  Created by Justin Bush on 2020-08-03.
//

import Foundation

struct Debug {
    
    /// Print `String` to console if `debug = true`
    static func log(_ text: String) {
        if debug { print(text) }
    }
    /// Print `Any` to console if `debug = true`
    static func log(_ object: Any) {
        if debug {
            if let text = object as? String {
                print(text)
            }
        }
    }
    
}

