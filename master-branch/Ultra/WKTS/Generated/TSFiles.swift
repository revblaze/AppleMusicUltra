//
//  TSFiles.swift
//  Ultra
//
//  Created by Justin Bush on 2021-02-10.
//

import Foundation

extension TypeScript {
    
    // MARK:- Global Functions (global.ts)
    public enum global {
        case play
        case pause
        case loginStatus
        // MARK:- Built-in Functions
        /// TypeScript function
        /// # Usage
        ///     webView.ts(.async(await: 1000))
        case async(await: Double)
    }
    
    // MARK:- TypeScript Files
    /// TypeScript file: `index.ts`
    /// # Usage
    ///     webView.load(index.ts)
    public enum index { }
    
    public enum listenNow { }
    public enum browse { }
    
}
