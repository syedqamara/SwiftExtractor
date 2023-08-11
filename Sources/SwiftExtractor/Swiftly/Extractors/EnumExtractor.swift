//
//  EnumExtractor.swift
//  Architecture
//
//  Created by Syed Qamar Abbas on 02/07/2023.
//

import SwiftSyntax
import Foundation
import core_architecture

extension SwiftExtractor {
    class EnumExtractor: SourceCodeParsable {
        typealias Input = EnumDeclSyntax
        typealias Output = InterfaceType
        var url: URL
        var syntax: EnumDeclSyntax
        var propertiesExtractor: VariablesExtractor
        var genericParameterExtractor: GenericParamterExtractor? = nil
        var functionsExtractor: FunctionsExtractor
        
        required init?(syntax: EnumDeclSyntax, url: URL) {
            self.url = url
            self.syntax = syntax
            let members = syntax.members.members
            propertiesExtractor = .init(syntax: members, url: url)
            functionsExtractor = .init(syntax: members, url: url)
            if let generics = syntax.genericParameters {
                genericParameterExtractor = .init(syntax: generics, url: url)
            }
        }
        
        private var generics: [Generic] {
            guard let genericParameter = genericParameterExtractor?.parse() else { return [] }
            return genericParameter
        }
        func parse() -> Output? {
            return .init(
                url: url,
                name: syntax.identifier.text,
                type: .enum,
                access: .none,
                functions: functionsExtractor.parse() ?? [],
                attributes: propertiesExtractor.parse() ?? [],
                comment: CommentExtractor(syntax: syntax, url: url)?.parse(),
                declarationSyntax: .enums(syntax),
                generics: generics
            )
        }
    }
}
