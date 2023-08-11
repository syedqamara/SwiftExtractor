//
//  Function.swift
//  
//
//  Created by Apple on 11/08/2023.
//

import Foundation
import SwiftSyntax
public struct Parameter: FunctionParameter {
    public typealias AttributeType = ParameterProperty
    public var url: URL
    public var name: String
    public var property: ParameterProperty
    public var comment: CodeCommenting?
    public init(url: URL, name: String, property: ParameterProperty, comment: CodeCommenting? = nil) {
        self.url = url
        self.name = name
        self.property = property
        self.comment = comment
    }
}
public struct ParameterProperty: PropertyAttributes {
    public typealias _PropertyType_ = PropertyType
    public typealias _WrapperType_ = Wrapper
    public var url: URL
    public var name: String // The name of the variable
    public var kind: _PropertyType_ // The kind of the variable
    public var wrapper: _WrapperType_?
    public var isOptional: Bool {
        get {
            kind.isOptional
        }
        set {
            kind.isOptional = newValue
        }
    }
    public var declatationSyntax: SyntaxProtocol?
    public var comment: CodeCommenting?
    public init(url: URL, name: String, kind: _PropertyType_, wrapper: _WrapperType_? = nil, declatationSyntax: SyntaxProtocol?, comment: CodeCommenting? = nil) {
        self.url = url
        self.name = name
        self.kind = kind
        self.wrapper = wrapper
        self.declatationSyntax = declatationSyntax
        self.comment = comment
    }
}

public struct Function: Functionality {
    public typealias _PropertyType_ = PropertyType
    public typealias _ModifierType_ = AccessModifiers
    public typealias _WrapperType_ = Wrapper
    public typealias _FunctionParameter_ = Parameter
    
    public var url: URL
    public var name: String // The name of the Method
    public var `return`: PropertyType? // The kind of the Method
    public var accessModifier: AccessModifiers // The accessModifier of the Method
    public var wrapper: Wrapper?
    public var parameters: [Parameter]
    public var declatationSyntax: SyntaxProtocol?
    public var generics: [GenericType] = []
    public var comment: CodeCommenting?
    public init(url: URL, name: String, `return`: PropertyType? = nil,accessModifier: AccessModifiers, wrapper: Wrapper? = nil, parameters: [Parameter], declatationSyntax: SyntaxProtocol?, generics: [GenericType], comment: CodeCommenting? = nil) {
        self.url = url
        self.name = name
        self.accessModifier = accessModifier
        self.wrapper = wrapper
        self.parameters = parameters
        self.declatationSyntax = declatationSyntax
        self.generics = generics
        self.comment = comment
    }
}
