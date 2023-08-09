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
        case .classes(let declSyntax):
            return declSyntax.description
        case .structs(let declSyntax):
            return declSyntax.description
        case .protocols(let declSyntax):
            return declSyntax.description
        case .enums(let declSyntax):
            return declSyntax.description
        case .sourceFile(let declSyntax):
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
        public typealias A = Property
        public typealias T = Swiftype
        public typealias ACS = AccessModifiers
        
        public var url: URL
        public var name: String
        public var type: T
        public var access: AccessModifiers
        public var functions: [Swift.Function]
        public var attributes: [Swift.Property]
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
    public struct Wrapper {
        public var name: String
        public var kind: PropertyType
        public var _kind: PropertyType
        public var _$kind: PropertyType
    }
    public struct Property: Attributes {
        public var url: URL
        public let name: String // The name of the variable
        public let kind: PropertyType // The kind of the variable
        public let accessModifier: AccessModifiers // The accessModifier of the variable
        public let wrapper: Wrapper?
        public let isOptional: Bool // The isOptional of the variable
        public let declatationSyntax: SyntaxProtocol
        public var comment: CodeCommenting?
    }
    public struct Function: Functionality {
        public var url: URL
        public var name: String // The name of the Method
        public let `return`: PropertyType? // The kind of the Method
        public let accessModifier: AccessModifiers // The accessModifier of the Method
        public let wrapper: Wrapper?
        public let parameters: [Parameter]
        public let declatationSyntax: SyntaxProtocol
        public var generics: [GenericType] = []
        public var comment: CodeCommenting?
    }
}

extension Swift.Function {
    public struct Parameter: Sourcable {
        public var url: URL
        public let name: String
        public let property: Swift.Property
        public var comment: CodeCommenting?
    }
}
extension Swift.PropertyType {
    public enum Constraint: String {
    case some, any, none
    }
}
