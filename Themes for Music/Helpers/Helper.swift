//
//  Helper.swift
//  Themes for Music
//
//  Created by Justin Bush on 2020-04-18.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Cocoa
import Foundation

protocol Helper {
    
}

class HelperClass: NSObject {
    
}


// Save User CountryCode to Defaults
/* OLD: Stable fetch CountryCode
let removeBaseURL = url.replacingOccurrences(of: "\(Music.url)/", with: "")
var countryCode = removeBaseURL.replacingOccurrences(of: "/for-you", with: "")
countryCode = countryCode.replacingOccurrences(of: "/browse", with: "")
countryCode = countryCode.replacingOccurrences(of: "/radio", with: "")      // Remove /radio
if countryCode.count == 2 {             // Check that country code is length 2
    if debug { print("Country Code: \(countryCode)") }
    User.co = countryCode
    if User.isSignedIn && (User.co != Defaults.string(forKey: "CountryCode")) {
        Defaults.set(countryCode, forKey: "CountyCode")
    }
}
*/

