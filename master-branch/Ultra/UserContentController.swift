//
//  UserContentController.swift
//  Ultra
//
//  Created by Justin Bush on 2021-02-10.
//

import Foundation
import WebKit

struct JSConsole {
    
    //static let loginStatus = UserDefaults.standard.setValue(<#T##value: Any?##Any?#>, forKey: <#T##String#>)
    
    
    
    static func set(_ value: TypeScript.global) {
        //UserDefaults.standard.setValue(value, forKey: value.key)
    }
    
    // "[WKTS] loginStatus = true"
    static func input(_ text: String) {
        if text.contains("[flag] loginStatus") {
            //Constants()
            //Variable.set(any)
        }
    }
    
}

extension ViewController {
    
    // MARK: JavaScript Handler
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // JavaScript event listeners
        if message.name == "eventListeners" {
            if let message = message.body as? String {
                if debug { print("> \(message)") }
                JSConsole.input(message)
            }
        }
    }
    
}
