//
//  Item.swift
//  Apple Music
//
//  Created by Justin Bush on 2020-03-04.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Foundation

enum ItemType {
    case Group
    case Container
    case Node
}

class Item {

    var name: String
    var type: ItemType
    var children: [Item]

    var isExpandable: Bool {
        get {
            return type != .Node
        }
    }
    
    var numberOfChildren: Int {
        get {
            return self.type == .Node ? 0 : self.children.count
        }
    }

    init(_ name: String, _ type: ItemType, _ children: [Item]? = nil) {
        self.name = name
        self.type = type
        if let children = children {
            self.children = children
        } else {
            self.children = []
        }
    }
}

