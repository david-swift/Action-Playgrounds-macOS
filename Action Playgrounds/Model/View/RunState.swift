//
//  RunState.swift
//  Action Playgrounds
//
//  Created by david-swift on 09.05.23.
//

import ActionKit
import Foundation

/// The state of the execution.
enum RunState: Equatable {

    /// Edit mode.
    case notRunning
    /// Specify input for the function.
    case input
    /// Function is running.
    case running
    /// Specify output for the function.
    case output

}
