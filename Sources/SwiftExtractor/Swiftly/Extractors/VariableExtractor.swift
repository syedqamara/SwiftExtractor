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
    class VariableExtractor: SourceCodeParsable {
        typealias Input = VariableDeclSyntax
        typealias Output = Swift.Variable
        var url: URL
        var syntax: VariableDeclSyntax
        var nameExtractor: PropertyNameExtractor
        var typeExtractor: PropertyTypeExtractor
        var accessExtractor: PropertyAccessModifierExtractor
        required init?(syntax: VariableDeclSyntax, url: URL) {
            self.url = url
            guard let nameSyntax = syntax.bindings.first?.pattern.as(IdentifierPatternSyntax.self) else {return nil}
            self.syntax = syntax
            self.nameExtractor = .init(syntax: nameSyntax, url: url)
            self.typeExtractor = .init(syntax: syntax, url: url)
            self.accessExtractor = .init(syntax: syntax, url: url)
        }
        func parse() -> Swift.Variable? {
            guard let name = getName(),
                  let type = getType(),
                  let accessModifier = getAccessModifier() else { return nil }
            return Swift.Variable(
                url: url,
                declarationType: letOrVar(),
                name: name,
                kind: type,
                accessModifier: accessModifier,
                wrapper: nil,
                isOptional: getIsOptional(),
                declatationSyntax: syntax,
                comment: CommentExtractor(syntax: syntax, url: url)?.parse()
            )
        }
        private func getName() -> String? {
            nameExtractor.parse()
        }
        private func letOrVar() -> Swift.PropertyDeclarationType {
            return .init(rawValue: syntax.letOrVarKeyword.description)
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
    class VariablesExtractor: SourceCodeParsable {
        typealias Input = MemberDeclListSyntax
        typealias Output = [Swift.Variable]
        var url: URL
        var syntax: MemberDeclListSyntax
        var propertyExtractors: [VariableExtractor]
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
        func parse() -> [Swift.Variable]? {
            return propertyExtractors.map { $0.parse() }.compactMap { $0 }
        }
    }
}
extension SwiftExtractor.VariableExtractor {
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
        typealias Input = VariableDeclSyntax
        typealias Output = Swift.PropertyType
        var url: URL
        var syntax: VariableDeclSyntax
        required init(syntax: VariableDeclSyntax, url: URL) {
            self.url = url
            self.syntax = syntax
        }
        func parse() -> Swift.PropertyType? {
            
            var propertyType = Swift.PropertyType(
                url: url,
                name: "",
                constraint: .none,
                comment: CommentExtractor(syntax: syntax, url: url)?.parse(),
                isOptional: syntax.isOptional
            )
            
            if let type = syntax.bindings.first?.typeAnnotation?.type, let typeName = parseSimplePropertyTypeName(syntax: type) {
                propertyType.name = typeName
                propertyType.constraint = parsePropertyConstraints(syntax: type)
            }
            else {
                if let binding = syntax.bindings.first as? ExprSyntaxProtocol {
                    switch binding {
                    case let type as IntegerLiteralExprSyntax:
                        propertyType.name = type.kind.nameForDiagnostics ?? "Unknown_Type"
                        propertyType.name = type.digits.text
                    case let type as StringLiteralExprSyntax:
                        propertyType.name = type.kind.nameForDiagnostics ?? "Unknown_Type"
                        propertyType.name = type.segments.description
                    case let type as NilLiteralExprSyntax:
                        propertyType.name = type.kind.nameForDiagnostics ?? "Unknown_Type"
                        propertyType.name = type.nilKeyword.text
                    case let type as FloatLiteralExprSyntax:
                        propertyType.name = type.kind.nameForDiagnostics ?? "Unknown_Type"
                        propertyType.name = type.floatingDigits.text
                    case let type as BooleanLiteralExprSyntax:
                        propertyType.name = type.kind.nameForDiagnostics ?? "Unknown_Type"
                        propertyType.name = type.booleanLiteral.text
                    case let type as RegexLiteralExprSyntax:
                        propertyType.name = type.kind.nameForDiagnostics ?? "Unknown_Type"
                        propertyType.name = type.regex.text
                    default:
                        // Handle other cases
                        break
                    }
                }

            }
            
            return nil
        }
        private func parseSimplePropertyTypeName(syntax: TypeSyntax) -> String? {
            if let sugarType = syntax.as(ConstrainedSugarTypeSyntax.self) {
                if let type = sugarType.baseType.as(SimpleTypeIdentifierSyntax.self) {
                    return type.name.text
                }
            }
            else if let type = syntax.as(SimpleTypeIdentifierSyntax.self) {
                return type.name.text
            }
            return syntax.description
        }
        private func parsePropertyConstraints(syntax: TypeSyntax) -> Swift.PropertyType.Constraint {
            guard let sugarType = syntax.as(ConstrainedSugarTypeSyntax.self) else { return .none }
            guard let constraint = Swift.PropertyType.Constraint(rawValue: sugarType.someOrAnySpecifier.text) else { return .none }
            return constraint
        }
    }
    class ParameterTypeExtractor: SourceCodeParsable {
        typealias Input = TypeSyntax
        typealias Output = Swift.PropertyType
        var url: URL
        var syntax: TypeSyntax
        required init(syntax: TypeSyntax, url: URL) {
            self.url = url
            self.syntax = syntax
        }
        func parse() -> Swift.PropertyType? {
            var propertyType = Swift.PropertyType(
                url: url,
                name: "",
                constraint: .none,
                comment: CommentExtractor(syntax: syntax, url: url)?.parse(),
                isOptional: false
            )
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
