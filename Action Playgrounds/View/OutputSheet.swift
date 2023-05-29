//
//  OutputSheet.swift
//  Action Playgrounds
//
//  Created by david-swift on 25.05.23.
//

import SwiftUI

/// A sheet showing the output of the function.
struct OutputSheet: View {

    /// The view model.
    @EnvironmentObject private var viewModel: ViewModel
    /// The open document.
    var document: ActionPlaygroundsDocument

    /// The view's body.
    var body: some View {
        VStack {
            Text(.init("Output", comment: "OutputSheet (Output title)"))
                .font(.title)
                .bold()
                .padding(.bottom)
            ForEach(document.function.function.dataOutput.indices, id: \.hashValue) { index in
                Text("\(document.function.function.dataOutput[safe: index]?.name ?? .init()): ").bold()
                +
                Text({ () -> String in
                    if let value = viewModel.output[safe: index] as? String {
                        return value
                    } else if let value = viewModel.output[safe: index] as? Double {
                        return .init(value.formatted())
                    } else if let value = viewModel.output[safe: index] as? Bool {
                        return .init(localized: value ?
                            .init("True", comment: "OutputSheet (True value)") :
                            .init("False", comment: "OutputSheet (False value)"))
                    }
                    return ""
                }())
            }
            Button {
                viewModel.runState = .notRunning
            } label: {
                HStack {
                    Spacer()
                    Text(.init("Close", comment: "OutputSheet (Close button)"))
                    Spacer()
                }
            }
            .keyboardShortcut(.defaultAction)
        }
        .padding()
        .presentationBackground(.regularMaterial)
    }

}

/// Previews for the ``OutputSheet``.
struct OutputSheet_Previews: PreviewProvider {

    /// The preview.
    static var previews: some View {
        OutputSheet(document: .init())
    }

}
