/*
See LICENSE folder for this sample’s licensing information.

Abstract:
`ConfigCommand` is the configuration to use for a specific media command.
*/

import Foundation

struct ConfigCommand {
    
    // The command described by this configuration.
    
    let command: NowPlayableCommand
    
    // A displayable name for this configuration's command.
    
    let commandName: String
    
    // 'true' to register a handler for the corresponding MPRemoteCommandCenter command.
    
    var shouldRegister: Bool
    
    // 'true' to disable the corresponding MPRemoteCommandCenter command.
    
    var shouldDisable: Bool
    
    // Initialize a command configuration.
    
    init(_ command: NowPlayableCommand, _ commandName: String) {
        
        self.command = command
        self.commandName = commandName
        self.shouldDisable = false
        self.shouldRegister = false
    }
}
