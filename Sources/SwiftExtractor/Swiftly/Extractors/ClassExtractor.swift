//
//  ClassExtractor.swift
//  Architecture
//
//  Created by Syed Qamar Abbas on 02/07/2023.
//

import SwiftSyntax
import Foundation
import core_architecture
extension SwiftExtractor {
    class ClassExtractor: SourceCodeParsable {
        typealias Input = ClassDeclSyntax
        typealias Output = Swift.InterfaceType
        var url: URL
        var syntax: ClassDeclSyntax
        var propertiesExtractor: PropertiesExtractor
        var genericParameterExtractor: GenericParamterExtractor? = nil
        var functionsExtractor: FunctionsExtractor
        
        required init?(syntax: ClassDeclSyntax, url: URL) {
            self.url = url
            self.syntax = syntax
            let members = syntax.members.members
            propertiesExtractor = .init(syntax: members, url: url)
            functionsExtractor = .init(syntax: members, url: url)
            if let generics = syntax.genericParameterClause {
                genericParameterExtractor = .init(syntax: generics, url: url)
            }
        }
        private var generics: [Swift.Generic] {
            guard let genericParameter = genericParameterExtractor?.parse() else { return [] }
            return genericParameter
        }
        func parse() -> Output? {
            return .init(
                url: url,
                name: syntax.identifier.text,
                type: .class,
                access: .none,
                functions: functionsExtractor.parse() ?? [],
                attributes: propertiesExtractor.parse() ?? [],
                declarationSyntax: .classes(syntax),
                generics: generics
            )
        }
    }
}
