//
//  ObserverDidChange.swift
//  Ultra
//
//  Created by Justin Bush on 2020-08-27.
//

import Foundation

var initTitleChange = true
extension ViewController {
    
    // MARK: Observers
    /// Fired when the raw URL webView value changes
    func urlDidChange(_ urlString: String) {
        let url = Clean.url(urlString)
        Debug.log("URL: \(url)")        // Debug: Print URL to Load
        
        runLoginCheck()
        
        /*
        if !User.isSignedIn {
            runLoginStatusCheck()
        } else {
            runDisabledPlayerCheck()
        }
        */
    }
    
    /// Fired when the progress of a page load changes
    func progressDidChange(_ progress: Double) {
        print("Progress: \(progress)")
        progressValue = (progress*100)/10
    }
    
    func titleDidChange(_ titleString: String) {
        print("Title: \(titleString)")
        
        if initTitleChange {
            runDisabledPlayerCheck()
            initTitleChange = false
        }
        
        /*
        let title = Clean.url(titleString)
        Debug.log("Title: \(title)")
        
        if title == "\"Apple Music\"" {
            print("Here")
        }
        */
        
    }
}


extension DefaultStringInterpolation {
    mutating func appendInterpolation<T>(optional: T?) {
        appendInterpolation(String(describing: optional))
    }
}

