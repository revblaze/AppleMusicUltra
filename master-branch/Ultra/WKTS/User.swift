//
//  User.swift
//  Ultra
//
//  Created by Justin Bush on 2021-02-11.
//

import Foundation
import WebKit

// MARK: User.js
public enum User {
    
    // function multiFunction(text: string, verified: boolean)
    // func multiFunction(text: String, verified: Bool)
    //case multiFunction(_ parameter: () -> Void)
    
    case voidFunction
    case boolFunction(_ with: Bool)
    //case multiFunction(_ parameter: () -> Void)
    //case multiFunction(() -> Void)
    case multiFunction(MultiFunction)
    
    var js: String {
        switch self {
        case .voidFunction: return "voidFunction();"
        case .boolFunction(let with): return "boolFunction(\(with));"
        case .multiFunction(let input):
            
            return "multiFunction"
        }
    }
    
    public struct Builder {
        
    }
    
    /*
    public enum multiFunction {
        case name(String)
        case verified(Bool)
    }
    */
    
    // multiFunction();
    // multiFunction(name: string);
    // multiFunction(verified: boolean);
    // multiFunction(name: string, verified: boolean);
    public class MultiFunction {
        var name: String? = ""
        var verified: Bool? = false
        
        init(name: String) { self.name = name }
        init(verified: Bool) { self.verified = verified }
        init(name: String, verified: Bool) { self.name = name; self.verified = verified }
        
        static func js(_ params: User.MultiFunction) -> String {
            var script = "multiFunction("
            if let name = params.name { script.append("\(name), ") }
            if let verified = params.verified { script.append("\(verified)") }
            script.append(");")
            return script
        }
        
        static func js(_ params: String) -> String {
            
        }
        
        //func
    }
    
}

extension ViewController {
    func runUserJS() {
        //User.multiFunction(name: "hello", verified: false)
        getJS(.voidFunction)
        //getJS(.multiFunction(name: "Hello"))
        User.multiFunction(name: "hello", verified: false)
    }
    
    func getJS(_ js: User) {
        
    }
}

extension WKWebView {
    func js(_ function: User) {
        //function
    }
    
}
