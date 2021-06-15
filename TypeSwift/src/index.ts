/*
 * WebKit Event Listeners, Post Message:
 * Takes some message, as a `String`, and sends it to the Xcode console.
 * @param msg The message to be sent to the Xcode console
 * @returns A message, of type `String`, to be printed in the Xcode console, ie. "[WKTS] toggle() success"
 */
function postMessage(msg: string) {
  window.webkit.messageHandlers.eventListeners.postMessage(`[WKTS] ${msg}`)
}

/**
 * Global Variables
 */
let pageDidLoad = false
let isDarkMode = false
let isSignedIn = true

//    Loading: has-js is-desktop dark-mode ember-application no-touch no-song-loaded
// Signed out: has-js is-desktop dark-mode ember-application no-touch no-song-loaded not-authenticated not-subscribed storefront browse browse-index upsell-banner-visible upsell-banner-visible--bottom
//  Signed in: has-js is-desktop dark-mode ember-application no-touch no-song-loaded storefront browse browse-index
// Signin lib: has-js is-desktop dark-mode ember-application no-touch no-song-loaded library library-recently-added is-not-focused

// storefront: browse, listen-now, radio ||| album, artist
//    library: library-recently-added, library-recently-added, library-artists, library-made-for-you, library-playlist
//    account: account-settings

async function checkBody() {
  let body = <HTMLElement>document.querySelector("body")
  let classNames = body?.classList
  classNames.forEach(className => {
    //postMessage(className)
    if(className === "storefront" || className === "library") { pageDidLoad = true }
    if(className === "dark-mode") { isDarkMode = true }
    if(className === "light-mode") { isDarkMode = false }
    if(className === "not-authenticated") { isSignedIn = false }
    if(className === "account") { pageDidLoad = true }
    //if(className === "no-song-loaded") { isPlayingMusic = false }
  })
  //let classListString = classNames.toString()
  //if(classListString.in)
  postMessage(classNames.toString())

}
checkBody()

//let pageDidLoad = false
function checkPageLoad() {
  if(pageDidLoad === false) {
    checkBody()
     window.setTimeout(checkPageLoad, 100) /* this checks the flag every 100 milliseconds*/
  } else {
    postMessage(`pageDidLoad = ${pageDidLoad}`)
    postMessage(`isDarkMode = ${isDarkMode}`)
    postMessage(`isSignedIn = ${isSignedIn}`)
    didLoad()
  }
}
checkPageLoad()


// Page did load
function didLoad() {
  hideBanners()
  hideUIComponents()
  applyStyles()
  checkBody()
}
didLoad()

window.onload = function () {
  didLoad()
  //return "window.onload"
  postMessage("window.onload")
}

/*
async function checkLogin() {
  let signOutButton = <HTMLElement>document.querySelector("div.web-navigation__auth > button")
}
*/

/**
 * GLOBAL STYLES
 */
function applyStyles() {
  // Document Body
  let docBody = <HTMLElement>document.querySelector("body")
  docBody?.style.setProperty("background-color", "transparent", "important")
  // Search Box background
  let searchBoxInput = <HTMLElement>document.querySelector(".dt-search-box__input")
  searchBoxInput?.style.setProperty("background-color", "rgba(0,0,0,0.1")
  // About & Similar Artists bottom section
  let altSection = <HTMLElement>document.querySelector(".alt-section")
  altSection?.style.setProperty("background-color", "transparent", "important")
  // Artist Page
  let artistGroups = <HTMLElement>document.querySelector(".artist-groups")
  artistGroups?.style.setProperty("background-color", "transparent", "important")
}

// USER LOGIN CHECK
// Returns true if user is logged in, else false
function signedIn() {
  let loginButton = document.getElementsByClassName("web-navigation__auth-button")[0]
  if (loginButton?.innerHTML.includes("Sign In")) { return false }
  else { return true }
}

// DARK MODE CHECK
// Returns true if user is in dark mode, else light mode
function darkMode() {
  let docBody = <HTMLElement>document.querySelector("body")
  if (docBody.classList.contains("dark-mode")) { return true }
  else { return false }
}

/**
 * GLOBAL PROPERTIES
 */
// Hide AM Web Player UI components
function hideUIComponents() {
  let appleMusicLogo = <HTMLElement>document.querySelector(".web-navigation__header")
  appleMusicLogo?.style.setProperty("display", "none")
  let searchBoxMargin = "44px"
  if (signedIn()) { searchBoxMargin = "0px" }
  let searchBox = <HTMLElement>document.querySelector(".search-box")
  searchBox?.style.setProperty("margin-top", searchBoxMargin)
}

/**
 * HIDE GUNK
 */
// Hide AM banners and upsells
function hideBanners() {
  let upsellBanner = <HTMLElement>document.querySelector(".upsell-banner")
  upsellBanner?.style.setProperty("display", "none", "important")
  let localeSwitcher = <HTMLElement>document.querySelector(".locale-switcher-banner")
  localeSwitcher?.style.setProperty("display", "none", "important")
  let nativeLauncher = <HTMLElement>document.querySelector(".web-navigation__native-upsell")
  nativeLauncher?.style.setProperty("display", "none", "important")
  let webFooter = <HTMLElement>document.querySelector("footer")
  webFooter?.style.setProperty("display", "none", "important")
  
  let upsellButton = <HTMLElement>document.querySelector("native-upsell__button")
  upsellButton?.style.setProperty("display", "none", "important")
  
  // Click-close banners
  let closeLocaleButton = <HTMLElement>document.querySelector(".locale-switcher-banner__prompt-wrapper > button")
  closeLocaleButton?.click()
}
