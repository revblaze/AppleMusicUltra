//
//  AMService.swift
//  Ultra
//
//  Created by Justin Bush on 2021-06-10.
//

import Foundation

typealias AppleMusic = AMService
struct AMService {
    
    /// The base Apple Music URL: `https://music.apple.com`
    static let baseURL = "https://music.apple.com"
    
    /// Returns the URL for the selected Apple Music page as a `String`
    /// # Usage:
    ///     let url = AppleMusic.url(forPage: .browse)
    ///     webView.load(url) // "https://music.apple.com/browse"
    /// - Parameters:
    ///     - forPage: The desired Apple Music page to load in some WebView
    static func url(forPage page: Page) -> String {
        return "\(baseURL)/\(page.path)"
    }
    
    enum Page {
        case listenNow, browse, album, profile
        
        var path: String {
            switch self {
            case .listenNow:    return "listen-now"
            case .browse:       return "browse"
            case .album:        return "album"      // ambigious URL scheme
            case .profile:      return "profile"    // ambigious URL scheme
            }
        }
    }
    
    // MARK: Apple Music URL Scheme (Deprecated)
    // NOTE: Country code is no longer required. Simply load: [baseURL]/[page-name].
    // Scheme: https://music.apple.com/[cc]/[page-name]
    // [cc]: Country code (ie. ca, eu, us)
    // [page-name]: Apple Music page name (ie. browse, listen-now)
    // ie. https://music.apple.com/ca/listen-now

    static func urlBuilder(_ countryCode: String, page: Page) -> String {
        return "\(baseURL)/\(countryCode)/\(page.path)"
    }
    
    
    
}
