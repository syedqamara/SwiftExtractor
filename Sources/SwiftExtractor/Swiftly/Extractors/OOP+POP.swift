//
//  File.swift
//  SwiftExtractor
//
//  Created by Qammar Abbas on 28/04/2025.
//

import Foundation
import SwiftSyntax
import core_architecture



extension SwiftExtractor {
    final class ProtocolConformanceNameExtractor<I: ProtocolConformanceSyntax>: SourceCodeParsable {
        typealias Input = I
        typealias Output = [SwiftProtocolConformance]

        var syntax: I
        var url: URL
        var swiftTypeStorage: SwiftTypeStorageProtocol!
        required init?(syntax: I, url: URL) {
            self.syntax = syntax
            self.url = url
        }
        
        func inheritanceNames() -> [String] {
            guard let inheritedTypes = syntax.inheritanceClause?.inheritedTypeCollection else {
                return []
            }
            let names = inheritedTypes.map { $0.typeName.description.trimmingCharacters(in: .whitespacesAndNewlines) }
            let types: [SwiftTypeAddress] = names.map { name in
                guard let type = swiftTypeStorage?.get(name: name) else { return nil }
                return type
            }.compactMap({ $0 })
            return types.map { "\($0.type.rawValue)" }
        }

        func parse() -> [SwiftProtocolConformance]? {
            guard let conformances = parseProtocolConformanceName() else { return nil }
            let parentClasses = conformances.map { SwiftProtocolConformance(url: self.url, comment: CommentExtractor(syntax: syntax, url: url)?.parse(), name: $0) }
            return parentClasses
        }
        
        private func parseProtocolConformanceName() -> [String]? {
            logs("Checking", syntax.identifier.text)
            logs("Conformance", inheritanceNames().joined(separator: ", "))
            
            guard let inheritedTypes = syntax.inheritanceClause?.inheritedTypeCollection else {
                return nil
            }
            // Collect protocols declared in the current file
            let result = inheritedTypes.compactMap { [swiftTypeStorage] inherited -> [String]? in
                let name = inherited.typeName.description.trimmingCharacters(in: .whitespacesAndNewlines)
                guard let type = swiftTypeStorage?.get(name: name) else { return nil }
                let collector = ProtocolCollector(viewMode: .all)
                collector.walk(type.sourceFileSyntax)
                return collector.protocols.contains(name) ? Array(collector.protocols) : nil
            }.flatMap { $0 }
            return result.isEmpty ? nil : result.sorted()
        }
    }
    fileprivate final class ProtocolCollector: SyntaxVisitor {
        var protocols: Set<String> = []

        override func visit(_ node: ProtocolDeclSyntax) -> SyntaxVisitorContinueKind {
            protocols.insert(node.identifier.text)
            return .skipChildren
        }
    }
}

public protocol ProtocolConformanceSyntax: SyntaxProtocol {
    var inheritanceClause: TypeInheritanceClauseSyntax? { get }
    var identifier: TokenSyntax { get }
}

extension ClassDeclSyntax: ProtocolConformanceSyntax {}
extension EnumDeclSyntax: ProtocolConformanceSyntax {}
extension StructDeclSyntax: ProtocolConformanceSyntax {}
extension ProtocolDeclSyntax: ProtocolConformanceSyntax {}


