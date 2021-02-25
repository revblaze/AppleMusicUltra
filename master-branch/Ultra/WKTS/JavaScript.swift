//
//  JavaScript.swift
//  Ultra
//
//  Created by Justin Bush on 2021-02-11.
//

import Foundation
import WebKit

// Swift enums with associated default values
// https://ilya.puchka.me/swift-enums-with-associated-values-defaults/
public enum JavaScript {
    
    case voidFunction
    case boolFunction(_ with: Bool)
    //case multiFunction(_ multiple: Any)
    
    // function multiFunction(text: string, verified: boolean)
    // func multiFunction(text: String, verified: Bool)
    case multiFunction(_ parameter: () -> Void)
    
    public enum multiFunctionParams {
        case text(String)
        case verified(Bool)
    }
    
    var code: String {
        switch self {
        case .voidFunction: return "voidFunction();"
        case .boolFunction(let with): return "boolFunction(\(with));"
        //case .multiFunction(let multiple): return Builder.multiFunction(make)
        case .multiFunction(let parameter): return "multiFunction(\(parameter));"
        }
    }
    
    public enum Builder {
        //public static func multiFunction() -> JavaScript { return JavaScript.multiFunction(make) }
        //public static func
    }
    
    public static var make: JavaScript.Builder.Type {
        return JavaScript.Builder.self
    }
    
}

public enum Index {
    //case voidFunction
    //case boolFunction(_ with: Bool)
    //case multiFunction
    //case multiFunction(_ with: Bool)
    
    static func voidFunction() -> String { return "voidFunction();" }
    static func boolFunction(_ with: Bool) -> String { return "boolFunction(\(with));" }
    
    static func multiFunction() -> String { return "multiFunction();" }
    static func multiFunction(_ with: Bool) -> String { return "multiFunction(\(with));" }

    public enum js {
        static func voidFunction() -> String { return "voidFunction();" }
        static func boolFunction(_ with: Bool) -> String { return "boolFunction(\(with));" }
        static func multiFunction() -> String { return "multiFunction();" }
        static func multiFunction(_ with: Bool) -> String { return "multiFunction(\(with));" }
    }
    
//    public enum Builder {
//        public static func voidFunction() -> Index { return Index.voidFunction() }
//        public static func boolFunction(_ with: Bool) -> Index { return Index.boolFunction(with) }
//    }
//
//
//    public static var make: Function.Builder.Type {
//        return Function.Builder.self
//    }
    
}


extension ViewController {
    func runJS() {
        //webView.js(index: .myFunction)
        //Index.voidFunction                  // .voidFunction
        //Index.boolFunction(true)            // .boolFunction
        //Index.multiFunction.                // .multiFunction
        //Index.multiFunction(true)
        //Index.
        //webView.js(index: Index.voidFunction())
    }
}

extension WKWebView {
    func js(_ function: JavaScript) {
        //function.
    }
    
    func js(index: Index.js) {
        //index.
    }
}
