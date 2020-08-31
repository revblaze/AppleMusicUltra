//
//  TitleDidChange.swift
//  Ultra
//
//  Created by Justin Bush on 2020-08-31.
//

import Foundation

// MARK: Title Did Change

var initTitleChange = true
extension ViewController {
    
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
