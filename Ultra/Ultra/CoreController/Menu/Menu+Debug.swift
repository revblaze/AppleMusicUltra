//
//  Menu+Debug.swift
//  Ultra
//
//  Created by Justin Bush on 2020-08-27.
//

import Foundation

// MARK: Main Menu: Debug
// Menu option for custom debugging functions when debug = true

extension ViewController {
    
    @IBAction func injectAudioListener(_ sender: Any) {
        let js = "document.getElementsByTagName('audio')[0].addEventListener('playing', function() { alert('AUDIO NOW PLAYING'); });" + "document.getElementsByTagName('audio')[0].addEventListener('playing', function() { window.webkit.messageHandlers.audioListener.postMessage('Audio has started playing'); });"
        //print("injectAudioListener: \(runWithResult(js))")
        //run(js)
        webView.evaluateJavaScript(js)
    }
    
    @IBAction func checkLoginStatus(_ sender: Any) {
        
        webView.evaluateJavaScript(Script.loginStatus) { (result, error) in
            if let result = result as? String {
                print("Result: \(result)")
            }
            if let result = result as? Bool {
                print("Result: \(result)")
            } else {
                print("Error: \(String(describing: error))")
            }
        }
        
    }
    
    @IBAction func debugDisabledPlayer(_ sender: Any) {
        print(runWithResult(Script.isPlayerDisabled))
    }
    
}
