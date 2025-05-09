//
//  ProtocolExtractor.swift
//  Architecture
//
//  Created by Syed Qamar Abbas on 02/07/2023.
//

import SwiftSyntax
import Foundation
import core_architecture

extension SwiftExtractor {
    class ProtocolExtractor: SourceCodeParsable {
        typealias Input = ProtocolDeclSyntax
        typealias Output = InterfaceType
        var url: URL
        var syntax: ProtocolDeclSyntax
        var propertiesExtractor: VariablesExtractor
        var functionsExtractor: FunctionsExtractor
        var swiftTypeStorage: SwiftTypeStorageProtocol! {
            didSet {
                protocolConformanceExtractor.swiftTypeStorage = swiftTypeStorage
            }
        }
        var protocolConformanceExtractor: ProtocolConformanceNameExtractor<ProtocolDeclSyntax>
        required init(syntax: ProtocolDeclSyntax, url: URL) {
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
                type: .protocol,
                access: .none,
                functions: functionsExtractor.parse() ?? [],
                attributes: propertiesExtractor.parse() ?? [],
                comment: CommentExtractor(syntax: syntax, url: url)?.parse(),
                declarationSyntax: .protocols(syntax),
                generics: []
            )
        }
        func conformances() -> [SwiftProtocolConformance] {
            protocolConformanceExtractor.parse() ?? []
        }
    }
}
