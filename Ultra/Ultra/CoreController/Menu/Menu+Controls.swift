//
//  Menu+Controls.swift
//  Ultra
//
//  Created by Justin Bush on 2020-08-27.
//

import Cocoa

// MARK: Main Menu: Controls
// Basic Player Controls using JavaScript injection

extension ViewController {
    
    // MARK: Basic Playback Controls
    @IBAction func ctrlPlay(_ sender: Any) { run(Script.playSong) }
    @IBAction func ctrlPause(_ sender: Any) { run(Script.pauseSong) }
    @IBAction func ctrlBackSong(_ sender: Any) { run(Script.backSong) }
    @IBAction func ctrlNextSong(_ sender: Any) { run(Script.nextSong) }
    
    // MARK: Shuffle Control
    @IBAction func ctrlShuffle(_ sender: NSMenuItem) {
        let js = Script.toggleShuffle + Script.shuffleOn
        webView.evaluateJavaScript(js) { (result, error) in
            if let result = result as? String {
                if result.contains("false") {
                    Debug.log("Shuffle: ON")
                    sender.state = .on
                } else if result.contains("true") {
                    Debug.log("Shuffle: OFF")
                    sender.state = .off
                } else {
                    sender.state = .off
                    Debug.log("Shuffle: ?\nPlayer is not active yet. Please play a song first.")
                }
            }
        }
    }
    
    // MARK: Repeat Control
    @IBAction func ctrlRepeat(_ sender: NSMenuItem) {
        let js = Script.toggleRepeat //+ Script.repeatStatus + Script.repeatOn
        webView.evaluateJavaScript(js)
    }
    
    @IBAction func ctrlUpNext(_ sender: NSMenuItem) {
        let js = Script.toggleUpNext
        webView.evaluateJavaScript(js)
    }
    
}
