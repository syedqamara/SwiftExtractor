//
//  StructureExtractor.swift
//  Architecture
//
//  Created by Syed Qamar Abbas on 02/07/2023.
//

import SwiftSyntax
import Foundation
import core_architecture

extension SwiftExtractor {
    class StructureExtractor: SourceCodeParsable {
        typealias Input = StructDeclSyntax
        typealias Output = InterfaceType
        var url: URL
        var syntax: StructDeclSyntax
        var propertiesExtractor: VariablesExtractor
        var functionsExtractor: FunctionsExtractor
        var swiftTypeStorage: SwiftTypeStorageProtocol! {
            didSet {
                protocolConformanceExtractor.swiftTypeStorage = swiftTypeStorage
            }
        }
        var protocolConformanceExtractor: ProtocolConformanceNameExtractor<StructDeclSyntax>
        required init(syntax: StructDeclSyntax, url: URL) {
            self.url = url
            self.syntax = syntax
            let members = syntax.members.members
            propertiesExtractor = .init(syntax: members, url: url)
            functionsExtractor = .init(syntax: members, url: url)
            protocolConformanceExtractor = .init(syntax: syntax, url: url)!
        }
        func parse() -> Output? {
            return .init(
                url: url,
                name: syntax.identifier.text,
                type: .struct,
                access: .none,
                functions: functionsExtractor.parse() ?? [],
                attributes: propertiesExtractor.parse() ?? [],
                comment: CommentExtractor(syntax: syntax, url: url)?.parse(),
                declarationSyntax: .structs(syntax),
                generics: []
            )
        }
        func conformances() -> [SwiftProtocolConformance] {
            protocolConformanceExtractor.parse() ?? []
        }
    }
}
