//
//  AppModel.swift
//  Action Playgrounds
//
//  Created by david-swift on 27.05.23.
//

import ActionKit
import ColibriComponents
import Foundation
import PigeonApp
import SFSafeSymbols

/// The app model.
class AppModel: ObservableObject {

    /// A shared instance of the app model.
    static var shared = AppModel()

    /// A list of all of the contributors.
    @Published var contributors: [(String, URL)] = []

    /// Important links.
    let links: [(LocalizedStringResource, URL)] = [
        (
            .init("GitHub", comment: "AppModel (Label of the link to the GitHub repository)"),
            .string(.gitHubRepo)
        ),
        (
            .init("Bug Report", comment: "AppModel (Label of the link to the bug report issue"),
            .string(.bugReport)
        ),
        (
            .init("Feature Request", comment: "AppModel (Label of the link to the feature request issue"),
            .string(.featureRequest)
        )
    ]

    // swiftlint:disable no_magic_numbers
    /// The app's versions.
    @ArrayBuilder<Version> var versions: [Version] {
        Version("0.1.0", date: .init(timeIntervalSince1970: 1_685_338_952)) {
            Version.Feature(.init(
                "Initial Release",
                comment: "ActionPlaygroundsApp (Feature in version 0.1.0)"
            ), description: .init(
                "The first release of the Action Playgrounds app.",
                comment: "ActionPlaygroundsApp (Description of feature in version 0.1.0)"
            ), icon: .partyPopper)
        }
    }
    // swiftlint:enable no_magic_numbers
    /// The default tempaltes.
    @Published var templates: [Template] = []

    /// The initializer.
    init() {
        getTemplates()
        if let data = UserDefaults.standard.data(forKey: "functions"),
           let functions = try? JSONDecoder().decode([CodableFunction<ActionInformation>].self, from: data) {
            ActionInformation.additionalFunctions = functions
        }
        getContributors()
    }

    /// Get the templates.
    private func getTemplates() {
        let templates: [(String, SFSymbol)] = [
            ("Hello World", .globe),
            ("Add Numbers", .number),
            ("Kilometers to Miles", .sailboat),
            ("Celcius to Fahrenheit", .thermometerSun),
            ("Is Number Positive, Negative or 0", .equal),
            ("Find Largest Number", .greaterthan),
            ("Selection", .arrowTriangleBranch)
        ]
        for template in templates {
            if let template = getTemplate(filename: template.0, icon: template.1) {
                self.templates.append(template)
            }
        }
    }

    /// Get a template by searching for a file in the app's bundle.
    /// - Parameters:
    ///   - filename: The file name without the extension ".actionplayground".
    ///   - icon: The template's icon.
    /// - Returns: The template.
    private func getTemplate(filename: String, icon: SFSymbol) -> Template? {
        if let url = Bundle.main.url(
            forResource: filename,
            withExtension: "actionplayground",
            subdirectory: "Examples"
        ),
           let data = try? Data(contentsOf: url) {
            return .init(title: filename, icon: icon, content: data)
        }
        return nil
    }

    /// Get the contributors from the Contributors.md file.
    private func getContributors() {
        let regex = /- \[(?<name>.+?)]\((?<link>.+?)\)/
        do {
            if let path = Bundle.main.path(forResource: "Contributors", ofType: "md") {
                let lines: [String] = try String(contentsOfFile: path).components(separatedBy: "\n")
                for line in lines where line.hasPrefix("- ") {
                    if let result = try? regex.wholeMatch(in: line), let url = URL(string: .init(result.output.link)) {
                        contributors.append((.init(result.output.name), url))
                    }
                }
            }
        } catch { }
    }

}
