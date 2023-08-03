//
//  VariableExtractor.swift
//  Architecture
//
//  Created by Syed Qamar Abbas on 01/07/2023.
//

import SwiftSyntax
import Foundation
import core_architecture



extension SwiftExtractor {
    class PropertyExtractor: SourceCodeParsable {
        typealias Input = VariableDeclSyntax
        typealias Output = Swift.Property
        var url: URL
        var syntax: VariableDeclSyntax
        var nameExtractor: PropertyNameExtractor
        var typeExtractor: PropertyTypeExtractor
        var accessExtractor: PropertyAccessModifierExtractor
        required init?(syntax: VariableDeclSyntax, url: URL) {
            self.url = url
            guard let type = syntax.bindings.first?.typeAnnotation?.type else  { return nil }
            guard let nameSyntax = syntax.bindings.first?.pattern.as(IdentifierPatternSyntax.self) else {return nil}
            self.syntax = syntax
            self.nameExtractor = .init(syntax: nameSyntax, url: url)
            self.typeExtractor = .init(syntax: type, url: url)
            self.accessExtractor = .init(syntax: syntax, url: url)
        }
        func parse() -> Swift.Property? {
            guard let name = getName(),
                  let type = getType(),
                  let accessModifier = getAccessModifier() else { return nil }
            return Swift.Property(
                url: url,
                name: name,
                kind: type,
                accessModifier: accessModifier,
                wrapper: nil,
                isOptional: getIsOptional(), declatationSyntax: syntax
            )
        }
        private func getName() -> String? {
            nameExtractor.parse()
        }
        private func getType() -> Swift.PropertyType? {
            typeExtractor.parse()
        }
        private func getAccessModifier() -> Swift.AccessModifiers? {
            accessExtractor.parse()
        }
        private func getIsOptional() -> Bool {
            syntax.isOptional
        }
    }
    class PropertiesExtractor: SourceCodeParsable {
        typealias Input = MemberDeclListSyntax
        typealias Output = [Swift.Property]
        var url: URL
        var syntax: MemberDeclListSyntax
        var propertyExtractors: [PropertyExtractor]
        required init(syntax: MemberDeclListSyntax, url: URL) {
            self.url = url
            self.syntax = syntax
            propertyExtractors = syntax.map { synt in
                if let variableDecl = synt.decl.as(VariableDeclSyntax.self) {
                    return .init(syntax: variableDecl, url: url)
                }
                return nil
            }.compactMap { $0 }
        }
        func parse() -> [Swift.Property]? {
            return propertyExtractors.map { $0.parse() }.compactMap { $0 }
        }
    }
}
//import SwiftSyntax
//
//class VariableInfoExtractor {
//    var variableInfo: (name: String, type: String)?
//
//    func visit(_ node: VariableDeclSyntax) {
//        if let variable = node.bindings.first,
//           let variableName = variable.pattern.as(IdentifierPatternSyntax.self)?.identifier.text,
//           let type = variable.initializer?.value.as(IntegerLiteralExprSyntax.self) {
//            type.description
////                let typeName = type.description.trimmingCharacters(in: .whitespacesAndNewlines)
////                variableInfo = (name: variableName, type: typeName)
//            }
//        }
//    }
//}
extension SwiftExtractor.PropertyExtractor {
    class PropertyNameExtractor: SourceCodeParsable {
        typealias Input = IdentifierPatternSyntax
        typealias Output = String
        var url: URL
        var syntax: IdentifierPatternSyntax
        func parse() -> String? {
            return syntax.identifier.text
        }
        required init(syntax: IdentifierPatternSyntax, url: URL) {
            self.url = url
            self.syntax = syntax
        }
    }
    class PropertyTypeExtractor: SourceCodeParsable {
        typealias Input = TypeSyntax
        typealias Output = Swift.PropertyType
        var url: URL
        var syntax: TypeSyntax
        required init(syntax: TypeSyntax, url: URL) {
            self.url = url
            self.syntax = syntax
        }
        func parse() -> Swift.PropertyType? {
            var propertyType = Swift.PropertyType(url: url, name: "", constraint: .none, isOptional: false)
            if let sugarType = syntax.as(ConstrainedSugarTypeSyntax.self) {
                if let type = sugarType.baseType.as(SimpleTypeIdentifierSyntax.self) {
                    propertyType.name(type.name.text)
                }
                if let constraint = Swift.PropertyType.Constraint(rawValue: sugarType.someOrAnySpecifier.text) {
                    propertyType.constraint(constraint)
                }
            }
            else if let type = syntax.as(SimpleTypeIdentifierSyntax.self) {
                propertyType.name(type.name.text)
            }
            else {
                propertyType.name(syntax.description)
            }
            return propertyType.name.isEmpty ? nil : propertyType
        }
    }
    class PropertyAccessModifierExtractor: SourceCodeParsable {
        typealias Output = Swift.AccessModifiers
        typealias Input = VariableDeclSyntax
        var url: URL
        var syntax: VariableDeclSyntax
        func parse() -> Swift.AccessModifiers? {
            let access = syntax.modifiers?.first(where: { $0.name.tokenKind.isAccessModifier })?.name.text ?? "internal"
            return .init(rawValue: access)
        }
        required init(syntax: VariableDeclSyntax, url: URL) {
            self.url = url
            self.syntax = syntax
        }
    }
}



