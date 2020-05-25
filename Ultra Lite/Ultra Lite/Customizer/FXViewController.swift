//
//  FXViewController.swift
//  Ultra
//
//  Created by Justin Bush on 2020-04-20.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Cocoa
import AVKit
import AVFoundation
import WebKit

protocol FXPlayable: class {
    /*
    func loadFX()
    func loadFX(_ type: Theme.FX, name: String)
    */
    func initTheme()
}

class FXViewController: NSViewController {
    
    weak var delegate: FXPlayable?
    
    
    var observer: NSKeyValueObservation?
    var flagObserver: NSKeyValueObservation?
    var intObserver: NSKeyValueObservation?
    
    
    // MARK: Objects & Variables
    @IBOutlet weak var imageView: NSImageView!          // FX Image Background
    @IBOutlet weak var videoPlayer: AVPlayerView!       // FX Video Background
    @IBOutlet weak var webView: WKWebView!              // FX Dynamic Background
    
    let clear = Active.clear
    let type  = Active.type
    let name  = Active.name
    let path  = Active.path
    
    //let myflag = Flag.flag
    
    //let pathFallback = URL(string: "")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if debug { print("FXViewController didLoad") }
        initTheme()
        /*
        let trigger = FXTrigger()
        trigger.helper.name.observeNext { [weak self] value in
            print("New Theme Trigger"); self?.initTheme()
        }
        
        observer = myflag.observe(\.bool, changeHandler: { (value, change) in
            print("value: \(value), change: \(change)")
        })
        
        flagObserver = UserDefaults.standard.observe(\.flagFX, options: [.initial, .new], changeHandler: { (defaults, change) in
            self.initTheme(); print("FXFlag triggered")
        })
        intObserver = UserDefaults.standard.observe(\.flagFX, options: [.initial, .new], changeHandler: { (defaults, change) in
            self.initTheme(); print("FXFlag triggered")
        })
        */
    }

    
    func initTheme() {
        print("DO")
        transitionFX()
        switch type {
        case .transparent: loadTransparent()
        case .image: loadImage(name)
        case .video: loadVideo(name)
        case .dynamic: loadDynamic(name)
        case .custom: loadImage("wave") //loadCustom(path ?? pathFallback)
        }
    }
    
    /*
    func loadFX(_ type: Theme.FX) {
        
    }*/
    
    
    func loadTransparent() {
        
    }
    
    func loadImage(_ name: String) {
        print("loadImage: \(name)")
        imageView.image = NSImage(named: name)
    }
    func loadImage(_ path: URL) {
        
    }
    
    func loadVideo(_ name: String) {
        //let videoURL = URL(string: "https://get.ezure.io/video/\(name)")
        let videoURL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        let player = AVPlayer(url: videoURL!)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        self.view.layer?.addSublayer(playerLayer)
        player.play()
    }
    
    func loadDynamic(_ name: String) {
        
    }
    
    func loadCustom(_ path: URL) {
        loadImage(path)
    }
    
    
    func loadDefault() {
        //loadImage(withName: "wave")
    }
    
    func transitionFX() {
        var hideImage = true
        var hideVideo = true
        var hideWeb = true
        switch type {
        case .transparent: print("Transparent FX")
        case .image: hideImage = false
        case .video: hideVideo = false
        case .dynamic: hideWeb = false
        case .custom: hideImage = false
        }
        
        if hideVideo { stopVideo() }
        imageView.isHidden = hideImage
        videoPlayer.isHidden = hideVideo
        webView.isHidden = hideWeb
    }
    
    func switchFX() {
        switch type {
        case .transparent: loadTransparent()
        case .image: loadImage(name)
        case .video: loadVideo(name)
        case .dynamic: loadDynamic(name)
        case .custom: loadImage("wave") //loadCustom(path ?? pathFallback)
        }
    }
    
    func stopVideo() {
        /*
        if videoPlayer.player?.timeControlStatus == AVPlayer.TimeControlStatus.playing {
            videoPlayer.player?.rate = 0.0
            //videoPlayer.player?.pause
        }
        */
    }
    
    
}


/*
extension AVPlayer {
    
    var isPlaying: Bool {
        return (self.player.rate != 0 && self.player.error == nil)
    }
    
}
*/
