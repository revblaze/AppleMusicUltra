//
//  TypeScript.swift
//  Ultra
//
//  Created by Justin Bush on 2021-02-10.
//

import Foundation

// Swift enums with associated default values
// https://ilya.puchka.me/swift-enums-with-associated-values-defaults/
//typealias Global = TypeScript
public enum TypeScript {
    
    //case index
    
    //case index(_ function: IndexReference)
    
    /*
    typealias index = Index
    public enum Index {
        case
    }
    */
    
}

struct IndexFunction {
    // myFunction()  type.void
    static func myFunction() -> String { return "" }
    static func myFunction(with: Bool) -> String { return "\(with)" }
}

public enum IndexReference {
    case myFunction
    
    var name: String {
        switch self {
        case .myFunction:   return "myFunction"
        }
    }
    
    //var function: IndexFunction { }
    
    public static let prefix = "("
    public static let suffix = ");"
}
