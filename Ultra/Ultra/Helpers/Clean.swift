//
//  Clean.swift
//  Ultra
//
//  Created by Justin Bush on 2020-08-03.
//

import Foundation

struct Clean {
    
    /// Cleans and reformats Optional URL string.
    /// `Optional("rawURL") -> rawURL`
    static func url(_ urlString: String) -> String {
        var url = urlString.replacingOccurrences(of: "Optional", with: "")
        let brackets: Set<Character> = ["(", ")"]
        url.removeAll(where: { brackets.contains($0) })
        return url
    }
    
}

