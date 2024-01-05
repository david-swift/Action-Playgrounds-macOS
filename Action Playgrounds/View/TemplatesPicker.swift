//
//  TemplatesPicker.swift
//  Action Playgrounds
//
//  Created by david-swift on 28.05.23.
//

import ColibriComponents
import PigeonApp
import SwiftUI

/// The picker for the templates.
struct TemplatesPicker: View {

    /// The view model.
    @EnvironmentObject private var viewModel: ViewModel
    /// The open document.
    @Binding var document: ActionPlaygroundsDocument
    /// The templates.
    var templates: [TemplateFolder]

    /// The minimal width of the sheet.
    let minWidth: CGFloat = 400
    /// The ideal width of the sheet.
    let idealWidth: CGFloat = 500
    /// The minimal heigh of the sheet.
    let minHeight: CGFloat = 250
    /// The ideal height of the sheet.
    let idealHeight: CGFloat = 350

    /// The view's body.
    var body: some View {
        NavigationSplitView {
            List(templates, selection: $viewModel.templateFolderSelection) { folder in
                Label(folder.title, systemSymbol: folder.icon)
            }
        } detail: {
            Group {
                if let items = templates[id: viewModel.templateFolderSelection]?.templates {
                    ScrollView {
                        SelectionItemPicker(selection: $viewModel.templateSelection, items: items)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(.init("Cancel", comment: "TemplatesPicker (Cancel template selection)")) {
                        document.templatesPicker = false
                        viewModel.objectWillChange.send()
                    }
                    .keyboardShortcut(.cancelAction)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(.init("Confirm", comment: "TemplatesPicker (Confirm template selection)")) {
                        viewModel.objectWillChange.send()
                        document.pickTemplate(
                            folderID: viewModel.templateFolderSelection ?? .init(),
                            id: viewModel.templateSelection,
                            templates: templates
                        )
                    }
                    .keyboardShortcut(.defaultAction)
                }
            }
        }
        .frame(minWidth: minWidth, idealWidth: idealWidth, minHeight: minHeight, idealHeight: idealHeight)
        .onAppear {
            viewModel.templateFolderSelection = templates.first?.id
            viewModel.templateSelection = templates.first?.templates.first?.id ?? .init()
        }
    }

}

/// Previews for the ``TemplatesPicker``.
struct TemplatesPicker_Previews: PreviewProvider {

    /// The preview.
    static var previews: some View {
        TemplatesPicker(document: .constant(.init()), templates: [])
    }

}
