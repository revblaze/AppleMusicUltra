//
//  URLDidChange.swift
//  Ultra
//
//  Created by Justin Bush on 2020-08-27.
//

import Foundation

// MARK: URL Did Change

extension ViewController {
    
    /// Fired when the raw URL webView value changes
    func urlDidChange(_ urlString: String) {
        let url = Clean.url(urlString)
        Debug.log("URL: \(url)")        // Debug: Print URL to Load
        
        runLoginCheck()                 // Run Looping Login Check
        updateBackButtonDisplay(url)    // Toggle Back Button
        
        /*
        if !User.isSignedIn {
            runLoginStatusCheck()
        } else {
            runDisabledPlayerCheck()
        }
        */
    }
    
}
