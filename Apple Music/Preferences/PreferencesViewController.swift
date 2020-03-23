//
//  PreferencesViewController.swift
//  Apple Music
//
//  Created by Justin Bush on 2020-03-04.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Cocoa
import WebKit

class PreferencesViewController: NSViewController, WKUIDelegate, WKNavigationDelegate, NSWindowDelegate {
    
    @IBOutlet weak var outlineView: NSOutlineView!
    @IBOutlet var wallpaper: NSImageView!
    @IBOutlet var webView: WKWebView!
    @IBOutlet var blur: NSVisualEffectView!
    @IBOutlet var imageView: NSImageView!
    
    var groupImage = NSWorkspace.shared.icon(forFileType: NSFileTypeForHFSTypeCode(OSType(kGenericHardDiskIcon)))
    var folderImage = NSWorkspace.shared.icon(forFileType: NSFileTypeForHFSTypeCode(OSType(kGenericFolderIcon)))
    var nodeImage = NSWorkspace.shared.icon(forFileType: NSFileTypeForHFSTypeCode(OSType(kGenericDocumentIcon)))
    
    //var 
    
    var data: [Item] = TestData().items
    
    var themeMat: NSVisualEffectView.Material = .sheet
    var themeType = "setTheme"
    var themeMedia = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        outlineView.dataSource = self
        outlineView.delegate = self
        
        wallpaper.imageScaling = .scaleAxesIndependently
        wallpaper.image = NSImage(named: "wave")
        
        groupImage.size = NSSize(width: 16, height: 16)
        folderImage.size = NSSize(width: 16, height: 16)
        nodeImage.size = NSSize(width: 16, height: 16)
        
        outlineView.expandItem(nil, expandChildren: true)
        
        // WebView Configuration
        webView.setValue(false, forKey: "drawsBackground")
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsLinkPreview = false
        webView.allowsMagnification = false
        webView.allowsBackForwardNavigationGestures = false
        webView.customUserAgent = Music.userAgent
        webView.configuration.applicationNameForUserAgent = Music.userAgent
        
        blur.wantsLayer = true
        imageView.wantsLayer = true
        webView.wantsLayer = true
        self.view.wantsLayer = true
        self.view.canDrawSubviewsIntoLayer = true
        
        webView.layer?.cornerRadius = 20
        blur.layer?.cornerRadius = 20
        imageView.layer?.cornerRadius = 20
 
