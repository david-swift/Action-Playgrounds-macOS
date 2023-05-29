//
//  InputSheet.swift
//  Action Playgrounds
//
//  Created by david-swift on 25.05.23.
//

import ActionKit
import SwiftUI

/// A sheet for specifying the input values for the function.
struct InputSheet: View {

    /// The view model.
    @EnvironmentObject private var viewModel: ViewModel
    /// The open document.
    var document: ActionPlaygroundsDocument
    /// The specified values.
    @State private var values: [UUID: ActionType] = [:]

    /// The view's body.
    var body: some View {
        VStack {
            Text(.init("Input", comment: "InputSheet (Input title)"))
                .font(.title)
                .bold()
            ForEach(document.function.function.dataInput) { dataInput in
                inputField(dataInput: dataInput)
            }
            .textFieldStyle(.roundedBorder)
            .toggleStyle(.switch)
            runButton
        }
        .padding()
        .presentationBackground(.regularMaterial)
    }

    /// The button for starting the execution.
    private var runButton: some View {
        Button {
            viewModel.runState = .running
            do {
                let output = try document.function.function.run(input: {
                    var input: [ActionType] = []
                    for parameter in document.function.function.dataInput {
                        if let value = values[parameter.id] {
                            input.append(value)
                        } else {
                            input.append(parameter.type.init())
                        }
                    }
                    return input
                }())
                viewModel.runState = .output
                viewModel.output = output
            } catch {
                viewModel.runState = .notRunning
                viewModel.error = .init(localized: .init(
                    "The code could not be executed.",
                    comment: "InputSheet (Code execution error)"
                ))
            }
        } label: {
            HStack {
                Spacer()
                Text(.init("Run", comment: "ContentView (Run button)"))
                Spacer()
            }
        }
        .keyboardShortcut(.defaultAction)
    }

    /// A section with an input method for one parameter.
    /// - Parameter dataInput: The input parameter.
    /// - Returns: A view for editing the input.
    @ViewBuilder
    private func inputField(dataInput: Parameter) -> some View {
        if dataInput.type == String.self {
            TextField(dataInput.title, text: (values[dataInput.id] as? String ?? .init()).binding { newValue in
                values[dataInput.id] = newValue
            })
        } else if dataInput.type == Double.self {
            TextField(
                dataInput.title,
                value: (values[dataInput.id] as? Double ?? 0).binding { newValue in
                    values[dataInput.id] = newValue
                },
                format: .number
            )
        } else if dataInput.type == Bool.self {
            Toggle(dataInput.title, isOn: (values[dataInput.id] as? Bool ?? false).binding { newValue in
                values[dataInput.id] = newValue
            })
        }
    }

}

/// Previews for the ``InputSheet``.
struct InputSheet_Previews: PreviewProvider {

    /// The preview.
    static var previews: some View {
        InputSheet(document: .init())
    }

}
