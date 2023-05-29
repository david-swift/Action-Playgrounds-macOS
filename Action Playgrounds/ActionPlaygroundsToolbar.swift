//
//  ActionPlaygroundsToolbar.swift
//  Action Playgrounds
//
//  Created by david-swift on 28.05.23.
//

import PigeonApp
import SwiftUI

/// The toolbar of the main window.
struct ActionPlaygroundsToolbar: CustomizableToolbarContent {

    /// The view model.
    @ObservedObject var viewModel: ViewModel
    /// The open document.
    @Binding var document: ActionPlaygroundsDocument
    /// The templates.
    var templates: [TemplateFolder]

    /// The view's body.
    var body: some CustomizableToolbarContent {
        ToolbarItem(id: "template") {
            Menu {
                ForEach(templates) { folder in
                    Button(folder.title) {
                        document.addToTemplates(id: folder.id)
                    }
                }
            } label: {
                Label(.init(
                    "Add Template",
                    comment: "ActionPlaygroundsToolbar (Add template button)"
                ), systemSymbol: .docText)
            }
        }
        ToolbarItem(id: "custom-actions") {
            Button {
                viewModel.customActionsEditor.toggle()
            } label: {
                Label(.init(
                    "Custom Actions",
                    comment: "ActionPlaygroundsToolbar (Custom actions button)"
                ), systemSymbol: .function)
            }
        }
        ToolbarItem(id: "info") {
            Button {
                viewModel.parameterSheetPresented = true
            } label: {
                Label(.init("Parameters", comment: "ActionPlaygroundsToolbar (Parameters button)"), systemSymbol: .info)
            }
        }
    }

}
