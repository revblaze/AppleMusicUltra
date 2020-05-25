//
//  WKHelper.swift
//  Themes for Music
//
//  Created by Justin Bush on 2020-04-18.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Cocoa
import Foundation

struct WKHelper {
    static var jsRedirectRequired = false
    static var jsRedirectType = "recently-added"
    // "countryCode/restorableURLs"
    static let restorableURLs = ["browse", "for-you", "radio"] // "search-history"
    // "library/restorableLibraryURLs[n]"
    static let restorableLibraryURLs = ["recently-added", "artists", "albums", "songs"]
    // "Kanye West" -> https://music.apple.com/us/search?searchIn=am&term=kanye%20west
    static let restorableSearch = "search?"
    
    static func getRestorableURL(_ url: String) -> String {
        if url.contains(restorableSearch) {
            jsRedirectRequired = false
            return url
        }
        
        for value in restorableURLs {
            if url.contains(value) {
                jsRedirectRequired = false
                return "\(Ultra.url)/\(User.countryCode ?? "us")/\(value)"
            }
        }
        
        for value in restorableLibraryURLs {
            if url.contains("library/\(value)") {
                jsRedirectRequired = true
                jsRedirectType = value
                return "\(Ultra.url)/library/\(value)"
            }
        }
        
        if url.contains("/library/playlist/") {
            jsRedirectRequired = true
            jsRedirectType = "playlist"
            let plistBaseURL = "https://music.apple.com/library/playlist/"
            let plistID = url.replacingOccurrences(of: plistBaseURL, with: "")
            return plistID
        }
        
        return Ultra.url
    }
}

