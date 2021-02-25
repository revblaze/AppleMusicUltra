//
//  URL & HTTP Extensions
//  URLExtensions.swift
//  
//  SwiftyStarterKits
//  Swift 5.2 (Xcode 12.4)
//
//  Created by Justin Bush © 2021
//  https://github.com/revblaze/SwiftyStarterKits
//  

import Foundation

extension URL {
    /// Converts `URL` to Optional `String`
    func toString() -> String {
        return self.absoluteString
    }
    /// Returns `true` if `URL` is secure
    func isSecure() -> Bool {
        let string = self.toString()
        if string.contains("https://") { return true }
        else { return false }
    }
}

extension HTTPURLResponse {
    
    func filenameFromHeaders() -> String? {
        let contentDispositionHeaderKey = "Content-Disposition"
        
        // Get value of Content-Disposition header field
        if let contenstDispositionValue:String = self.allHeaderFields[contentDispositionHeaderKey] as? String {
            
            do {
                // Use regexp to get filename from Content-Disposition string
                let regex = try NSRegularExpression(pattern: "((?<=filename=(\"?))(.*)(?=\"?))")
                if let result = regex.firstMatch(in: contenstDispositionValue,
                                                 options: [],
                                                 range: NSRange.init(location: 0, length: contenstDispositionValue.count))
                {
                    let nsStringContentDisposition = contenstDispositionValue as NSString
                    let resultFileName = nsStringContentDisposition.substring(with: result.range )
                    // Remove quotation marks if any in result filename string
                    return resultFileName.replacingOccurrences(of: "\"", with: "")
                }
            } catch let error {
                print("Failed to get filename from headers with error: \(error.localizedDescription)")
                return nil
            }
        }
        return nil
    }
}
