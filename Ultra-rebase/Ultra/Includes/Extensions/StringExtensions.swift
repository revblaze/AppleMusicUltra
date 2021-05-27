//
//  String Extensions
//  StringExtensions.swift
//
//  SwiftyStarterKits
//  Swift 5.2 (Xcode 12.4)
//
//  Created by Justin Bush © 2021
//  https://github.com/revblaze/SwiftyStarterKits
//

import Foundation

extension String {
    /// Quick convert `String` to `URL`
    /// # Usage
    ///     let url = String.toURL
    func toURL() -> URL {
        return URL(string: self)!
    }
    /// Get the name of a file, from a `Sring`, without path or file extension
    /// # Usage
    ///     let path = "/dir/file.txt"
    ///     let file = path.fileName()
    /// - returns: `"/dir/file.txt" -> "file"`
    func fileName() -> String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }
    /// Get the extension of a file (`html`, `txt`, etc.), from a `Sring`, without path or name
    /// # Usage
    ///     let name = "index.html"
    ///     let ext = name.fileExtension()
    /// - returns: `"file.txt" -> "txt"`
    func fileExtension() -> String {
        return URL(fileURLWithPath: self).pathExtension
    }
    /// Get the file name and extension (`file.txt`), from a `Sring`, without path component
    /// # Usage
    ///     let path = "/path/to/file.txt"
    ///     let file = path.removePath()
    /// - returns: `"/path/to/file.txt" -> "file.txt"`
    func removePath() -> String {
        return URL(fileURLWithPath: self).lastPathComponent
    }
    /// Extracts URLs from a `String` and returns them as an `array` of `[URLs]`
    /// # Usage
    ///     let html = [HTML as String]
    ///     let urls = html.extractURLs()
    /// - returns: `["url1", "url2", ...]`
    func extractURLs() -> [URL] {
        var urls : [URL] = []
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            detector.enumerateMatches(in: self, options: [], range: NSMakeRange(0, self.count), using: { (result, _, _) in
                if let match = result, let url = match.url {
                    urls.append(url)
                }
            })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return urls
    }
    /// Returns true if the `String` is either empty or only spaces
    func isBlank() -> Bool {
        if (self.isEmpty) { return true }
        return (self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) == "")
    }
}
