//
//  URLDidChange.swift
//  Ultra
//
//  Created by Justin Bush on 2021-06-10.
//

import Foundation

var url = ""

extension ViewController {
    
    func urlDidChange(_ urlString: String) {
        url = urlString.clean()
        if debug { print("URL: \(url)") }
        
        webView.ts(.didLoad())
        
        updateBackButton()
        
        
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



extension String {
    /// Cleans and reformats Optional URL string.
    /// `Optional("rawURL") -> rawURL`
    func clean() -> String {
        var url = self.replacingOccurrences(of: "Optional", with: "")
        let brackets: Set<Character> = ["(", ")"]
        url.removeAll(where: { brackets.contains($0) })
        return url
    }
    
}
