//
//  SwiftFileProvider.swift
//  SwiftExtractor
//
//  Created by Qammar Abbas on 25/04/2025.
//

import Foundation

protocol SwiftFileProviderProtocol {
    func listAllSwiftFiles() async throws -> [URL]
}

/// Provides URLs to all `.swift` files under a given root directory.
struct SwiftFileProvider: SwiftFileProviderProtocol {
    let rootDirectory: URL
    let fileManager: FileManager

    init(rootDirectory: URL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath),
         fileManager: FileManager = .default) {
        self.rootDirectory = rootDirectory
        self.fileManager = fileManager
    }

    /// Returns a list of all `.swift` file URLs under the root directory and its subdirectories.
    func listAllSwiftFiles() async throws -> [URL] {
        return try await findSwiftFiles(at: rootDirectory)
    }

    private func findSwiftFiles(at url: URL) async throws -> [URL] {
        var swiftFiles = [URL]()
        let contents = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])

        for file in contents {
            var isDirectory: ObjCBool = false
            if fileManager.fileExists(atPath: file.path, isDirectory: &isDirectory) {
                if isDirectory.boolValue {
                    swiftFiles += try await findSwiftFiles(at: file)
                } else if file.pathExtension == "swift" {
                    swiftFiles.append(file)
                }
            }
        }

        return swiftFiles
    }
}
