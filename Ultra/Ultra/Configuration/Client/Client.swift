//
//  Client.swift
//  Ultra
//
//  Created by Justin Bush on 2020-08-05.
//

import Foundation

struct Client {
    
    static let name = "Ultra"
    static let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    static let userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.1.2 Safari/605.1.15"
    
}
