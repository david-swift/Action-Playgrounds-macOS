//
//  ActionPlaygroundsCommands.swift
//  Action Playgrounds
//
//  Created by david-swift on 28.05.23.
//

import ActionKit
import SwiftUI

/// The commands in the menu bar.
struct ActionPlaygroundsCommands: Commands {

    /// The view model.
    @FocusedObject private var viewModel: ViewModel?
    /// The focused document.
    @FocusedValue(\.document)
    private var document
    /// The templates.
    @FocusedValue(\.templates)
    private var templates

    /// The view's body.
    var body: some Commands {
        CommandGroup(after: .newItem) {
            Menu(.init("Templates", comment: "ActionPlaygroundsCommands (Templates menu)")) {
                if let templates {
                    ForEach(templates) { folder in
                        Menu(folder.title) {
                            ForEach(folder.templates) { template in
                                Button(template.title) {
                                    document?.pickTemplate(folderID: folder.id, id: template.id, templates: templates)
                                    viewModel?.objectWillChange.send()
                                }
                            }
                        }
                    }
                    Divider()
                    Menu(.init("Add Document", comment: "ActionPlaygroundsCommands (Add template menu)")) {
                        ForEach(templates) { folder in
                            Button(folder.title) {
                                document?.addToTemplates(id: folder.id)
                            }
                        }
                    }
                    .disabled(document == nil)
                } else {
                    Text(.init("Create a document first.", comment: "ActionPlaygroundsCommands (No document message)"))
                }
            }
            .disabled(noViewModel)
        }
        CommandGroup(after: .importExport) {
            Group {
                Button(.init("Import Action", comment: "ActionPlaygroundsCommands (Import action button)")) {
                    viewModel?.customActionsEditor = false
                    viewModel?.importSheet.toggle()
                }
                .keyboardShortcut("i", modifiers: [.shift, .command])
                Button(.init("Manage Actions", comment: "ActionPlaygroundsCommands (Manage actions button)")) {
                    viewModel?.importSheet = false
                    viewModel?.customActionsEditor.toggle()
                }
                Divider()
                Button(.init("Run", comment: "ActionPlaygroundsCommands (Run file button)")) {
                    viewModel?.run()
                }
                .keyboardShortcut("r")
            }
            .disabled(noViewModel)
        }
        CommandGroup(before: .toolbar) {
            Group {
                Button(.init("Edit Parameters", comment: "ActionPlaygroundsCommands (Edit parameters button)")) {
                    viewModel?.parameterSheetPresented.toggle()
                }
                .keyboardShortcut("i")
                Button((viewModel?.outputParameters ?? false) ? .init(
                    "Show Input Parameters",
                    comment: "ActionPlaygroundsCommands (Show input parameters button)"
                ) : .init(
                    "Show Output Parameters",
                    comment: "ActionPlaygroundsCommands (Show output parameters button)"
                )) {
                    viewModel?.outputParameters.toggle()
                }
                .disabled(!(viewModel?.parameterSheetPresented ?? false))
                Divider()
                editorView
            }
            .disabled(noViewModel)
        }
    }

    /// A view with option for the action editor.
    @ViewBuilder private var editorView: some View {
        Picker(.init(
            "Actions Visibility",
            comment: "ActionPlaygroundsCommands (Visibility of the actions in the editor)"
        ), selection: (viewModel?.actions ?? .hidden).binding { viewModel?.actions = $0 }) {
            Text(.init("Hidden", comment: "ActionPlaygroundsCommands (Hidden action visibility)"))
                .tag(ActionVisibility.hidden)
            Text(.init("Menu", comment: "ActionPlaygroundsCommands (Menu action visibility)"))
                .tag(ActionVisibility.menu)
            Text(.init("Definition", comment: "ActionPlaygroundsCommands (Definition action visibility)"))
                .tag(ActionVisibility.definition)
            Text(.init("Parameters", comment: "ActionPlaygroundsCommands (Parameters action visibility)"))
                .tag(ActionVisibility.parameters)
        }
        Toggle(String(localized: .init(
            "Functions Overview",
            comment: "ActionPlaygroundsCommands (Expanded functions overview)"
        )), isOn: (viewModel?.expandFunctions ?? false).binding { viewModel?.expandFunctions = $0 })
    }

    /// Whether there is no active window.
    private var noViewModel: Bool {
        viewModel == nil
    }

}
