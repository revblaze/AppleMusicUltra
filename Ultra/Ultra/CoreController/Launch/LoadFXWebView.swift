//
//  LoadFXWebView.swift
//  Ultra
//
//  Created by Justin Bush on 2020-08-27.
//

import Foundation

// MARK: FXWebView Setup
// Initialize FX(Web)View

extension ViewController {
    
    // MARK: Setup FXWebView
    
    func initFXWebView() {
        fxWebView.navigationDelegate = self
        fxWebView.uiDelegate = self
        fxWebView.allowsLinkPreview = false                       // Disable Link Previews
        fxWebView.allowsMagnification = false                     // Disable Magnification (CSS Handled)
        fxWebView.allowsBackForwardNavigationGestures = false     // Disable Back-Forward Navigation
        
        //fxWebView.loadFile("image", path: "WebContent/WebFX")
        loadFX()
    }
    
}
