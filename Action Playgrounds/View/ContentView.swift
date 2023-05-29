//
//  ContentView.swift
//  Action Playgrounds
//
//  Created by david-swift on 07.05.23.
//

import ActionKit
import ColibriComponents
import PigeonApp
import SwiftUI

/// The main window.
struct ContentView: View {

    /// The view model.
    @StateObject private var viewModel = ViewModel()
    /// The document.
    @Binding var document: ActionPlaygroundsDocument
    /// The templates.
    var templates: [TemplateFolder]

    /// The view's body.
    var body: some View {
        // swiftlint:disable trailing_closure
        FunctionEditor($document.function.function, extraActions: {
            .init(tag: "run") {
                Button {
                    viewModel.run()
                } label: {
                    Label(.init("Run", comment: "ContentView (Run button)"), systemSymbol: .playFill)
                }
            }
        })
        // swiftlint:enable trailing_closure
        .throwError(error: $viewModel.error)
        .observeActions(value: $viewModel.actions)
        .observeExpandFunctions(value: $viewModel.expandFunctions)
        .focusedSceneValue(\.document, document)
        .focusedSceneValue(\.templates, templates)
        .focusedSceneObject(viewModel)
        .sheet(isPresented: $viewModel.customActionsEditor) {
            CustomActionsEditor()
        }
        .fileImporter(
            isPresented: $viewModel.importSheet,
            allowedContentTypes: [ActionPlaygroundsDocument.type]
        ) { result in
            importFile(url: try? result.get())
        }
        .confirmationDialog(.init(
            "Restart the application to apply the changes.",
            comment: "ContentView (Restart confirmation dialog)"
        ), isPresented: $viewModel.restart) {
            Button(.init("Quit", comment: "ContentView (Quit button)")) {
                NSApplication.shared.terminate(nil)
            }
        }
        .toolbar(id: "toolbar") {
            ActionPlaygroundsToolbar(viewModel: viewModel, document: $document, templates: templates)
        }
        .sheet(isPresented: $viewModel.parameterSheetPresented) {
            ParameterSheet(document: $document)
                .presentationBackground(.regularMaterial)
        }
        .sheet(isPresented: (viewModel.runState == .output).binding { newValue in
            if !newValue { viewModel.runState = .notRunning }
        }, content: {
            OutputSheet(document: document)
        })
        .sheet(isPresented: (viewModel.runState == .input).binding { newValue in
            if !newValue { viewModel.runState = .notRunning }
        }) {
            InputSheet(document: document)
        }
        .sheet(isPresented: $document.templatesPicker) {
            TemplatesPicker(document: $document, templates: templates)
        }
        .environmentObject(viewModel)
    }

    /// Import a function from a file at a given URL.
    /// - Parameter url: The URL.
    func importFile(url: URL?) {
        if let url,
           let data = try? Data(contentsOf: url),
           let file = try? JSONDecoder().decode(ActionPlaygroundsDocument.self, from: data) {
            var function = file.function
            viewModel.restart = true
            viewModel.deleteAction(id: function.id)
            function.function.name = url.lastPathComponent
            let fileExtensionCount = 17
            function.function.name.removeLast(fileExtensionCount)
            ActionInformation.additionalFunctions.append(function)
        }
    }
}

/// Previews for the ``ContentView``.
struct ContentView_Previews: PreviewProvider {

    /// The preview.
    static var previews: some View {
        ContentView(document: .constant(ActionPlaygroundsDocument()), templates: [])
    }

}
