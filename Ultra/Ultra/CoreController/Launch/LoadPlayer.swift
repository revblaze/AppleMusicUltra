//
//  LoadPlayer.swift
//  Ultra
//
//  Created by Justin Bush on 2020-08-25.
//

import Cocoa

// MARK: Player Setup
// Initial Launch Events: Loaders, Timers, Fade-in Animations, etc.

extension ViewController {
    /// Called when the webView has been initialized: `initWebView()`. Starts the loading animations.
    func playerWillLoad() {
        webView.alphaValue = 0      // Set webView alpha to 0
        playerBG.isHidden = true    // Hide top player blur fix
        progressSpinner.startAnimation(self)    // Start spinner animation
        // Start Timer for remaining ProgressBar loads that aren't accounted for
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            self.progressValue += 2.0
            self.progressBar.doubleValue = self.progressValue
            // Invalidate timer and set ProgressBar to indeterminate on 100%
            if self.progressValue >= 100.0 {
                timer.invalidate()
                self.progressBar.isIndeterminate = true
            }
        }
    }
    /// Called when the webView is finished loading (`didFinish`), but still needs time to render (approx. 3s).
    /// It will stop/hide the loading animations and fade-in the webView after 3 seconds has passed.
    func playerDidLoad() {
        // Fade-in webView and fade-out loading indicators after 3s (avg. time recorded)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            self.fadeInPlayer()
        })
    }
    /// Fades-in webView and fades-out loading indicators with animation (used at launch)
    func fadeInPlayer() {
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 1.5
            webView.animator().alphaValue = 1
            progressSpinner.animator().alphaValue = 0
            progressBar.animator().alphaValue = 0
        }, completionHandler: { () -> Void in
            self.progressSpinner.isHidden = true
            self.progressSpinner.stopAnimation(self)
            self.progressBar.isHidden = true
            self.progressBar.stopAnimation(self)
            if User.isSignedIn { self.playerBG.isHidden = false }
        })
    }
    
}
