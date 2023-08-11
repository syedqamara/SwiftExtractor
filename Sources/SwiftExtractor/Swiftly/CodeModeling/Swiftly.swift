//
//  Swift.swift
//  Architecture
//
//  Created by Syed Qamar Abbas on 02/07/2023.
//

import SwiftSyntax
import Foundation

public enum SwiftDeclarations {
    case classes(ClassDeclSyntax)
    case structs(StructDeclSyntax)
    case protocols(ProtocolDeclSyntax)
    case enums(EnumDeclSyntax)
    case sourceFile(SourceFileSyntax)
    
    var code: String {
        switch self {
        case .classes(var declSyntax):
            return declSyntax.description
        case .structs(var declSyntax):
            return declSyntax.description
        case .protocols(var declSyntax):
            return declSyntax.description
        case .enums(var declSyntax):
            return declSyntax.description
        case .sourceFile(var declSyntax):
            return declSyntax.description
        }
    }
}

public struct SwiftPackage: Packagable {
    public var name: String
}

public struct Swift: Language {
    public typealias I = InterfaceType
    public var packages: [Packagable]
    public var reference: InterfaceType
    public var inheritances: [CodeType]
    public var conformance: [CodeType]
    public init(reference: InterfaceType, inheritances: [CodeType], conformance: [CodeType], packages: [Packagable]) {
        self.reference = reference
        self.inheritances = inheritances
        self.conformance = conformance
        self.packages = packages
    }
}

extension Swift {
    public struct Comment: Commenting {
        public var lineComment: String
        public var blockComment: String
        public var docLineComment: String
        public var docBlockComment: String
    }
    public struct CodeComment: CodeCommenting {
        public var leadingComments: Commenting?
        public var trailingComments: Commenting?
    }
    public enum Swiftype: String, Types {
    case `class` = "class"
    case `struct` = "struct"
    case `enum` = "enum"
    case `protocol` = "protocol"
    case `propertyWrapper` = "propertyWrapper"
    case sourceFile = "source_file"
    }
    public enum AccessModifiers: String, Access {
        case `open` = "open"
        case `public` = "public"
        case `internal` = "internal"
        case `private` = "private"
        case `filePrivate` = "filePrivate"
        case `none` = "none"
        
        public init(rawValue: String) {
            switch rawValue {
            case "open":
                self = .open
            case "public":
                self = .public
            case "internal":
                self = .internal
            case "private":
                self = .private
            case "filePrivate":
                self = .filePrivate
            case "":
                self = .internal
            default:
                self = .none
            }
        }
    }
    public struct InterfaceType: Interface {
        public typealias F = Function
        public typealias A = Variable
        public typealias T = Swiftype
        public typealias ACS = AccessModifiers
        
        public var url: URL
        public var name: String
        public var type: T
        public var access: AccessModifiers
        public var functions: [Swift.Function]
        public var attributes: [Swift.Variable]
        public var comment: CodeCommenting?
        public var declarationSyntax: SwiftDeclarations
        public var generics: [GenericType] = []
    }
}

extension Swift {
    public struct Generic: GenericType {
        public var url: URL
        public var name: String
        public var type: String?
        public var comment: CodeCommenting?
    }
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
    case `let`, `var`, parameter, none
        
        public init(rawValue: String) {
            switch rawValue {
            case "let":
                self = .let
            case "var":
                self = .var
            case "parameter":
                self = .parameter
            default:
                self = .none
            }
        }
        public var rawValue: String {
            switch self {
            case .let:
                return "let"
            case .var:
                return "var"
            case .parameter:
                return "parameter"
            case .none:
                return ""
            }
        }
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
}

extension Swift.Function {
    public struct Parameter: FunctionParameter {
        public typealias AttributeType = Swift.ParameterProperty
        public var url: URL
        public var name: String
        public var property: Swift.ParameterProperty
        public var comment: CodeCommenting?
    }
}
extension Swift.PropertyType {
    public enum Constraint: String {
    case some, any, none
    }
}
