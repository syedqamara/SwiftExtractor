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

extension SwiftExtractor {
    final class ParentClassNameExtractor: SourceCodeParsable {
        typealias Input = ClassDeclSyntax
        typealias Output = [String]

        var syntax: ClassDeclSyntax
        var url: URL

        required init?(syntax: ClassDeclSyntax, url: URL) {
            self.syntax = syntax
            self.url = url
        }

        func parse() -> [String]? {
            // Get the direct parent name
            guard let baseType = syntax.inheritanceClause?
                    .inheritedTypeCollection.first?
                    .typeName
                    .description
                    .trimmingCharacters(in: .whitespacesAndNewlines)
            else {
                return nil
            }

            var parentNames: [String] = []
            var currentParentName: String? = baseType

            while let name = currentParentName {
                parentNames.append(name)

                // Try to find the class with this name in the same file
                guard let sourceFile = syntax.root as? SourceFileSyntax else { break }

                let finder = ClassDeclarationFinder(targetName: name)
                finder.walk(sourceFile)

                guard let parentSyntax = finder.foundClassSyntax,
                      let nextParent = parentSyntax.inheritanceClause?
                        .inheritedTypeCollection.first?
                        .typeName
                        .description
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                else {
                    break
                }

                currentParentName = nextParent
            }

            return parentNames
        }
    }
}
fileprivate class ClassDeclarationFinder: SyntaxVisitor {
    let targetName: String
    var foundClassSyntax: ClassDeclSyntax?

    init(targetName: String) {
        self.targetName = targetName
        super.init(viewMode: .all)
    }

    override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        if node.identifier.text == targetName {
            foundClassSyntax = node
            return .skipChildren
        }
        return .visitChildren
    }
}
