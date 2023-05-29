//
//  TemplateKey.swift
//  Action Playgrounds
//
//  Created by david-swift on 28.05.23.
//

import PigeonApp
import SwiftUI

/// The focused value key for the templates.
struct TemplateKey: FocusedValueKey {

    /// The template type.
    typealias Value = [TemplateFolder]

}
