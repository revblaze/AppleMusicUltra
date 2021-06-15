//
//  BackButton.swift
//  Ultra
//
//  Created by Justin Bush on 2021-06-15.
//

import Cocoa
import WebKit

extension ViewController {
    
    func initBackButton() {
        backButton.alphaValue = 0
    }
    
    func showBackButton(_ show: Bool) {
        var alpha = CGFloat(0)
        if show { alpha = 1 }
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 0.5
            //webView.animator().alphaValue = 1
            backButton.animator().alphaValue = alpha
        }, completionHandler: { () -> Void in
            //self.launchLoader.stopAnimation(self)
        })
    }
    
    func updateBackButton() {
        var display = true
        if webView.canGoBack {
            for path in noBackPage {
                if url.hasSuffix(path) {
                    display = false
                }
            }
        }
        showBackButton(display)
        /*
        if webView.canGoBack { showBackButton(true) }
        else { showBackButton(false) }
        */
    }
    
}

let noBackPage = ["/listen-now", "/browse", "/radio", "/library/recently-added", "/library/artists", "/library/albums", "/library/songs", "/library/made-for-you"]
