//
//  File.swift
//  
//
//  Created by Apple on 03/08/2023.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxParser

/// A parser for Swift code that extracts code entities and their properties and methods.
public class SwiftCodeParser {
    private let queue: DispatchQueue
    
    /// Initializes the SwiftCodeParser instance.
    init() {
        queue = DispatchQueue(label: "com.example.SwiftCodeParser", attributes: .concurrent)
    }
    
    /// Parses the given code and asynchronously returns an array of CodeEntity objects.
    ///
    /// - Parameters:
    ///   - code: The Swift code to parse.
    ///   - completion: The completion closure that will be called with the parsed code entities.
    private func parse(code: String, url: URL, completion: @escaping ([Swift]) -> Void) {
        queue.async {
            let model = self.parseModel(code: code, url: url)
            completion(model)
        }
    }
    /// Parses the given Swift code and asynchronously returns an array of CodeEntity objects.
    ///
    /// - Parameters:
    ///   - code: The Swift code to parse.
    /// - Returns: An array of CodeEntity objects representing the parsed code entities.
    ///
    /// The `parse` function asynchronously parses the provided Swift code and returns an array of CodeEntity objects
    /// representing the parsed code entities such as structs, classes, protocols, or enums.
    ///
    /// Example usage:
    ///
    /// ```swift
    /// let code = """
    /// struct Person {
    ///     var name: String
    ///     var age: Int
    /// }
    /// """
    ///
    /// async {
    ///     let parsedEntities = await parse(code: code)
    ///     // Handle the parsed entities
    /// }()
    /// ```
    func parse(code: String, url: URL) async -> [Swift] {
        return await withCheckedContinuation { continuation in
            queue.async {
                let model = self.parseModel(code: code, url: url)
                continuation.resume(returning: model)
            }
        }
    }
    
    /// Parses the given code and returns an array of CodeEntity objects.
    ///
    /// - Parameter code: The Swift code to parse.
    /// - Returns: An array of CodeEntity objects representing the parsed code entities.
    private func parseModel(code: String, url: URL) -> [Swift] {
        do {
            let sourceFile = try SyntaxParser.parse(source: code)
            let allEntities = sourceFile.statements.flatMap {
                statement in
                let visitor = SwiftVisitor(viewMode: .all, url: url)
                _ = visitor.visit(statement)
                return visitor.entities
            }
            return allEntities
        }
        catch let err {
            print("Parsing Error: \(err)")
            return []
        }
    }
}
