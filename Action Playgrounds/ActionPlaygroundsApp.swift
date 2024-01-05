//
//  ActionPlaygroundsApp.swift
//  Action Playgrounds
//
//  Created by david-swift on 07.05.23.
//

import PigeonApp
import SwiftUI

/// The app "Action Playgrounds".
@main
struct ActionPlaygroundsApp: App {

    /// The app model.
    @StateObject private var appModel = AppModel.shared

    /// The app's body.
    var body: some Scene {
        PigeonDocumentApp(
            appName: "Action Playgrounds",
            appIcon: .init(nsImage: .init(named: "AppIcon") ?? .init()),
            document: ActionPlaygroundsDocument()
        ) { document, _, _, templates in
            ContentView(document: document, templates: templates)
        }
        .information(description: .init(localized: .init(
            "A visual scripting editor for macOS.",
            comment: "ActionPlaygroundsApp (Description)"
        ))) {
            for link in appModel.links {
                (.init(localized: link.0), link.1)
            }
        } contributors: {
            for contributor in appModel.contributors {
                contributor
            }
        } acknowledgements: {
            ("SwiftLintPlugin", .string("https://github.com/lukepistrol/SwiftLintPlugin"))
            ("PigeonApp", .string("https://github.com/david-swift/PigeonApp-macOS"))
        }
        .help(.init(
            "Action Playgrounds Help",
            comment: "ActionPlaygroundsApp (Help)"
        ), link: .string("https://david-swift.gitbook.io/action-playgrounds/"))
        .newestVersion(gitHubUser: "david-swift", gitHubRepo: "Action-Playgrounds-macOS")
        .versions {
            for version in appModel.versions {
                version
            }
        }
        .templates {
            TemplateFolder(
                title: .init(localized: .init("Default", comment: "ActionPlaygroundsApp (Default templates)")),
                icon: .appGift
            ) {
                for template in appModel.templates {
                    template
                }
            }
            TemplateFolder(
                title: .init(localized: .init("User", comment: "ActionPlaygroundsApp (Templates defined by the user)")),
                icon: .person
            ) { }
        }
        .commands {
            ActionPlaygroundsCommands()
        }
    }

}
