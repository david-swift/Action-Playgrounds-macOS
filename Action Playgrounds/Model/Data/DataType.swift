//
//  DataType.swift
//  Action Playgrounds
//
//  Created by david-swift on 28.05.23.
//

import ActionKit
import ColibriComponents
import Foundation

/// The data types for the input and output parameters.
enum DataType: CaseIterable, Bindable {

    /// Text data type.
    case text
    /// Number data type.
    case number
    /// Boolean data type.
    case boolean

    /// A localized description of the data type.
    var localized: LocalizedStringResource {
        switch self {
        case .text:
            return .init("Text", comment: "DataType (Text)")
        case .number:
            return .init("Number", comment: "DataType (Number)")
        case .boolean:
            return .init("Boolean", comment: "DataType (Boolean)")
        }
    }

    /// Initialize a data type.
    /// - Parameter type: The action type.
    init(type: ActionType.Type) {
        if type == String.self {
            self = .text
        } else if type == Double.self {
            self = .number
        } else {
            self = .boolean
        }
    }

}
