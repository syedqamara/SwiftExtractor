//
//  File.swift
//  SwiftExtractor
//
//  Created by Qammar Abbas on 25/04/2025.
//

import Foundation
import SwiftExtractor

protocol SwiftAutoTestableProviderProtocol {
    func autoTestable(identifier: String) async throws -> [Swift]
}

struct SwiftAutoTestableProvider: SwiftAutoTestableProviderProtocol {
    var swiftFileProvider: SwiftFileProviderProtocol
    var fileManager: FileLoaderProtocol
    var swiftParser: SwiftCodeParserProtocol
    let swiftTypeStorage: SwiftTypeStorageProtocol
    init(
        swiftFileProvider: SwiftFileProviderProtocol = SwiftFileProvider(),
        fileManager: FileLoaderProtocol = FileLoader(),
        swiftParser: SwiftCodeParserProtocol,
        swiftTypeStorage: SwiftTypeStorageProtocol,
    ) {
        self.swiftFileProvider = swiftFileProvider
        self.fileManager = fileManager
        self.swiftParser = swiftParser
        self.swiftTypeStorage = swiftTypeStorage
    }
    func autoTestable(identifier: String) async throws -> [Swift] {
        let allSwiftFiles = try await swiftFileProvider.listAllSwiftFiles()

        let allSwiftCode = try await Task.detached(priority: .high) { [allSwiftFiles] in
            try await withThrowingTaskGroup(of: [Swift].self) { group in
                for file in allSwiftFiles {
                    group.addTask {
                        let content = try await fileManager.loadFile(at: file)
                        return await swiftParser.parse(code: content, url: file)
                    }
                }

                var allParsed: [Swift] = []
                for try await parsed in group {
                    if identifier.isEmpty {
                        let isAutoTestable = parsed.filter { $0.isAutoTestable }
                        allParsed.append(contentsOf: isAutoTestable)
                    } else {
                        let isAutoTestable = parsed.filter { $0.isAutoTestable(identifier: identifier) }
                        allParsed.append(contentsOf: isAutoTestable)
                    }
                }
                return allParsed
            }
        }.value

        return allSwiftCode
    }
}

extension Swift {
    var isAutoTestable: Bool {
        isAutoTestable(identifier: "autotestable")
    }
    func isAutoTestable(identifier: String) -> Bool {
        let isInheritFromAutoTestable = self.inheritances.filter({ $0.name.lowercased() == identifier }).count == 1
        let isConformsToAutoTestable = self.conformance.filter({ $0.name.lowercased() == identifier }).count == 1
        return isInheritFromAutoTestable || isConformsToAutoTestable
    }
}
