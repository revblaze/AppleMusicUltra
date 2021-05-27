//
//  Client.swift
//  Ultra
//
//  Created by Justin Bush on 2021-02-25.
//

import Foundation

struct Client {
    
    // MARK: Client Config
    static let url = "https://music.apple.com"
    static let name = "Ultra"
    static let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    static let userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0.3 Safari/605.1.15"
}
