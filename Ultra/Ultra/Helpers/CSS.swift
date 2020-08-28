//
//  CSS.swift
//  Ultra
//
//  Created by Justin Bush on 2020-08-10.
//

import Foundation

struct CSS {
    /// Cleans and reformats Optional CSS String for use in WKWebView.
    static func toString(_ code: String) -> String {
        var css = code
        css = css.replacingOccurrences(of: "\n", with: "")
        css = css.replacingOccurrences(of: "\"", with: "'")
        css = css.replacingOccurrences(of: "Optional(", with: "")
        css = css.replacingOccurrences(of: "\")", with: "")
        return css
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
    static func toString(file: String, inDir: String) -> String {
        let path = Bundle.main.path(forResource: file, ofType: "css", inDirectory: inDir)
        var css: String? = nil
        do { css = try String(contentsOfFile: path ?? "", encoding: .ascii) }
        catch { print("Error: Unable to locate custom styles") }
        // Format CSS code properly
        css = css?.replacingOccurrences(of: "\n", with: "")
        css = css?.replacingOccurrences(of: "\"", with: "'")
        css = css?.replacingOccurrences(of: "Optional(", with: "")
        css = css?.replacingOccurrences(of: "\")", with: "")
        return css ?? ""
    }
}

