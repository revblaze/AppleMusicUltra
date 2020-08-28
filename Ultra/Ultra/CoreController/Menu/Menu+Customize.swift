//
//  Menu+Customizee.swift
//  Ultra
//
//  Created by Justin Bush on 2020-08-27.
//

import Foundation

// MARK: Main Menu: Customize
// Customize with Themes & Styles

extension ViewController {
    
    // MARK:- Themes & Styles
    // STYLES
    @IBAction func stylePreset(_ sender: Any) { setStyle(Style.preset) }
    @IBAction func styleFrosty(_ sender: Any) { setStyle(Style.frosty) }
    @IBAction func styleBright(_ sender: Any) { setStyle(Style.bright) }
    @IBAction func styleEnergy(_ sender: Any) { setStyle(Style.energy) }
    @IBAction func styleCloudy(_ sender: Any) { setStyle(Style.cloudy) }
    @IBAction func styleShadow(_ sender: Any) { setStyle(Style.shadow) }
    @IBAction func styleVibing(_ sender: Any) { setStyle(Style.vibing) }
    // THEMES
    @IBAction func themeTransparent(_ sender: Any) { setTransparent() }
    @IBAction func themeWave(_ sender: Any) { setImage("wave") }
    @IBAction func themeSpring(_ sender: Any) { setImage("spring") }
    @IBAction func themeDunes(_ sender: Any) { setImage("dunes") }
    @IBAction func themeQuartz(_ sender: Any) { setImage("quartz") }
    @IBAction func themeSilk(_ sender: Any) { setImage("silk") }
    @IBAction func themeBubbles(_ sender: Any) { setImage("bubbles") }
    //EXTRA THEMES
    @IBAction func themeGoblin(_ sender: Any) { setImage("goblin") }
    @IBAction func themePurple(_ sender: Any) { setImage("purple") }
    // Custom User Theme
    @IBAction func themeCustom(_ sender: Any) { setCustomTheme() }
    
    
    // MARK: Visualizer
    @IBAction func dynamicGradient(_ sender: Any) { setWebContent("gradient") }
    
    @IBAction func dynamicKscope(_ sender: Any) { setVideo("kscope") }
    
    /*
     @IBAction func dynamicGradient(_ sender: Any) { setVideo("gradient") }
     @IBAction func dynamicKscope(_ sender: Any) { setVideo("kscope") }
     */
    
    
    
    
    // MARK: Functions
    
    func setImage(_ name: String) {
        let rawExtension = name + ".jpg"
        Theme.set(name, type: .image, raw: rawExtension, style: Theme.style, isTransparent: false)
        updateTheme()
    }
    
    func setStyle(_ style: Style) {
        Theme.style = style
        updateTheme()
    }
    
    func setTransparent() {
        Theme.isTransparent = true
        updateTheme()
    }
    
    func setCustomTheme() {
        
    }
    
    func setVideo(_ name: String) {
        let videoWithExt = name + ".mov"
        let videoURL = "https://visualizer.muza.io/videos/\(videoWithExt)"
        Theme.set(name, type: .video, raw: videoURL, style: Theme.style, isTransparent: false)
        updateTheme()
    }
    
    /*
    func setDynamic(_ name: String) {
        let html = ScriptManager.setVideo("https://visualizer.muza.io/videos/\(name).mov")
        fxView.loadHTMLString(html, baseURL: nil)
        Theme.isTransparent = false
    }
    */
    
    func setWebContent(_ name: String) {
        let rawURL = name + ".html"
        Theme.set(name, type: .webContent, raw: rawURL, style: Theme.style, isTransparent: false)
        updateTheme()
    }
    
    /*
    func setFX(_ name: String) {
        Theme.name = name
        Theme.isTransparent = false
        updateTheme()
        fxView.loadFile(name, path: "WebFX/fx")
    }
    
    func setFX(_ name: String, path: String = "WebFX/fx") {
        Theme.isTransparent = false
        
        fxView.loadFile(name, path: path)
        if path == "WebFX/fx/kscope" {
            let html = ScriptManager.setVideo("https://visualizer.muza.io/videos/kscope.mov")
            fxView.loadHTMLString(html, baseURL: nil)
            blurView.material = .dark
        } else {
            blurView.material = Theme.style.material
        }
    }
    */
    
}
