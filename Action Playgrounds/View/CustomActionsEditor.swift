//
//  CustomActionsEditor.swift
//  Action Playgrounds
//
//  Created by david-swift on 28.05.23.
//

import SwiftUI

/// An editor for the custom actions.
struct CustomActionsEditor: View {

    /// The view model.
    @EnvironmentObject private var viewModel: ViewModel

    /// The sheet's height.
    let height: CGFloat = 200

    /// The view's body.
    var body: some View {
        List(ActionInformation.additionalFunctions, selection: $viewModel.actionSelection) { function in
            Text(function.function.name)
        }
        .frame(height: height)
        .toolbar {
            ToolbarItem {
                Button(.init("Add", comment: "ContentView (Add function button)")) {
                    viewModel.customActionsEditor = false
                    viewModel.importSheet.toggle()
                }

            }
            ToolbarItem {
                Button(.init("Delete", comment: "ContentView (Delete function button)")) {
                    for selection in viewModel.actionSelection {
                        viewModel.deleteAction(id: selection)
                    }
                    viewModel.customActionsEditor = false
                    viewModel.restart = true
                }
            }
            ToolbarItem(placement: .cancellationAction) {
                Button(.init("Close", comment: "ContentView (Close button)")) {
                    viewModel.customActionsEditor.toggle()
                }
                .keyboardShortcut(.defaultAction)
            }
        }
    }
}

/// Previews for the ``CustomActionsEditor``.
struct CustomActionsEditor_Previews: PreviewProvider {

    /// The preview.
    static var previews: some View {
        CustomActionsEditor()
    }

}
