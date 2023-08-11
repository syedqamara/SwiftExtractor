//
//  Variable.swift
//  
//
//  Created by Apple on 11/08/2023.
//

import Foundation
import SwiftSyntax

public struct PropertyType: Sourcable {
    public var url: URL
    public var name: String // The name of the DataType
    public var constraint: Constraint // The name of the DataType
    public var comment: CodeCommenting?
    public var isOptional: Bool // The isOptional of the DataType
    
    public mutating func name(_ name: String) {
        self.name = name
    }
    public mutating func constraint(_ constraint: Constraint) {
        self.constraint = constraint
    }
    public mutating func isOptional(_ isOptional: Bool) {
        self.isOptional = isOptional
    }
}
public struct Wrapper: Wrappable {
    public var url: URL
    public var name: String
    public var kind: PropertyType
    public var _kind: PropertyType
    public var _$kind: PropertyType
}
public enum PropertyDeclarationType: String, Types {
case `let`, `var`
    
    public init(rawValue: String) {
        switch rawValue {
        case "let":
            self = .let
        case "var":
            self = .var
        default:
            self = .let
        }
    }
    public var rawValue: String {
        switch self {
        case .let:
            return "let"
        case .var:
            return "var"
        }
    }
}
public struct Variable: Attributes {
    public typealias _PropertyType_ = PropertyType
    public typealias _WrapperType_ = Wrapper
    public typealias _ModifierType_ = AccessModifiers
    public var url: URL
    public var declarationType: PropertyDeclarationType // Whether variable is defined by let or var?
    public var name: String // The name of the variable
    public var kind: _PropertyType_ // The kind of the variable
    public var accessModifier: _ModifierType_ // The accessModifier of the variable
    public var wrapper: _WrapperType_?
    public var isOptional: Bool // The isOptional of the variable
    public var declatationSyntax: SyntaxProtocol
    public var comment: CodeCommenting?
}
public enum Constraint: String {
case some, any, none
    public init?(rawValue: String) {
        switch rawValue {
        case "some":
            self = .some
        case "any":
            self = .any
        default:
            self = .none
        }
    }
}
