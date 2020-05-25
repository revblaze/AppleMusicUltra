//
//  JSHelper.swift
//  UWeb
//
//  Created by Justin Bush on 2020-05-11.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Foundation

struct JSHelper {
    
    /// Cleans and reformats Optional CSS String for use in WKWebView.
    static func cssToString(_ css: String) -> String {
        var cssString = css
        cssString = cssString.replacingOccurrences(of: "\n", with: "")
        cssString = cssString.replacingOccurrences(of: "\"", with: "'")
        cssString = cssString.replacingOccurrences(of: "Optional(", with: "")
        cssString = cssString.replacingOccurrences(of: "\")", with: "")
        return cssString
    }
    /**
    Extracts Optional contents of a CSS file, cleans it and then reformats it as a String for use in WKWebView.
    
     - Parameters:
        - file: Name of the CSS file without the `.css` extension (ie. `style`)
        - inDir: The directory where the CSS file is located (ie. `WebCode`)
     - Returns: A non-Optional String of the CSS file
    
     # Usage
        let css = cssToString(file: "style", inDir: "WebCode")
     */
    static func cssToString(file: String, inDir: String) -> String {
        let path = Bundle.main.path(forResource: file, ofType: "css", inDirectory: inDir)
        var cssString: String? = nil
        do { cssString = try String(contentsOfFile: path ?? "", encoding: .ascii) }
        catch { print("Error: Unable to locate custom styles") }
        // Format CSS code properly
        cssString = cssString?.replacingOccurrences(of: "\n", with: "")
        cssString = cssString?.replacingOccurrences(of: "\"", with: "'")
        cssString = cssString?.replacingOccurrences(of: "Optional(", with: "")
        cssString = cssString?.replacingOccurrences(of: "\")", with: "")
        return cssString ?? ""
    }
    
}
