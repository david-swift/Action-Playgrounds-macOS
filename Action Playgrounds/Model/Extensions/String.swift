//
//  String.swift
//  Action Playgrounds
//
//  Created by david-swift on 28.05.23.
//

import Foundation

extension String {

    /// The GitHub repository of the Action Playgrounds app.
    static var gitHubRepo: String { "https://github.com/david-swift/Action-Playgrounds-macOS" }
    /// The URL to a new issue for a feature request.
    static var featureRequest: String {
        gitHubRepo
        + "/issues/new?assignees=&labels=enhancement&template=feature_request.yml"
    }
    /// The URL to a new issue for a bug report.
    static var bugReport: String {
        gitHubRepo
        + "/issues/new?assignees=&labels=bug&template=bug_report.yml"
    }

}
