//
//  Clean.swift
//  WiBlaze
//
//  Created by Justin Bush on 2020-04-28.
//  Copyright © 2020 Justin Bush. All rights reserved.
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

    static func title(_ string: String) {
        
    }
    
    static func string(_ string: String) -> String {
        var clean = string.replacingOccurrences(of: "Optional", with: "")
        let brackets: Set<Character> = ["(", ")", "\""]
        clean.removeAll(where: { brackets.contains($0) })
        return clean
    }
    
}
