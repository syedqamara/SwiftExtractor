//
//  swift
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
