//
//  File.swift
//  SwiftExtractor
//
//  Created by Qammar Abbas on 25/04/2025.
//

import Foundation
import SwiftExtractor

@main struct AutoTest {
    static func main() async throws {
        let typeStorage = SwiftTypeStorage()
        let codeParser = SwiftCodeParser(swiftTypeStorage: typeStorage)
        let autoTestableProvider = SwiftAutoTestableProvider(swiftParser: codeParser, swiftTypeStorage: typeStorage)
        let viewModel = AutoTestableListViewModel(swiftAutoTestableProvider: autoTestableProvider)
        let view = AutoTestableListView(viewModel: viewModel)
        do {
            try await view.render(separator: "\n")
        }
        catch let error {
            print("|=====| Auto Test Failure Start |=====|")
            print(error.localizedDescription)
            print("|=====| Auto Test Failure End   |=====|")
        }
    }
}
