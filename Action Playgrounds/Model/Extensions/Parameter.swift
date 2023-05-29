//
//  Parameter.swift
//  Action Playgrounds
//
//  Created by david-swift on 08.05.23.
//

import ActionKit
import ColibriComponents
import SFSafeSymbols

extension Parameter: SelectionItem {

    /// The selection item's title.
    public var title: String {
        name
    }

    /// The selection item's icon.
    public var icon: SFSymbol {
        if type.init() as? String != nil {
            return .textBookClosed
        } else if type.init() as? Double != nil {
            return .number
        } else if type.init() as? Bool != nil {
            return .circleLefthalfFilled
        }
        return .questionmark
    }

}
