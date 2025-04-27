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
        typealias Output = InterfaceType
        var url: URL
        var syntax: ClassDeclSyntax
        var propertiesExtractor: VariablesExtractor
        var genericParameterExtractor: GenericParamterExtractor? = nil
        var functionsExtractor: FunctionsExtractor
        var parentClassNameExtractor: ParentClassNameExtractor
        var classProtocolConformanceExtractor: ProtocolConformanceNameExtractor<ClassDeclSyntax>
        var swiftTypeStorage: SwiftTypeStorageProtocol! {
            didSet {
                classProtocolConformanceExtractor.swiftTypeStorage = swiftTypeStorage
            }
        }
        required init?(syntax: ClassDeclSyntax, url: URL) {
            if let generics = syntax.genericParameterClause {
                genericParameterExtractor = .init(syntax: generics, url: url)
            }
            self.url = url
            self.syntax = syntax
            let members = syntax.members.members
            propertiesExtractor = .init(syntax: members, url: url)
            functionsExtractor = .init(syntax: members, url: url)
            parentClassNameExtractor = .init(syntax: syntax, url: url)!
            classProtocolConformanceExtractor = .init(syntax: syntax, url: url)!
        }
        private var generics: [Generic] {
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
                comment: CommentExtractor(syntax: syntax, url: url)?.parse(),
                declarationSyntax: .classes(syntax),
                generics: generics
            )
        }
        func parentClasses() -> [SwiftClassInheritance] {
            let parent = parentClassNameExtractor.parse() ?? []
            let parentClasses = parent.map { SwiftClassInheritance(url: self.url, comment: CommentExtractor(syntax: syntax, url: url)?.parse(), name: $0) }
            return parentClasses
        }
        func conformances() -> [SwiftProtocolConformance] {
            classProtocolConformanceExtractor.parse() ?? []
        }
    }
}
