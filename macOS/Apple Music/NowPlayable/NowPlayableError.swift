/*
See LICENSE folder for this sample’s licensing information.

Abstract:
`NowPlayableError` declares errors specific to the NowPlayable protocol.
*/

import Foundation

enum NowPlayableError: LocalizedError {
    
    case noRegisteredCommands
    case cannotSetCategory(Error)
    case cannotActivateSession(Error)
    case cannotReactivateSession(Error)

    var errorDescription: String? {
        
        switch self {
            
        case .noRegisteredCommands:
            return "At least one remote command must be registered."
            
        case .cannotSetCategory(let error):
            return "The audio session category could not be set:\n\(error)"
            
        case .cannotActivateSession(let error):
            return "The audio session could not be activated:\n\(error)"
            
        case .cannotReactivateSession(let error):
            return "The audio session could not be resumed after interruption:\n\(error)"
        }
    }
}
