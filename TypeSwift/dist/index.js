"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __generator = (this && this.__generator) || function (thisArg, body) {
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
    return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
    function verb(n) { return function (v) { return step([n, v]); }; }
    function step(op) {
        if (f) throw new TypeError("Generator is already executing.");
        while (_) try {
            if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [op[0] & 2, t.value];
            switch (op[0]) {
                case 0: case 1: t = op; break;
                case 4: _.label++; return { value: op[1], done: false };
                case 5: _.label++; y = op[1]; op = [0]; continue;
                case 7: op = _.ops.pop(); _.trys.pop(); continue;
                default:
                    if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                    if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                    if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                    if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                    if (t[2]) _.ops.pop();
                    _.trys.pop(); continue;
            }
            op = body.call(thisArg, _);
        } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
        if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
    }
};
/*
 * WebKit Event Listeners, Post Message:
 * Takes some message, as a `String`, and sends it to the Xcode console.
 * @param msg The message to be sent to the Xcode console
 * @returns A message, of type `String`, to be printed in the Xcode console, ie. "[WKTS] toggle() success"
 */
function postMessage(msg) {
    window.webkit.messageHandlers.eventListeners.postMessage("[WKTS] " + msg);
}
/**
 * Global Variables
 */
var pageDidLoad = false;
var isDarkMode = false;
var isSignedIn = true;
//    Loading: has-js is-desktop dark-mode ember-application no-touch no-song-loaded
// Signed out: has-js is-desktop dark-mode ember-application no-touch no-song-loaded not-authenticated not-subscribed storefront browse browse-index upsell-banner-visible upsell-banner-visible--bottom
//  Signed in: has-js is-desktop dark-mode ember-application no-touch no-song-loaded storefront browse browse-index
// Signin lib: has-js is-desktop dark-mode ember-application no-touch no-song-loaded library library-recently-added is-not-focused
// storefront: browse, listen-now, radio ||| album, artist
//    library: library-recently-added, library-recently-added, library-artists, library-made-for-you, library-playlist
//    account: account-settings
function checkBody() {
    return __awaiter(this, void 0, void 0, function () {
        var body, classNames;
        return __generator(this, function (_a) {
            body = document.querySelector("body");
            classNames = body === null || body === void 0 ? void 0 : body.classList;
            classNames.forEach(function (className) {
                //postMessage(className)
                if (className === "storefront" || className === "library") {
                    pageDidLoad = true;
                }
                if (className === "dark-mode") {
                    isDarkMode = true;
                }
                if (className === "light-mode") {
                    isDarkMode = false;
                }
                if (className === "not-authenticated") {
                    isSignedIn = false;
                }
                if (className === "account") {
                    pageDidLoad = true;
                }
                //if(className === "no-song-loaded") { isPlayingMusic = false }
            });
            //let classListString = classNames.toString()
            //if(classListString.in)
            postMessage(classNames.toString());
            return [2 /*return*/];
        });
    });
}
checkBody();
//let pageDidLoad = false
function checkPageLoad() {
    if (pageDidLoad === false) {
        checkBody();
        window.setTimeout(checkPageLoad, 100); /* this checks the flag every 100 milliseconds*/
    }
    else {
        postMessage("pageDidLoad = " + pageDidLoad);
        postMessage("isDarkMode = " + isDarkMode);
        postMessage("isSignedIn = " + isSignedIn);
        didLoad();
    }
}
checkPageLoad();
// Page did load
function didLoad() {
    hideBanners();
    hideUIComponents();
    applyStyles();
    checkBody();
}
didLoad();
window.onload = function () {
    didLoad();
    //return "window.onload"
    postMessage("window.onload");
};
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
    upsellBanner === null || upsellBanner === void 0 ? void 0 : upsellBanner.style.setProperty("display", "none", "important");
    var localeSwitcher = document.querySelector(".locale-switcher-banner");
    localeSwitcher === null || localeSwitcher === void 0 ? void 0 : localeSwitcher.style.setProperty("display", "none", "important");
    var nativeLauncher = document.querySelector(".web-navigation__native-upsell");
    nativeLauncher === null || nativeLauncher === void 0 ? void 0 : nativeLauncher.style.setProperty("display", "none", "important");
    var webFooter = document.querySelector("footer");
    webFooter === null || webFooter === void 0 ? void 0 : webFooter.style.setProperty("display", "none", "important");
    var upsellButton = document.querySelector("native-upsell__button");
    upsellButton === null || upsellButton === void 0 ? void 0 : upsellButton.style.setProperty("display", "none", "important");
    // Click-close banners
    var closeLocaleButton = document.querySelector(".locale-switcher-banner__prompt-wrapper > button");
    closeLocaleButton === null || closeLocaleButton === void 0 ? void 0 : closeLocaleButton.click();
}
//# sourceMappingURL=index.js.map