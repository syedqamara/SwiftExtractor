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
        typealias Output = Swift.InterfaceType
        var url: URL
        var syntax: ProtocolDeclSyntax
        var propertiesExtractor: PropertiesExtractor
        var functionsExtractor: FunctionsExtractor
        
        required init(syntax: ProtocolDeclSyntax, url: URL) {
            self.url = url
            self.syntax = syntax
            let members = syntax.members.members
            propertiesExtractor = .init(syntax: members, url: url)
            functionsExtractor = .init(syntax: members, url: url)
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
                declarationSyntax: .protocols(syntax)
            )
        }
    }
}
