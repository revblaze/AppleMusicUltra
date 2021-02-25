//
//  TS+Index.swift
//  Ultra
//
//  Created by Justin Bush on 2021-02-10.
//

import Foundation

/*
extension Global {
        
    /// TypeScript file: `index.ts`
    /// # Usage
    ///     wwebView.load(index.ts)
    public enum index {
        
        case some
        case action
        
    }
    
}
*/

extension TypeScript.index {
    
    public enum ts {
        
        case some
        case action
        
        var js: String {
            switch self {
            case .some: return "some();"
            case .action: return "action();"
            }
        }
        
    }
    
}
