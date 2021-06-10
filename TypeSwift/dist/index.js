"use strict";
// Page did load
function didLoad() {
    hideBanners();
    hideUIComponents();
    applyStyles();
}
didLoad();
/**
 * GLOBAL STYLES
 */
function applyStyles() {
    // Document Body
    var docBody = document.querySelector("body");
    docBody === null || docBody === void 0 ? void 0 : docBody.style.setProperty("background-color", "transparent", "important");
    // Search Box background
    var searchBoxInput = document.querySelector(".dt-search-box__input");
    searchBoxInput === null || searchBoxInput === void 0 ? void 0 : searchBoxInput.style.setProperty("background-color", "rgba(0,0,0,0.1");
    // About & Similar Artists bottom section
    var altSection = document.querySelector(".alt-section");
    altSection === null || altSection === void 0 ? void 0 : altSection.style.setProperty("background-color", "transparent", "important");
    // Artist Page
    var artistGroups = document.querySelector(".artist-groups");
    artistGroups === null || artistGroups === void 0 ? void 0 : artistGroups.style.setProperty("background-color", "transparent", "important");
}
// USER LOGIN CHECK
// Returns true if user is logged in, else false
function signedIn() {
    var loginButton = document.getElementsByClassName("web-navigation__auth-button")[0];
    if (loginButton === null || loginButton === void 0 ? void 0 : loginButton.innerHTML.includes("Sign In")) {
        return false;
    }
    else {
        return true;
    }
}
// DARK MODE CHECK
// Returns true if user is in dark mode, else light mode
function darkMode() {
    var docBody = document.querySelector("body");
    if (docBody.classList.contains("dark-mode")) {
        return true;
    }
    else {
        return false;
    }
}
/**
 * GLOBAL PROPERTIES
 */
// Hide AM Web Player UI components
function hideUIComponents() {
    var appleMusicLogo = document.querySelector(".web-navigation__header");
    appleMusicLogo === null || appleMusicLogo === void 0 ? void 0 : appleMusicLogo.style.setProperty("display", "none");
    var searchBoxMargin = "44px";
    if (signedIn()) {
        searchBoxMargin = "0px";
    }
    var searchBox = document.querySelector(".search-box");
    searchBox === null || searchBox === void 0 ? void 0 : searchBox.style.setProperty("margin-top", searchBoxMargin);
}
/**
 * HIDE GUNK
 */
// Hide AM banners and upsells
function hideBanners() {
    var upsellBanner = document.querySelector(".upsell-banner");
    upsellBanner === null || upsellBanner === void 0 ? void 0 : upsellBanner.style.setProperty("display", "none");
    var localeSwitcher = document.querySelector(".locale-switcher-banner");
    localeSwitcher === null || localeSwitcher === void 0 ? void 0 : localeSwitcher.style.setProperty("display", "none");
    var nativeLauncher = document.querySelector(".web-navigation__native-upsell");
    nativeLauncher === null || nativeLauncher === void 0 ? void 0 : nativeLauncher.style.setProperty("display", "none");
    var webFooter = document.querySelector("footer");
    webFooter === null || webFooter === void 0 ? void 0 : webFooter.style.setProperty("display", "none");
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
//# sourceMappingURL=index.js.map