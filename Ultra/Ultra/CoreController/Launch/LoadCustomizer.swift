//
//  LoadCustomizer.swift
//  Ultra
//
//  Created by Justin Bush on 2020-08-25.
//

import Cocoa

// MARK: Customizer Setup
// Initialize Customizer Side-Panel Menu

extension ViewController {
    
    // MARK: Customizer Setup
    
    func initCustomizer() {
        CustomizerPanel.initLaunch()
        customizerView.isHidden = true
        customizerConstraint.constant = CustomizerPanel.newConstraint
        
    }
    
    @IBAction func toggleCustomizerAction(_ sender: Any) { toggleCustomizer() }
    func toggleCustomizer() {
        let state = customizerView.isHidden
        CustomizerPanel.willAppear(state)
        customizerButton.image = CustomizerPanel.toggleIcon
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 0.2
            customizerConstraint.animator().constant = CustomizerPanel.newConstraint
            webView.animator().alphaValue = CustomizerPanel.webAlpha
        }, completionHandler: { () -> Void in
            self.customizerView.isHidden = !state
        })
    }
    
    
    // MARK:- Animations
    
    /// Fades in-and-out Music Player WebView when switching Style modes (`new Style.isDark != Active.style.isDark`)
    func fadeOnSelect() {
        //var alphaSwitch = CGFloat(1.0)
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 0.1 //length of the animation time in seconds
            fxWebView.animator().alphaValue = 0.1
        }, completionHandler: { () -> Void in
            self.fxWebView.animator().alphaValue = 1.0
        })
    }
    
}


struct CustomizerPanel {
    
    static var webAlpha = CGFloat(0.7)          // WebView Alpha Value on Fade
    static var newConstraint = CGFloat(280)     // Customizer Constraint
    static var toggleIcon = Glyph.gear          // Customizer Toggle Button Icon
    
    /// Updates CustomizerView properties for animation
    static func willAppear(_ show: Bool) {
        if show {
            webAlpha = 0.7
            newConstraint = 280
            toggleIcon = Glyph.close
        } else {
            webAlpha = 1
            newConstraint = 0
            toggleIcon = Glyph.gear
        }
    }
    /// Updates CustomizerView properties to hidden defaults for launch
    static func initLaunch() {
        webAlpha = 1
        newConstraint = 0
        toggleIcon = Glyph.gear
    }
    
}
