//
//  EventListeners.swift
//  Ultra
//
//  Created by Justin Bush on 2020-08-25.
//

import Foundation

enum PlayerState {
    case loaded     // Web Player is Loaded
    case active     // Web Player is Active
}

var activeCheckCount = 0                // Number of Active Player Checks
var eventListenersWereAdded = false     // Additional JS Event Listeners Flag

// MARK: Event Listeners

extension ViewController {
    /// Runs JS `addEventListeners` for a given `PlayerState`
    /// - Parameters:
    ///     - forState: `PlayerState: .loaded || .active`
    func addEventListeners(forState: PlayerState) {
        switch forState {
        case .loaded:   Debug.log("Add Universal EventListeners")
        case .active:   runDisabledPlayerCheck()
        }
    }
    /// Checks to see if the player has become active (in `20s` intervals). Once the console returns `false`,
    /// add event listeners that require an active player.
    /// ## Process
    /// 1. Check if `User.isSignedIn` (active player requires account)
    /// 2. While player is not active (`!Music.isActive`), run checks with JS every `20s`
    /// 3. Once `Script.isPlayerDisabled` returns `false`...
    /// 4. `addActiveEventListeners()`
    func runDisabledPlayerCheck() {
        if User.isSignedIn && !Player.isActive {              // REQUIRE USER LOGIN FOR LESS REQUESTS?
        //if !Player.isActive {
            Timer.scheduledTimer(withTimeInterval: 20, repeats: true) { timer in
                activeCheckCount += 1
                if !Music.isPlaying {
                    if debug { print("\(activeCheckCount). Waiting for Player to become active...") }
                    if self.runWithResult(Script.isPlayerDisabled).contains("false") {
                        timer.invalidate()
                        self.addActiveEventListeners()
                    }
                }
            }
        }
    }
    /// Event listeners for when the player becomes active (`Music.isActive`)
    func addActiveEventListeners() {
        Player.didBecomeActive()
        if !eventListenersWereAdded {
            run(Script.addActiveListeners)
            eventListenersWereAdded = true
            Debug.log("Player. is active. Event Listeners were added.")
        }
    }
    
}