        // Load Apple Music Web Beta
        webView.load(Music.url)
    }
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        //updateStatus()
        if let selectedItem = outlineView.item(atRow: outlineView.selectedRow) as? Item { //as? SourceListItem{
            //print("url ITEM: \(selectedItem.name)")}
            menuManager(theme: selectedItem.name) }
    }
    
    func getSelectedCell() -> NSTableCellView? {
        if let view = self.outlineView.rowView(atRow: self.outlineView.selectedRow, makeIfNecessary: false) {
            return view.view(atColumn: self.outlineView.selectedColumn) as? NSTableCellView
        }
        return nil
    }
    
   func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Add default CSS stylesheet
        let path = Bundle.main.path(forResource: "style", ofType: "css", inDirectory: "Resources")
        var cssString: String? = nil
        do {
            cssString = try String(contentsOfFile: path ?? "", encoding: .ascii)
        } catch {
        }
        cssString = cssString?.replacingOccurrences(of: "\n", with: "")
        cssString = cssString?.replacingOccurrences(of: "\"", with: "'")
        cssString = cssString?.replacingOccurrences(of: "Optional(", with: "")
        cssString = cssString?.replacingOccurrences(of: "\")", with: "")
        
        let css = cssString!
        let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
    
    func menuManager(theme: String) {
        switch theme {
        case "Light":
            setTheme(theme: .mediumLight)
        case "Vibrant Light":
            setTheme(theme: .light)
        case "Dark":
            setTheme(theme: .ultraDark)
        case "Vibrant Dark":
            setTheme(theme: .dark)
        case "Vibrant":
            setTheme(theme: .toolTip)
        case "Frosty":
            setTheme(theme: .appearanceBased)
        case "Default":
            setTheme(theme: .sheet)
        case "Wave":
            setTheme(theme: .toolTip, withMedia: "wave")
        case "Spring":
            setTheme(theme: .toolTip, withMedia: "spring")
        case "Bubbles":
            setTheme(theme: .toolTip, withMedia: "bubbles")
        case "Dunes":
            setTheme(theme: .toolTip, withMedia: "dunes")
        case "Quartz":
            setTheme(theme: .toolTip, withMedia: "quartz")
        default:
            setTheme(theme: .toolTip)
        }
    }
    
    /// Sets the active theme
    func setTheme(theme: NSVisualEffectView.Material) {
        blur.material = theme
        blur.blendingMode = .behindWindow
        //imageView.isHidden = true
        colorModeCheck(style: theme)
        imageView.alphaValue = 0
        themeMat = theme
        themeType = "setTheme"
        
    }
    
    func setTheme(theme: NSVisualEffectView.Material, withMedia: String) {
        blur.material = theme
        blur.blendingMode = .withinWindow
        //imageView.isHidden = false
        imageView.alphaValue = 1
        let image = NSImage(named: withMedia)
        imageView.image = image
        themeMat = theme
        themeType = "setThemeWithMedia"
    }
    
    /// Forces System Appearance to Light Mode
    func forceLightMode() {
        App.appearance = NSAppearance(named: .aqua)
    }
    /// Forces System Appearance to Dark Mode
    func forceDarkMode() {
        App.appearance = NSAppearance(named: .darkAqua)
    }
    
    /// Check and compare style to user's System appearance -> alert user if clash
    func colorModeCheck(style: NSVisualEffectView.Material) {
        let light = [1, 8]
        if light.contains(style.rawValue) {
            forceLightMode()
        } else {
            forceDarkMode()
        }
    }
    
    @IBAction func applyTheme(_ sender: Any) {
        /*
        switch themeType {
        case "setTheme":
            ViewController().setTheme(theme: themeMat)
        case "setThemeWithMedia":
            ViewController().setTheme(theme: themeMat, withMedia: themeMedia)
        default:
            ViewController().setTheme(theme: themeMat, withMedia: themeMedia)
        }*/
    }
}


extension PreferencesViewController: NSOutlineViewDelegate {
    
    func outlineView(_ outlineView: NSOutlineView, shouldExpandItem item: Any) -> Bool {
        return true
    }

    func outlineView(_ outlineView: NSOutlineView, shouldCollapseItem item: Any) -> Bool {
        return true
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {

        guard let item = item as? Item else {
            return nil
        }
        
        let cell = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("DataCell"), owner: self) as! NSTableCellView
        cell.textField!.stringValue = item.name
        
        if let column = tableColumn {
            if column.identifier.rawValue == "outlineColumn" {
                cell.imageView!.image = item.type == .Container ? folderImage : nodeImage
                return cell
            }
        } else { // if GroupItem -> tableColumn is nil by design
            cell.imageView!.image = groupImage
            return cell
        }
        
        return nil

    }
    
    func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
        if let item = item as? Item, item.type == .Group {
            return true
        }
        return false
    }
}


extension PreferencesViewController: NSOutlineViewDataSource {

    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {

        if item == nil { // root
            return data.count
        }

        if let item = item as? Item {
            return item.numberOfChildren
        }

        return 0 // anything else
    }

    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if item == nil { // root
            return data[index]
        }

        if let item = item as? Item, item.type != .Node {
            return item.children[index]
        }

        return "UNKNOWN" // if this returns, check your code!
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        let item = item as! Item
        return item.isExpandable
    }

    func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
        if let column = tableColumn, column.identifier.rawValue == "outlineColumn", let item = item as? Item {
            return item.name
        }
        return nil
    }
}



