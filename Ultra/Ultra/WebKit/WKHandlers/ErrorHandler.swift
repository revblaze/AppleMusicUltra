//
//  ErrorHandler.swift
//  Ultra
//
//  Created by Justin Bush on 2020-04-20.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Foundation

struct ErrorHandler {
    /// WebView attempted to load Radio Station
    static func isRadioStation(_ url: String, last: String) -> Bool {
        if (last.contains("station") && url.contains("radio")) || last.contains("radio") && url.contains("station") {
            return true
        } else { return false }
    }
    
    static let authKitURL = "https://buy.itunes.apple.com/commerce/account/authenticateMusicKitRequest"
    static func didReceiveError(_ url: String) {
        let errorFailedToVerify = "ERROR_FAILED_TO_VERIFY"
        let errorInvalidSession = "ERROR_INVALID_SESSION"
        if url.contains(errorFailedToVerify) { print("Error: \(errorFailedToVerify)") }
        else if url.contains(errorInvalidSession) { print("Error: \(errorInvalidSession)") }
        else if url.contains(authKitURL) { print("Error: Login failed. Unable to authenticate user.") }
        else { print("Error: \(url)") }
    }
}

struct ErrorMessage {
    
    struct Radio {
        static let title = "Unsupported Radio Station"
        static let message = "We're sorry, Apple Music does not yet support this radio station outside of iTunes."
    }
    
}
