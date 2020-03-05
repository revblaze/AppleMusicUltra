/*
See LICENSE folder for this sample’s licensing information.

Abstract:
`ConfigPath` is a relative reference designating configuration items.
*/

import Foundation

// `ConfigGroup` describes the different groupings of information in the
// configuration: a group of general settings, a group of assets, and one
// group for each collection of commands.

enum ConfigGroup {
    
    case settings
    case assets
    case commands(Int)
    
}

// `ConfigPath` describes how to find each data item in the configuration,
// by means of a ConfigGroup and an index. In addition, a `ConfigPath`
// without an index describes a configuration group as a whole.

struct ConfigPath {
    
    let group: ConfigGroup
    let index: Int!
    
    // Initialize a ConfigPath describing a group.
    
    init(group: ConfigGroup) {
        self.group = group
        self.index = nil
    }
    
    // Initialize a ConfigPath describing an item in a group.
    
    init(group: ConfigGroup, index: Int) {
        self.group = group
        self.index = index
    }
    
    // Return the index of the command collection associated with
    // a group, if appropriate.
    
    var collectionIndex: Int {
        
        switch self.group {
        case .commands(let collectionIndex):
            return collectionIndex
        default:
            fatalError("ConfigPath only has value for .commands case")
        }
    }
    
}
