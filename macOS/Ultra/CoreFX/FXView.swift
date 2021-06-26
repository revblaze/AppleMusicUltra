//
//  FXView.swift
//  Ultra
//
//  Created by Justin Bush on 2021-06-10.
//

import Cocoa

class FXView: NSView {

    @IBOutlet weak var blurView: NSVisualEffectView!
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var backgroundView: NSImageView!
    
    func setImage(_ image: NSImage) {
        imageView.image = image
        blurView.blendingMode = .withinWindow
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}



enum LegacyStyles {
    case preset     // Preset       (Default)                   0           .appearanceBased
    case frosty     // Frosty       (Light Opaque)              11          .sheet
    case bright     // Bright       (Light Middle)              8           .mediumLight
    case energy     // Energy       (Light Transparent)         1           .light
    case cloudy     // Cloudy       (Dark Opaque)               9           .ultraDark
    case shadow     // Shadow       (Dark Middle)               17          .toolTip
    case vibing     // Vibing       (Dark Transparent)          2           .dark
}
