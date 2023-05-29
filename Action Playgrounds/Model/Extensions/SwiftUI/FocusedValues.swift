//
//  FocusedValues.swift
//  Action Playgrounds
//
//  Created by david-swift on 08.05.23.
//

import PigeonApp
import SwiftUI

extension FocusedValues {

    /// The focused value key for the document.
    var document: ActionPlaygroundsDocument? {
        get { self[DocumentKey.self] }
        set { self[DocumentKey.self] = newValue }
    }

    // swiftlint:disable discouraged_optional_collection
    /// The focused value key for the templates.
    var templates: [TemplateFolder]? {
        get { self[TemplateKey.self] }
        set { self[TemplateKey.self] = newValue }
    }
    // swiftlint:enable discouraged_optional_collection

}
