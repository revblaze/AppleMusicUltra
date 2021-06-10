//
//  JSUtility.swift
//  https://github.com/TypeSwift
//
//  Created by Justin Bush on 2021-06-10.
//
//  Generated with TypeSwift v0.0.1
//  THIS FILE WAS AUTOMATICALLY GENERATED. DO NOT TOUCH.
//

import Foundation

typealias JSU = JSUtility
struct JSUtility {
    /// All functions pass through here, as a `String`, before being evaluated as JavaScript.
    static func function(_ name: String) -> String {
        return name + ";"
    }
    
    static func variable(_ name: String) -> String {
        return "\(name);" // .toString();"
    }
    
}
