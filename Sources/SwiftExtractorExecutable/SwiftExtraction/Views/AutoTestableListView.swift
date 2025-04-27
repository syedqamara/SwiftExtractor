//
//  File.swift
//  SwiftExtractor
//
//  Created by Qammar Abbas on 25/04/2025.
//

import Foundation
import SwiftExtractor

protocol AutoTestableListViewProtocol {
    func render(separator: String) async throws
}

struct AutoTestableListView: AutoTestableListViewProtocol {
    let viewModel: AutoTestableListViewModelProtocol
    init(viewModel: AutoTestableListViewModelProtocol) {
        self.viewModel = viewModel
    }
    func render(separator: String) async throws {
        let result = try await viewModel.render(separator: separator)
        print(result)
    }
}

protocol AutoTestableListViewModelProtocol {
    func render(separator: String) async throws -> String
}

struct AutoTestableListViewModel: AutoTestableListViewModelProtocol {
    let swiftAutoTestableProvider: SwiftAutoTestableProviderProtocol
    init(swiftAutoTestableProvider: SwiftAutoTestableProviderProtocol) {
        self.swiftAutoTestableProvider = swiftAutoTestableProvider
    }
    func render(separator: String) async throws -> String {
        let allTestableSwiftFiles = try await swiftAutoTestableProvider.autoTestable(identifier: "")
        let testableInfos = allTestableSwiftFiles.map { swift in
            swift.testableInfo()
        }
        return testableInfos.joined(separator: separator)
    }
}

extension Swift {
    func testableInfo() -> String {
        """
        
        |=||=||=||=||=||=||=||=||=||=||=||=||=||=||=||=|
        |=| File \(self.name) |=|
        |=| \(self.reference.type.rawValue.firstCapital) \(self.reference.name) |=|
        |=|\(appliance())|=|
        |=||=||=||=||=||=||=||=||=||=||=||=||=||=||=||=|
        
        """
    }
    func appliance() -> String {
        if inheritanceName().isNotEmpty {
            return inheritanceName() + "\n" + conformanceName()
        }
        return conformanceName()
    }
    
    private func inheritanceName() -> String {
        guard inheritances.isNotEmpty else { return "" }
        let title = inheritances.map { $0.name }.joined(separator: ",")
        return "|=| Inherited by \(title) |=|"
    }
    private func conformanceName() -> String {
        guard conformance.isNotEmpty else { return "" }
        let title = conformance.map { $0.name }.joined(separator: ",")
        return "|=| Conformance \(title) |=|"
    }
}



extension String {
    var firstCapital: String {
        self.reduce(into: "") { partialResult, char in
            if partialResult.isEmpty {
                partialResult = String(char).capitalized
            } else {
                partialResult += String(char).lowercased()
            }
        }
    }
}
