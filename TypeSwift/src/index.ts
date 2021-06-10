// Page did load
function didLoad() {
  hideBanners()
  hideUIComponents()
  applyStyles()
}
didLoad()

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
  upsellBanner?.style.setProperty("display", "none")
  let localeSwitcher = <HTMLElement>document.querySelector(".locale-switcher-banner")
  localeSwitcher?.style.setProperty("display", "none")
  let nativeLauncher = <HTMLElement>document.querySelector(".web-navigation__native-upsell")
  nativeLauncher?.style.setProperty("display", "none")
  let webFooter = <HTMLElement>document.querySelector("footer")
  webFooter?.style.setProperty("display", "none")
}




// Document Body
/*
let docBody = <HTMLElement>document.querySelector("body")
docBody.style.setProperty("background-color", "transparent", "important")
// Search Box background
let searchBoxInput = <HTMLElement>document.querySelector(".dt-search-box__input")
searchBoxInput.style.setProperty("background-color", "rgba(0,0,0,0.1")
// About & Similar Artists bottom section
let altSection = <HTMLElement>document.querySelector(".alt-section")
altSection.style.setProperty("background-color", "transparent", "important")
// Artist Page
let artistGroups = <HTMLElement>document.querySelector(".artist-groups")
artistGroups.style.setProperty("background-color", "transparent", "important")
let appleMusicLogo = <HTMLElement>document.querySelector(".web-navigation__header")
appleMusicLogo.style.setProperty("display", "none")
let searchBox = <HTMLElement>document.querySelector(".search-box")
searchBox.style.setProperty("margin-top", "44px")
let upsellBanner = <HTMLElement>document.querySelector(".upsell-banner")
upsellBanner.style.setProperty("display", "none")
let localeSwitcher = <HTMLElement>document.querySelector(".locale-switcher-banner")
localeSwitcher.style.setProperty("display", "none")
let nativeLauncher = <HTMLElement>document.querySelector(".web-navigation__native-upsell")
nativeLauncher.style.setProperty("display", "none")
let webFooter = <HTMLElement>document.querySelector("footer")
webFooter.style.setProperty("display", "none")
*/
