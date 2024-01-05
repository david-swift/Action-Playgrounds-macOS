//
//  ActionInformation.swift
//  Action Playgrounds
//
//  Created by david-swift on 07.05.23.
//

import ActionKit
import ColibriComponents
import Foundation

/// Information for the function.
struct ActionInformation: CodableFunctionInformation {

    /// The supported types.
    static var types: [ActionType.Type] {
        Double.self
        String.self
        Bool.self
    }

    /// The supported functions.
    static var functions: [Folder<Function>] {
        for folder in [Folder<Function>].default {
            folder
        }
        if !additionalFunctions.isEmpty {
            Folder(.init(localized: .init(
                "Custom Functions",
                comment: "ActionInformation (Custom functions folder)"
            )), systemSymbol: .gearshape) {
                for function in additionalFunctions {
                    function.function
                }
            }
        }
    }

    /// The custom functions.
    static var additionalFunctions: [CodableFunction<Self>] = [] {
        didSet {
            if let data = try? JSONEncoder().encode(additionalFunctions) {
                UserDefaults.standard.set(data, forKey: "functions")
            }
        }
    }

    /// A value of an action type.
    var type: ActionType

    /// Initialize the value.
    /// - Parameter type: The value.
    init(type: ActionType) {
        self.type = type
    }

    /// Initialize from a decoder.
    /// - Parameter decoder: The decoder.
    init(from decoder: Decoder) throws {
        let decoder = try decoder.singleValueContainer()
        if let value = try? decoder.decode(String.self) {
            self.init(type: value)
        } else if let value = try? decoder.decode(Double.self) {
            self.init(type: value)
        } else if let value = try? decoder.decode(Bool.self) {
            self.init(type: value)
        } else if let value = try? decoder.decode(ControlFlow.self) {
            self.init(type: value)
        } else {
            self.init(type: ControlFlow.signal)
        }
    }

    /// Encode the value.
    /// - Parameter encoder: The encoder.
    func encode(to encoder: Encoder) throws {
        var encoder = encoder.singleValueContainer()
        if let string = type as? String {
            try encoder.encode(string)
        } else if let double = type as? Double {
            try encoder.encode(double)
        } else if let boolean = type as? Bool {
            try encoder.encode(boolean)
        }
    }

}
