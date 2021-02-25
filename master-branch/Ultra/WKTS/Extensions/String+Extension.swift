//
//  String+Extension.swift
//  Ultra
//
//  Created by Justin Bush on 2021-02-10.
//

import Foundation

extension String {
    /// Removes the `.js` extension from the file name (ie. `"index.js" -> "index"`).
    func removeExtension() -> String {
        return self.replacingOccurrences(of: ".js", with: "")
    }
}
