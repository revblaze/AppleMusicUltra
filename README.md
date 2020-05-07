![Apple Music Ultra](Media/Cover.jpg)

# Ultra for Music
A custom Apple Music client with themes, styls, personalized settings and more.

## [Download Latest Stable Build](https://github.com/revblaze/AppleMusicUltra/releases/download/v1.0-beta.1/Themes-v1.0b1.zip) <sup>(macOS 10.12 and higher)</sup>
`Themes-v1.0b1.zip (25MB) Public Beta 1` (April 17, 2020)

Drag & drop to `/Applications` if you want to keep it after trying. 🤗

Updating from an older version? Drag and drop to `/Applications` and click `Replace`.

<i>This app is currently under heavy development.</i>

### This Week's TODO <sup>May 10, 2020</sup>
 - [x] Release Public Beta 1
 - [x] NSMenu graphical component
 - [x] Save URL session for next launch
 - [x] Add PreferencesViewController
 - [x] New, cleaner logo desperately needed
 - [ ] Fix custom theme issue on next session
 - [ ] Fix unneccessary JS alerts (see <a href="https://github.com/revblaze/AppleMusicUltra/issues/6">issue #6</a> and <a href="https://stackoverflow.com/questions/61279117/force-silence-js-alerts-by-title-value-with-wkwebview">StackOverflow page</a>)
 - [ ] Fix custom theme issue on next session
 - [ ] Now Playing artwork as background
 - [ ] Load all playlists at launch
 - [ ] Load all songs in playlist when opened(?)
 - [ ] JS-based injectable observer for Now Playing
 - [ ] Swift communication with JS observer (`WKScriptMessageHandler`)
 - [ ] Spread out ViewController
 - [ ] Release Public Beta 2
 - [ ] Add <a href="https://github.com/Musish/Musish">Musish</a> support
 
Big simplicity redesign planned for post-exam season. A lot of this project is really in a POC state right now. I'm hoping, over the next few weeks (post-exam szn), this app will transition into a really slim and efficient POC – production ready. AMWP is improving every day and I plan to keep the app up-to-date.

# Customization
Allow users to personalize their Apple Music with customization.

**Note:** I recently merged the private beta code with the master branch. The new code (April 9, 2020) includes major structural changes, additional features, bug fixes and a UI overhaul. Due to this, the below documentation is not up-to-date and will need to be rewritten. It's currently exam season here, so I may not have time to do this for a little while. Thank you for your patience!

## Themes
![Apple Music Ultra](Media/Themes.gif)

Ultra for Apple Music is a personalized Music client with custom themes, settings and more using JavaScript injection through the beautiful object that is WKWebView.

**Basic Syntax:** `setTheme(Style, darkMode: Bool, media: Any, type: String)`

## Styles
![Apple Music Ultra](Media/Styles.gif)
Styles are the top-layer effects that appear over every theme type. Using `setTheme`, they can be set to overlap your object-based theme to add some vibrant effects; or alternatively, they can be set to blur your system background using the built-in function `setTransparentTheme()`.

**Tansparent:** `setTheme(NSVisualEffectView.Material, darkMode: Bool, media: nil, type: "transparent")`

**with Object:** `setTheme(NSVisualEffectView.Material, darkMode: Bool, media: Object, type: String)`

## Custom Themes
![Apple Music Ultra](Media/Custom.gif)
Setting a custom, user-selected image is as simple as prompting the user for the `URL` path of their `file://` and setting it as the `media` property.

```
let imageURL = selectImageFile()
setTheme(NSVisualEffectView.Material, darkMode: Bool, media: imageURL, type: "image")
```
```
func selectImageFile() -> URL {
    let dialog = NSOpenPanel()
    dialog.allowsMultipleSelection = false
    dialog.allowedFileTypes = ["png", "jpg", "jpeg"]
    
    if (dialog.runModal() == NSApplication.ModalResponse.OK) {
        if let result = dialog.url?.absoluteURL { return result }
    }
}
```

## Appearance
Each theme has a `darkMode: Bool` property that sets the Music Web Player<sup>BETA</sup> Light/Dark mode.
```
darkMode = true    // Force Dark Mode
darkMode = false   // Force Light Mode
```

Just wanted to give a shout out to the devs behind the Web Player for designing this beautiful web app. The design of the UI seems to conform to its containers' `AppleInterfaceStyle`. Meaning everything in the web app has a Light mode and Dark mode property and conforms to whatever the theme mode is set to.

Thus, this property's main function is to toggle the Light/Dark mode of the Music Web Player<sup>BETA</sup>

## Structure <sup>for now...</sup>
`let fx = NSVisualEffectView.Material`
```
struct Style {                                 //                          rawValue
    static let preset   = fx.appearanceBased   // Default Preset               0
    // Light Mode Styles                       LIGHT
    static let frosty   = fx.sheet             // Frosty       (Opaque)        11
    static let bright   = fx.mediumLight       // Bright       (Middle)        8
    static let energy   = fx.light             // Vibrant      (Transparent)   1
    // Dark Mode Styles                        DARK
    static let cloudy   = fx.ultraDark         // Cloudy       (Opaque)        9
    static let dark     = fx.toolTip           // Dark         (Middle)        17
    static let vibrant  = fx.dark              // Vibrant      (Transparent)   2
}
```

## WKWebView
Assignment due at midnight, brb.

# Branches

 - **alpha:** *(retired)* The original Ultra for Apple Music build
     - Prior to restructuring the Themes & Style code and adding the new Customizer from private repository
 - **beta:** *(retired)* The nightly builds for the current master that will replace the alpha build as master
 - **legacy:** Ultra for Apple Music with support for macOS 10.13 and below
 - **webkit/fx:** All effects (static and dynamic) done through a single WebKit manager


## Requirements
Requires macOS 10.14 or later.

<sub><i>Please note that the app is being built with Swift 5.</i></sub>
