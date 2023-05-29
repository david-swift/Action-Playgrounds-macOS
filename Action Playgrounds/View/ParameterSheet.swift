//
//  ParameterSheet.swift
//  Action Playgrounds
//
//  Created by david-swift on 08.05.23.
//

import ActionKit
import ColibriComponents
import SwiftUI

/// A sheet for editing the input and output parameters.
struct ParameterSheet: View {

    /// The view model.
    @EnvironmentObject private var viewModel: ViewModel
    /// The open document.
    @Binding var document: ActionPlaygroundsDocument

    /// The sidelength of the sheet view.
    let sideLength: CGFloat = 300
    /// The sidelength of a button in the parameter sheet's title bar.
    let buttonSideLength: CGFloat = 30
    /// The opacity of a button's background in the parameter sheet's title bar.
    let buttonOpacity: CGFloat = 0.2

    /// The view's body.
    var body: some View {
        Group {
            if viewModel.outputParameters {
                outputParameters
            } else {
                inputParameters
            }
        }
        .frame(width: sideLength, height: sideLength)
    }

    /// The input/output parameters picker.
    private var picker: some View {
        Picker(.init(
            "Parameters",
            comment: "ParameterSheet (Parameters picker)"
        ), selection: $viewModel.outputParameters) {
            Text(.init("Input", comment: "ParameterSheet (Input parameters)"))
                .tag(false)
            Text(.init("Output", comment: "ParameterSheet (Output parameters)"))
                .tag(true)
        }
    }

    /// The input parameters view.
    private var inputParameters: some View {
        parametersView(parameters: document.function.function.dataInput.binding { newValue in
            document.function.function.input = newValue
        })
    }

    /// The output parameters view.
    private var outputParameters: some View {
        parametersView(parameters: document.function.function.dataOutput.binding { newValue in
            document.function.function.output = newValue
        })
    }

    /// The parameter view's titlebar.
    @ViewBuilder private var titleBar: some View {
        let bottomPadding: CGFloat = -10
        let pickerWidth: CGFloat = 75
        HStack {
            addButton
            Spacer()
            closeButton
        }
        .buttonStyle(.plain)
        .padding()
        .padding(.bottom, bottomPadding)
        .overlay {
            picker
                .frame(width: pickerWidth)
                .pickerStyle(.segmented)
                .labelsHidden()
        }
    }

    /// The add button in the title bar.
    private var addButton: some View {
        Button {
            let parameters = document.addParameter(output: viewModel.outputParameters)
            viewModel.addParameter(parameters: parameters)
        } label: {
            RoundedRectangle(cornerRadius: .colibriCornerRadius)
                .frame(width: buttonSideLength, height: buttonSideLength)
                .foregroundStyle(.gray.opacity(buttonOpacity))
                .overlay {
                    Image(systemSymbol: .plus)
                        .bold()
                        .accessibilityLabel(.init(
                            "Add Parameter",
                            comment: "ParameterSheet (Add parameter accessibility label)"
                        ))
                }
        }
    }

    /// The close button in the title bar.
    private var closeButton: some View {
        Button {
            viewModel.parameterSheetPresented = false
        } label: {
            Circle()
                .frame(width: buttonSideLength)
                .foregroundStyle(.gray.opacity(buttonOpacity))
                .overlay {
                    Image(systemSymbol: .xmark)
                        .bold()
                        .accessibilityLabel(.init(
                            "Close Parameter Sheet",
                            comment: "ParameterSheet (Clodr button accessibility label)"
                        ))
                }
        }
    }

    /// The parameters view (input and output).
    /// - Parameter parameters: The parameters.
    /// - Returns: A view for editing the parameters.
    @ViewBuilder
    private func parametersView(parameters: Binding<[Parameter]>) -> some View {
       titleBar
       ScrollView {
           SelectionItemPicker(selection: $viewModel.selection, items: parameters.wrappedValue)
               .popover(isPresented: $viewModel.information) {
                   informationSheet(parameters: parameters)
               }
               .contextMenu {
                   Button(.init("Edit Selection", comment: "ParameterSheet (Edit selection button)")) {
                       viewModel.information = true
                   }
                   Button(.init("Delete Selection", comment: "ParameterSheet (Delete selection button)")) {
                       parameters.wrappedValue = parameters.wrappedValue.filter { $0.id != viewModel.selection }
                       viewModel.selection = .init()
                   }
               }
       }
       .overlay(alignment: .top) {
           Divider()
       }
    }

    /// A sheet for editing parameter information.
    /// - Parameter parameters: The parameters.
    /// - Returns: A parameter editor.
    private func informationSheet(parameters: Binding<[Parameter]>) -> some View {
        let sheetWidth: CGFloat = 250
        return Group {
            TextField(.init(
                "Title",
                comment: "ParameterSheet (Title text field)"
            ), text: (parameters.wrappedValue[id: viewModel.selection]?.name ?? "").binding { newValue in
                parameters.wrappedValue[id: viewModel.selection]?.name = newValue
                viewModel.objectWillChange.send()
            })
            Picker(.init("Type", comment: "ParameterSheet (Type picker)"), selection: { () -> DataType in
                    .init(type: parameters.wrappedValue[id: viewModel.selection]?.type ?? Bool.self)
            }()
            .binding { newValue in
                if newValue == .text {
                    parameters.wrappedValue[id: viewModel.selection]?.type = String.self
                } else if newValue == .number {
                    parameters.wrappedValue[id: viewModel.selection]?.type = Double.self
                } else {
                    parameters.wrappedValue[id: viewModel.selection]?.type = Bool.self
                }
                viewModel.objectWillChange.send()
            }) {
                ForEach(DataType.allCases, id: \.hashValue) { type in
                    Text(type.localized)
                        .tag(type)
                }
            }
        }
        .frame(width: sheetWidth)
        .padding()
    }

}

/// Previews for the parameter sheet.
struct ParameterSheet_Previews: PreviewProvider {

    /// The preview.
    static var previews: some View {
        ParameterSheet(document: .constant(.init()))
    }

}
