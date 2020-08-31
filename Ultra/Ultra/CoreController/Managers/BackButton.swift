//
//  BackButton.swift
//  Ultra
//
//  Created by Justin Bush on 2020-08-28.
//

import Cocoa

var backButtonAlpha = CGFloat(0)
extension ViewController {
    
    /// Sends webView to previously loaded page if `webView.canGoBack`
    @IBAction func goBackPage(_ sender: Any) {
        if webView.canGoBack { webView.goBack() }
        else { webView.load(Music.url) }
    }
    
    /// Determines if back button should be displayed and handles fade-in/out animations
    func updateBackButtonDisplay(_ urlString: String) {
        backButtonAlpha = BackNavManager.getButtonAlpha(urlString)
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 1.0
            backButton.animator().alphaValue = backButtonAlpha
        }, completionHandler: { () -> Void in
            //self.backButton.isHidden = !BackNavManager.shouldShowButton(urlString)
        })
    }
    
}

struct BackNavManager {
    
    // Full URL Example: music.apple.com/ca/listen-now
    static let coreURL = "music.apple.com/"
    // URLs with no back button should have the exact URL suffix:
    static let noButtonPages = ["/listen-now",
                         "/browse",
                         "/radio",
                         "/library/recently-added",
                         "/library/artists",
                         "/library/albums",
                         "/library/songs",
                         "music.apple.com/"]
    
    /// Checks the current URL against the list of `noButtonPages` and returns a `Bool` as to whether the button should be shown or not
    static func shouldShowButton(_ urlString: String) -> Bool {
        for page in noButtonPages {
            if urlString.hasSuffix(page) {
                return false
            }
        }
        return true
    }
    
    /// Returns the `alphaValue` for the `backButton`, depending on whether it is to be shown or not
    static func getButtonAlpha(_ urlString: String) -> CGFloat {
        if shouldShowButton(urlString) { return 1.0 }
        else { return 0.0 }
    }
    
}
