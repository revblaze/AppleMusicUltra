//
//  JS+Auth.swift
//  Ultra
//
//  Created by Justin Bush on 2021-06-15.
//

import Foundation
import WebKit

extension ViewController {
    
    /// Set `countObjects` to `true` if `lastMessage.contains("not-authenticated") && newMessage.contains("[object Object]")`
    func willAttemptAuth() {
        if lastMessage.contains("not-authenticated") && newMessage.contains("[object Object]") {
            countObjects = true
            if debug { print("User is attempting to login") }
        }
    }
    
    /// Reload the client `webView` upon four auth network requests
    func reloadOnAuth() {
        if newMessage.contains("[object Object]") {
            objectCount += 1
            
            if objectCount >= 4 {
                countObjects = false
                if debug { print("User logged in, reloading client") }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.webView.reload()
                }
            }
        }
        //else { countObjects = false; objectCount = 0 }
    }
    
}
