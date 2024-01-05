//
//  ViewModel.swift
//  Action Playgrounds
//
//  Created by david-swift on 08.05.23.
//

import ActionKit
import Foundation

/// The information about a main window.
class ViewModel: ObservableObject {

    /// Whether the sheet for editing the parameters is presented.
    @Published var parameterSheetPresented = false
    /// Whether the output parameters are presented in the parameter sheet.
    @Published var outputParameters = false
    /// The selected parameter's identifier.
    @Published var selection: UUID = .init() {
        didSet {
            information = true
        }
    }
    /// Whether the parameter information is visible.
    @Published var information = false
    /// The active error.
    @Published var error: String?
    /// The state of the execution.
    @Published var runState: RunState = .notRunning
    /// The output of the execution.
    @Published var output: [ActionType] = []
    /// The visibility of the actions in the editor.
    @Published var actions: ActionVisibility = .hidden
    /// Whether the expaned functions view is visible in the editor.
    @Published var expandFunctions = false
    /// Whether the "Quit Action Playgrounds" confirmation dialog is presented.
    @Published var restart = false
    /// Whether the editor for the custom actions is displayed.
    @Published var customActionsEditor = false
    /// Whether the sheet for importing functions is displayed.
    @Published var importSheet = false
    /// The selected actions in the custom actions editor.
    @Published var actionSelection: Set<String> = []
    /// The selected template folder in the template sheet.
    @Published var templateFolderSelection: UUID?
    /// The selected template in the template sheet.
    @Published var templateSelection: UUID = .init()

    /// Changes in the view model after adding a parameter.
    /// - Parameter parameters: The parameters.
    func addParameter(parameters: [Parameter]) {
        if let id = parameters.last?.id {
            selection = id
            information = true
        }
    }

    /// Run the function.
    func run() {
        runState = .input
    }

    /// Delete an action.
    /// - Parameter id: The action's identifier.
    func deleteAction(id: String) {
        ActionInformation.additionalFunctions = ActionInformation.additionalFunctions.filter { $0.id != id }
    }

}
