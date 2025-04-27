//
//  File.swift
//  
//
//  Created by Apple on 03/08/2023.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxParser

public protocol SwiftCodeParserProtocol {
    func parse(code: String, url: URL) async -> [Swift]
}

/// A parser for Swift code that extracts code entities and their properties and methods.
public final class SwiftCodeParser: Sendable, SwiftCodeParserProtocol {
    
    private let swiftTypeStorage: SwiftTypeStorageProtocol
    
    public init(swiftTypeStorage: SwiftTypeStorageProtocol) {
        self.swiftTypeStorage = swiftTypeStorage
    }

    /// Parses the given Swift code and asynchronously returns an array of CodeEntity objects.
    ///
    /// - Parameters:
    ///   - code: The Swift code to parse.
    ///   - url: The URL representing the file (for contextual reference).
    /// - Returns: An array of Swift entities (e.g., classes, structs, etc.)
    public func parse(code: String, url: URL) async -> [Swift] {
        await Task.detached(priority: .utility) {
            self.parseModel(code: code, url: url)
        }.value
    }
    
    /// Internal function to parse and extract entities from code.
    private func parseModel(code: String, url: URL) -> [Swift] {
        do {
            let sourceFile = try SyntaxParser.parse(source: code)
            let allEntities = sourceFile.statements.flatMap { [swiftTypeStorage, sourceFile] statement -> [Swift] in
                let visitor = SwiftVisitor(viewMode: .all, url: url, swiftTypeStorage: swiftTypeStorage, sourceFileSyntax: sourceFile)
                _ = visitor.visit(statement)
                return visitor.entities
            }
            return allEntities
        } catch {
            print("🛑 Parsing Error: \(error)")
            return []
        }
    }
}
