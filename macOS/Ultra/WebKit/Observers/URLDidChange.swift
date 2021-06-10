//
//  URLDidChange.swift
//  Ultra
//
//  Created by Justin Bush on 2021-06-10.
//

import Foundation

extension ViewController {
    
    func urlDidChange(_ urlString: String) {
        webView.ts(.didLoad())
//        let url = Clean.url(urlString)          // Clean: Optional URL
//        Debug.log("URL: \(url)")                // Debug: Print URL to load
//
//        Page.url = url                          // Update Page URL
//
//        let page = URLManager.get(url)          // Get Page from URL
//        //let theme = Preferences.theme
//
//        if debug { print("Page.title: \(page.title)\n  Page.url: \(Page.url)") }
//
//        if didStartNavigation || page == .builder {
//            pageDidLoad()
//        }
//
//        if page == .auth { setTheme(.login) }
//
//        toggleTitleBar(page.showTitleBar)

    }

}
