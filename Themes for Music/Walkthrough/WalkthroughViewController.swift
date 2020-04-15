//
//  WalkthroughViewController.swift
//  Themes for Music
//
//  Created by Justin Bush on 2020-04-14.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Cocoa

class WalkthroughViewController: NSViewController {

    @IBOutlet var imageView: NSImageView!
    @IBOutlet var imageViewBlur: NSImageView!
    @IBOutlet var nextPageButton: NSButton!
    @IBOutlet var backPageButton: NSButton!
    @IBOutlet var doneButton: NSButton!
    @IBOutlet var neverShowAgain: NSButton!
    
    @IBOutlet var titleConstraint: NSLayoutConstraint!
    @IBOutlet var nextButtonConstraint: NSLayoutConstraint!
    @IBOutlet var backButtonConstraint: NSLayoutConstraint!
    
    var currentPage = 1
    var pageBlurFlag = false
    var neverAgain = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.alphaValue = 0
        imageViewBlur.alphaValue = 0
        nextPageButton.alphaValue = 0
        backPageButton.alphaValue = 0
        
        imageView.image = NSImage(named: "Page1")
        imageViewBlur.image = NSImage(named: "Page2Blur")
        
        doneButton.alphaValue = 0
        neverShowAgain.alphaValue = 0
        
        titleConstraint.constant = 7.0
        nextButtonConstraint.constant = 6.0
        backButtonConstraint.constant = 6.0
    }
    
    // ViewDidAppear: Show Page 1 with Animation & Next Button Delay
    override func viewDidAppear() {
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 1.0
            imageView.animator().alphaValue = 1.0
            showNavButtons(backPage: false, nextPage: true)
        }, completionHandler: { () -> Void in
            if debug { print("User has been presented with Walkthrough") }
        })
    }
    
    func showNavButtons(backPage: Bool, nextPage: Bool) {
        var backPageAlpha: CGFloat = 0
        var nextPageAlpha: CGFloat = 0
        if backPage { backPageAlpha = 1.0 }
        if nextPage { nextPageAlpha = 1.0 }
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 0.3
            backPageButton.animator().alphaValue = backPageAlpha
            nextPageButton.animator().alphaValue = nextPageAlpha
        }, completionHandler: { () -> Void in
            
        })
    }
    
    func showPageAnimation(_ pageNumber: Int, preparePage: Bool) {
        if preparePage {
            hidePageForAnimation(pageNumber)
        } else {
            //imageView.alphaValue = 0
            NSAnimationContext.runAnimationGroup({ (context) -> Void in
                context.duration = 0.5
                imageView.animator().alphaValue = 1.0
                imageViewBlur.animator().alphaValue = 0
            }, completionHandler: { () -> Void in
                
            })
        }
    }
    
    func hidePageForAnimation(_ pageNumber: Int) {
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 0.2
            imageView.animator().alphaValue = 0
        }, completionHandler: { () -> Void in
            self.presentPage(pageNumber)
        })
    }
    
    func presentPage(_ pageNumber: Int) {
        let image = "Page\(pageNumber)"
        if pageNumber != 2 || pageBlurFlag {
        //if pageNumber != 2 {
            pageBlurFlag = false
            imageView.image = NSImage(named: image)
            showPageAnimation(pageNumber, preparePage: false)
        } else {
            pageBlurFlag = true
            imageView.image = NSImage(named: image)
            imageViewBlur.image = NSImage(named: "\(image)Blur")
            NSAnimationContext.runAnimationGroup({ (context) -> Void in
                context.duration = 0.5
                imageViewBlur.animator().alphaValue = 1.0
            }, completionHandler: { () -> Void in })
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                print("showPageAnimation after queue: \(pageNumber)")
                //self.presentPage(2)               // WORKS
                //self.showPageAnimation(2, preparePage: false)
                NSAnimationContext.runAnimationGroup({ (context) -> Void in
                    context.duration = 1.0
                    self.imageView.animator().alphaValue = 1.0
                    self.imageViewBlur.animator().alphaValue = 0
                }, completionHandler: { () -> Void in })
            })
        }
    }
    
    
    func showPage(_ pageNumber: Int) {
        printPageToConsole(pageNumber)
        
        showPageAnimation(pageNumber, preparePage: true)
        
        switch pageNumber {
        case 1:
            currentPage = 1
            moveTopElements(false)
            showNavButtons(backPage: false, nextPage: true)
            showDoneAndAsk(false)
        case 2:
            currentPage = 2
            moveTopElements(true)
            showNavButtons(backPage: true, nextPage: true)
            showDoneAndAsk(false)
        case 3:
            currentPage = 3
            moveTopElements(true)
            showNavButtons(backPage: true, nextPage: false)
            showDoneAndAsk(true)
        default:
            // Page 1
            break
            
        }
    }
    
    @IBAction func nextPage(_ sender: Any) {
        let newPage = currentPage + 1
        print("NEXT newPage: \(newPage)")
        if newPage <= 3 {
            currentPage += 1
            showPage(newPage)
        }
    }
    
    @IBAction func backPage(_ sender: Any) {
        let newPage = currentPage - 1
        print("BACK newPage: \(newPage)")
        if newPage >= 1 {
            currentPage -= 1
            showPage(newPage)
        }
    }
    
    func moveTopElements(_ down: Bool) {
        var titleConstant = CGFloat(7.0)        // Default
        var buttonConstant = CGFloat(6.0)       // Default
        if down {
            titleConstant = 12.0
            buttonConstant = 13.0
        }
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 0.25
            titleConstraint.animator().constant = titleConstant
            nextButtonConstraint.animator().constant = buttonConstant
            backButtonConstraint.animator().constant = buttonConstant
        }, completionHandler: { () -> Void in
        })
    }
    
    // PAGE 3
    func showDoneAndAsk(_ present: Bool) {
        var doneButtonAlpha: CGFloat = 0
        var checkboxAlpha: CGFloat = 0
        if present {
            doneButtonAlpha = 1.0
            checkboxAlpha = 1.0
        }
        
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 1.0
            doneButton.alphaValue = doneButtonAlpha
            neverShowAgain.alphaValue = checkboxAlpha
        }, completionHandler: { () -> Void in
        })
    }
    
    @IBAction func neverShowAgainCheckbox(_ sender: NSButton) {
        if sender.state == .on { neverAgain = true }
        else { neverAgain = false }
    }
    
    override func viewWillDisappear() {
        saveIntroDefaults()
    }
    
    func saveIntroDefaults() {
        Defaults.set(neverAgain, forKey: "NeverAgain")
        Defaults.synchronize()
    }
    
    @IBAction func goToMusic(_ sender: NSButton) {
        // Dismiss WalkthroughViewController
        App.keyWindow?.performClose(self)
    }
    
    
    func printPageToConsole(_ pageNumber: Int) {
        if debug {
            print("Walkthrough Page: \(pageNumber)")
        }
    }
        
        
    
}
