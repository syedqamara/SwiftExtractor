//
//  File.swift
//  
//
//  Created by Apple on 03/08/2023.
//

import Foundation
import SwiftSyntax
import core_architecture

extension SwiftExtractor {
    class GenericParamterExtractor: SourceCodeParsable {
        typealias Input = GenericParameterClauseSyntax
        typealias Output = [Generic]
        
        var url: URL
        var syntax: SwiftSyntax.GenericParameterClauseSyntax
        
        func parse() -> [Generic]? {
            guard !syntax.genericParameterList.isEmpty else { return nil }
            var generics: [Generic] = []
            for param in syntax.genericParameterList {
                var gen = Generic(url: url, name: param.name.text)
                if let type = param.inheritedType?.as(SimpleTypeIdentifierSyntax.self) {
                    gen.type = type.name.text
                }
                generics.append(gen)
            }
            return generics
        }
        required init?(syntax: SwiftSyntax.GenericParameterClauseSyntax, url: URL) {
            self.url = url
            self.syntax = syntax
        }
        
    }
}
