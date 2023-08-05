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
        typealias Output = Swift.InterfaceType
        var url: URL
        var syntax: StructDeclSyntax
        var propertiesExtractor: PropertiesExtractor
        var functionsExtractor: FunctionsExtractor
        
        required init(syntax: StructDeclSyntax, url: URL) {
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
                type: .struct,
                access: .none,
                functions: functionsExtractor.parse() ?? [],
                attributes: propertiesExtractor.parse() ?? [],
                comment: CommentExtractor(syntax: syntax, url: url)?.parse(),
                declarationSyntax: .structs(syntax)
            )
        }
    }
}
