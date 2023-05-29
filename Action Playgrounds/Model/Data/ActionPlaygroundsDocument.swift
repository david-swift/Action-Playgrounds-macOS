//
//  ActionPlaygroundsDocument.swift
//  Action Playgrounds
//
//  Created by david-swift on 07.05.23.
//

import ActionKit
import ColibriComponents
import PigeonApp
import SwiftUI
import UniformTypeIdentifiers

/// The document type.
class ActionPlaygroundsDocument: FileDocument, Codable, Bindable {

    /// The document type as a `UTType`.
    static var type: UTType = .init(exportedAs: "ch.david-swift.Action-Playground")

    /// The readable content types.
    static var readableContentTypes: [UTType] { [type] }

    /// The codable function.
    var function: CodableFunction<ActionInformation> {
        didSet {
            UndoProvider.registerUndo(withTarget: self) { $0.function = oldValue }
        }
    }
    /// Whether the templates picker has been presented.
    var templatesPicker = true

    /// Initialize a new document.
    init() {
        function = .init(
            id: UUID().uuidString,
            name: "Action",
            description: "An action defined by the user.",
            input: [],
            output: []
        )
    }

    /// Initialize a document with a given function.
    /// - Parameter function: The function.
    init(function: Function) {
        templatesPicker = false
        self.function = .init(id: function.id, name: .init(), description: .init(), input: [], output: [])
        self.function.function = function
    }

    /// Initialize a document with a given read configuration.
    /// - Parameter configuration: The read configuration.
    required init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let file = try? JSONDecoder().decode(Self.self, from: data)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        function = file.function
        templatesPicker = file.templatesPicker
    }

    /// Get the file from the document type.
    /// - Parameter configuration: The write configuration.
    /// - Returns: The file.
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        guard let data = try? JSONEncoder().encode(self) else {
            throw CocoaError(.fileWriteUnknown)
        }
        return .init(regularFileWithContents: data)
    }

    /// Add a parameter to the function.
    /// - Parameter output: Whether it is an output parameter.
    /// - Returns: The new parameters.
    func addParameter(output: Bool) -> [Parameter] {
        if output {
            function.function.output.append(.init(.init(localized: .init(
                "New Parameter",
                comment: "ActionPlaygroundsDocument (A new parameter's title)"
            )), type: String.self))
            return function.function.dataOutput
        } else {
            function.function.input.append(.init(.init(localized: .init(
                "New Parameter",
                comment: "ActionPlaygroundsDocument (A new parameter's title)"
            )), type: String.self))
            return function.function.dataInput
        }
    }

    /// Load a template's content.
    /// - Parameters:
    ///   - folderID: The template's folder's identifier.
    ///   - id: The template's identifer.
    ///   - templates: The available templates.
    func pickTemplate(folderID: UUID, id: UUID, templates: [TemplateFolder]) {
        if let data = templates[id: folderID]?.templates[id: id]?.content,
           let document = try? JSONDecoder().decode(Self.self, from: data) {
            self.function = document.function
        }
        templatesPicker = false
    }

    /// Add this document's function to the templates.
    /// - Parameter id: The folder's identifier.
    func addToTemplates(id: UUID) {
        PigeonAppAction.add(
            .init(
                title: NSApplication.shared.keyWindow?.title ?? .init(localized: .init(
                    "New Template",
                    comment: "ActionPlaygroundsToolbar (New template title)"
                )),
                icon: .docText,
                content: (try? JSONEncoder().encode(self)) ?? .init()
            ),
            to: id
        )
    }

}
