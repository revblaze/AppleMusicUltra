//
//  ProgressDidChange.swift
//  Ultra
//
//  Created by Justin Bush on 2020-08-31.
//

import Foundation

// MARK: Progress Did Change

extension ViewController {
    
    /// Fired when the progress of a page load changes
    func progressDidChange(_ progress: Double) {
        print("Progress: \(progress)")
        progressValue = (progress*100)/10
    }
    
}
