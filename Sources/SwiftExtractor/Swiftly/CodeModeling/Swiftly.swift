//
//  Swift.swift
//  Architecture
//
//  Created by Syed Qamar Abbas on 02/07/2023.
//

import SwiftSyntax
import Foundation

fileprivate let CodeIndentString = "    "

enum SwiftDeclarations {
    case classes(ClassDeclSyntax)
    case structs(StructDeclSyntax)
    case protocols(ProtocolDeclSyntax)
    case enums(EnumDeclSyntax)
    
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
        }
    }
}

public class Swift: Language {
    typealias I = InterfaceType
    var reference: InterfaceType
    var inheritances: [CodeType]
    var conformance: [CodeType]
    init(reference: InterfaceType, inheritances: [CodeType], conformance: [CodeType]) {
        self.reference = reference
        self.inheritances = inheritances
        self.conformance = conformance
    }
}

extension Swift {
    struct Comment: Commenting {
        var lineComment: String
        var blockComment: String
        var docLineComment: String
        var docBlockComment: String
    }
    struct CodeComment: CodeCommenting {
        var leadingComments: Commenting?
        var trailingComments: Commenting?
    }
    public enum Swiftype: String, Types {
    case `class` = "class"
    case `struct` = "struct"
    case `enum` = "enum"
    case `protocol` = "protocol"
    case `propertyWrapper` = "propertyWrapper"
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
        typealias F = Function
        typealias A = Property
        typealias T = Swiftype
        typealias ACS = AccessModifiers
        
        var url: URL
        var name: String
        var type: T
        var access: AccessModifiers
        var functions: [Swift.Function]
        var attributes: [Swift.Property]
        var comment: CodeCommenting?
        var declarationSyntax: SwiftDeclarations
        var generics: [GenericType] = []
    }
}

extension Swift {
    public struct Generic: GenericType {
        var url: URL
        var name: String
        var type: String?
        var comment: CodeCommenting?
    }
    public struct PropertyType: Sourcable {
        var url: URL
        var name: String // The name of the DataType
        var constraint: Constraint // The name of the DataType
        var comment: CodeCommenting?
        var isOptional: Bool // The isOptional of the DataType
        
        mutating func name(_ name: String) {
            self.name = name
        }
        mutating func constraint(_ constraint: Constraint) {
            self.constraint = constraint
        }
        mutating func isOptional(_ isOptional: Bool) {
            self.isOptional = isOptional
        }
    }
    public struct Wrapper {
        var name: String
        var kind: PropertyType
        var _kind: PropertyType
        var _$kind: PropertyType
    }
    public struct Property: Attributes {
        var url: URL
        let name: String // The name of the variable
        let kind: PropertyType // The kind of the variable
        let accessModifier: AccessModifiers // The accessModifier of the variable
        let wrapper: Wrapper?
        let isOptional: Bool // The isOptional of the variable
        let declatationSyntax: SyntaxProtocol
        var comment: CodeCommenting?
    }
    public struct Function: Functionality {
        var url: URL
        var name: String // The name of the Method
        let `return`: PropertyType? // The kind of the Method
        let accessModifier: AccessModifiers // The accessModifier of the Method
        let wrapper: Wrapper?
        let parameters: [Parameter]
        let declatationSyntax: SyntaxProtocol
        var generics: [GenericType] = []
        var comment: CodeCommenting?
    }
}

extension Swift.Function {
    public struct Parameter: Sourcable {
        var url: URL
        let name: String
        let property: Swift.Property
        var comment: CodeCommenting?
    }
}
extension Swift.PropertyType {
    public enum Constraint: String {
    case some, any, none
    }
}
