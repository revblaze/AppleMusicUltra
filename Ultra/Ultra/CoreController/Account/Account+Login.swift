//
//  Account+Login.swift
//  Ultra
//
//  Created by Justin Bush on 2020-08-25.
//

import Cocoa
import WebKit

// MARK: Account Login Status
var signInButtonExists = false

extension ViewController {
    
    /// **JS:** Runs user login check and updates `User.isSignedIn`, as well as Defaults
    func runLoginStatusCheck() {
        runLoginObserver()
        /*
        webView.evaluateJavaScript(Script.loginStatus) { (result, error) in
            if let result = result as? String {
                self.setLoginStatus(result)
            } else {
                Debug.log("Error: \(String(describing: error))")
            }
        }
        */
    }
    
    // IF false, login button is not present, user is logged in
    func runLoginCheck() {
        webView.evaluateJavaScript(Script.loginStatus) { (result, error) in
            if let result = result as? Bool {
                User.updateStatus(!result)
                if !result {
                    self.playerBG.isHidden = false
                } else {
                    self.playerBG.isHidden = true
                }
            }
        }
    }
    
    func userLoginConfirmed() -> Bool {
        webView.evaluateJavaScript(Script.loginStatus) { (result, error) in
            if let result = result as? Bool {
                print(!result)
                User.isSignedIn = result
            }
        }
        return User.isSignedIn
    }
    
    
    func runLoginObserver() {
        if !User.isSignedIn {
            Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { timer in
                if !User.isSignedIn {
                    if debug { print("Waiting for user to sign in to initialize Player.") }
                    if self.userLoginConfirmed() {
                        timer.invalidate()
                        //self.addActiveEventListeners()
                        //self.setLoginStatus("0")
                        self.setLoginStatus()
                    }
                }
            }
        }
    }
    
    
    func setLoginStatus() {
        print("Setting Login Status, user has signed in: \(User.isSignedIn)")
        //User.updateStatus()
    }
    
    /// Takes the console return value, determines if user is signed in and fires `User.updateStatus(result)`
    func setLoginStatus(_ console: String) {
        if console.contains("0") { User.updateStatus(true) }
        else if console.contains("1") { User.updateStatus(false) }
        else { Debug.log("Error (LoginManager): Input did not contain 0 or 1") }
    }
    
}
