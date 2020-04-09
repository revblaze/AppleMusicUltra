//
//  Parser.swift
//  Themes for Music
//
//  Created by Justin Bush on 2020-03-30.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import AppKit
import Foundation

class Parser {
    
    //var main = ViewController()
    
    func getArtwork(_ type: Playing.Item, images: String) {
        let urlArray = images.extractURLs()
        let urlStrings = urlArray.map { $0.absoluteString }
        for text in urlStrings {
            if text.contains("1000") { artwork = text; break }
            else if text.contains("760") { artwork = text }
            else if text.contains("600") { artwork = text }
            else { artwork = text }
        }
        //main.setArtwork(artwork)
        
        Playing.plist.img = artwork
        print("Artwork URL: \(artwork)")
    }
    
}

