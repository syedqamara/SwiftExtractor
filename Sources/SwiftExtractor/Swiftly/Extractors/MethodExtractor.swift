//
//  MethodExtractor.swift
//  Architecture
//
//  Created by Syed Qamar Abbas on 02/07/2023.
//

import SwiftSyntax
import Foundation
import core_architecture

extension SwiftExtractor {
    class FunctionExtractor: SourceCodeParsable {
        typealias Input = FunctionDeclSyntax
        typealias Output = Swift.Function
        var url: URL
        var syntax: FunctionDeclSyntax
        private var parameterExtractor: FunctionParametersExtractor
        private var returnTypeExtractor: FunctionReturnTypeExtractor?
        required init?(syntax: FunctionDeclSyntax, url: URL) {
            self.url = url
            self.syntax = syntax
            let signature = syntax.signature
            self.parameterExtractor = .init(syntax: signature, url: url)
            if let type = signature.output?.returnType {
                self.returnTypeExtractor = .init(syntax: type, url: url)
            }
        }
        func parse() -> Swift.Function? {
            let name = syntax.identifier.text
            guard let parameters = parameterExtractor.parse() else {return nil}
            let returnType = returnTypeExtractor?.parse()
            return .init(
                url: url,
                name: name,
                return: returnType,
                accessModifier: .internal,
                wrapper: nil,
                parameters: parameters, declatationSyntax: syntax
            )
        }
    }
    class FunctionParametersExtractor: SourceCodeParsable {
        typealias Input = FunctionSignatureSyntax
        typealias Output = [Swift.Function.Parameter]
        var url: URL
        var syntax: FunctionSignatureSyntax
        private var parameterExtractors: [FunctionParameterExtractor]
        required init(syntax: FunctionSignatureSyntax, url: URL) {
            self.url = url
            self.syntax = syntax
            let paramSyntax = syntax.input.parameterList
            self.parameterExtractors = paramSyntax.compactMap { .init(syntax: $0, url: url) }
        }
        func parse() -> [Swift.Function.Parameter]? {
            return parameterExtractors.map { $0.parse() }.compactMap { $0 }
        }
    }
    class FunctionParameterExtractor: SourceCodeParsable {
        typealias Input = FunctionParameterListSyntax.Element
        typealias Output = Swift.Function.Parameter
        
        var url: URL
        var syntax: FunctionParameterListSyntax.Element
        private var propertyTypeExtractor: SwiftExtractor.PropertyExtractor.PropertyTypeExtractor?
        required init?(syntax: SwiftSyntax.FunctionParameterListSyntax.Element, url: URL) {
            self.url = url
            guard let type = syntax.type else {return nil}
            self.syntax = syntax
            self.propertyTypeExtractor = .init(syntax: type, url: url)
        }
        func parse() -> Swift.Function.Parameter? {
            guard let type = propertyTypeExtractor?.parse() else {return nil}
            guard let firstName = syntax.firstName else { return nil }
            let secondName = syntax.secondName?.text
            let parameterName = firstName.text
            
            return .init(
                url: url,
                name: parameterName,
                property: Swift.Property(
                    url: url,
                    name: secondName ?? parameterName,
                    kind: type,
                    accessModifier: .none,
                    wrapper: nil,
                    isOptional: type.isOptional, declatationSyntax: syntax
                )
            )
        }
    }
    class FunctionReturnTypeExtractor: SourceCodeParsable {
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
            if let type = syntax.as(SimpleTypeIdentifierSyntax.self) {
                propertyType.name(type.name.text)
            }
            return propertyType.name.isEmpty ? nil : propertyType
        }
    }
    class FunctionsExtractor: SourceCodeParsable {
        typealias Input = MemberDeclListSyntax
        typealias Output = [Swift.Function]
        var url: URL
        var syntax: MemberDeclListSyntax
        var propertyExtractors: [FunctionExtractor]
        required init(syntax: MemberDeclListSyntax, url: URL) {
            self.url = url
            self.syntax = syntax
            propertyExtractors = syntax.map { synt in
                if let variableDecl = synt.decl.as(FunctionDeclSyntax.self) {
                    return .init(syntax: variableDecl, url: url)
                }
                return nil
            }.compactMap { $0 }
        }
        func parse() -> [Swift.Function]? {
            return propertyExtractors.map { $0.parse() }.compactMap { $0 }
        }
    }
}


