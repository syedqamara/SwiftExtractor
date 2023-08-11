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
}
public struct ParameterProperty: Attributes {
    public typealias _PropertyType_ = PropertyType
    public typealias _WrapperType_ = Wrapper
    public typealias _ModifierType_ = AccessModifiers
    public var url: URL
    public var name: String // The name of the variable
    public var kind: _PropertyType_ // The kind of the variable
    public var accessModifier: _ModifierType_ // The accessModifier of the variable
    public var wrapper: _WrapperType_?
    public var isOptional: Bool // The isOptional of the variable
    public var declatationSyntax: SyntaxProtocol
    public var comment: CodeCommenting?
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
    public var declatationSyntax: SyntaxProtocol
    public var generics: [GenericType] = []
    public var comment: CodeCommenting?
}
