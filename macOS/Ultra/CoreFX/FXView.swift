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
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
