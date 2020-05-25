//
//  Helper.swift
//  Ultra
//
//  Created by Justin Bush on 2020-04-20.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Cocoa
import Foundation

struct Helper {
    
    /// Cleans and reformats Optional URL string.
    /// `Optional("rawURL") -> rawURL`
    static func cleanURL(_ urlString: String) -> String {
        var url = urlString.replacingOccurrences(of: "Optional", with: "")
        let brackets: Set<Character> = ["(", ")"]
        url.removeAll(where: { brackets.contains($0) })
        return url
    }
    static func cleanOptional(_ string: String) -> String {
        var clean = string.replacingOccurrences(of: "Optional", with: "")
        let brackets: Set<Character> = ["(", ")", "\""]
        clean.removeAll(where: { brackets.contains($0) })
        return clean
    }
    static func formatMetadata(_ string: String) -> [String] {
        let title = self.cleanOptional(string)
        let metaArray = title.split(separator: "-")
        // Song, Artist, Album
        var songMeta   = metaArray[0]
        var artistMeta = metaArray[1]
        var albumMeta  = metaArray[2]
        if metaArray.indices.contains(3) { albumMeta.append(contentsOf: metaArray[3]) }
        // Handle Song: "feat. X" -> "(feat. X)"
        songMeta.removeLast()
        songMeta.append(")")
        let song = songMeta.replacingOccurrences(of: "feat", with: "(feat")
        // Handle Artist (Spacing)
        artistMeta.removeFirst()
        artistMeta.removeLast()
        let artist = String(artistMeta)
        // Handle Album (regular, EPs and singles): "Get Free  Single" -> "Get Free - Single"
        albumMeta.removeFirst()
        let album = albumMeta.replacingOccurrences(of: "  ", with: " - ")
        print("Now Playing:\n    song: \(song)\n  artist: \(artist)\n   album: \(album)")
        return [song, artist, album]
    }
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
