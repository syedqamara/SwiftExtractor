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
    case none
    public var code: String {
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
        case .none:
            return ""
        }
    }
    public init(_ declaration: ClassDeclSyntax) {
        self = .classes(declaration)
    }
    public init(_ declaration: StructDeclSyntax) {
        self = .structs(declaration)
    }
    public init(_ declaration: ProtocolDeclSyntax) {
        self = .protocols(declaration)
    }
    public init(_ declaration: EnumDeclSyntax) {
        self = .enums(declaration)
    }
    public init(_ declaration: SourceFileSyntax) {
        self = .sourceFile(declaration)
    }
}

public struct SwiftPackage: Packagable {
    public var name: String
    public init(name: String) {
        self.name = name
    }
}

public struct Swift: Language {
    public typealias I = InterfaceType
    public var url: URL
    public var name: String
    public var comment: CodeCommenting?
    public var packages: [Packagable]
    public var reference: InterfaceType
    public var inheritances: [CodeType]
    public var conformance: [CodeType]
    public init(url: URL, name: String, comment: CodeCommenting? = nil, packages: [Packagable], reference: InterfaceType, inheritances: [CodeType], conformance: [CodeType]) {
        self.url = url
        self.name = name
        self.comment = comment
        self.packages = packages
        self.reference = reference
        self.inheritances = inheritances
        self.conformance = conformance
    }
}
public struct Comment: Commenting {
    public var lineComment: String
    public var blockComment: String
    public var docLineComment: String
    public var docBlockComment: String
    public init(lineComment: String, blockComment: String, docLineComment: String, docBlockComment: String) {
        self.lineComment = lineComment
        self.blockComment = blockComment
        self.docLineComment = docLineComment
        self.docBlockComment = docBlockComment
    }
}
public struct CodeComment: CodeCommenting {
    public var leadingComments: Commenting?
    public var trailingComments: Commenting?
    public init(leadingComments: Commenting? = nil, trailingComments: Commenting? = nil) {
        self.leadingComments = leadingComments
        self.trailingComments = trailingComments
    }
}
public enum Swiftype: String, Types {
case `class` = "class"
case `struct` = "struct"
case `enum` = "enum"
case `protocol` = "protocol"
case `propertyWrapper` = "propertyWrapper"
case sourceFile = "source_file"
    public init(rawValue: String) {
        switch rawValue {
        case "class":
            self = .class
        case "struct":
            self = .struct
        case "enum":
            self = .enum
        case "protocol":
            self = .protocol
        case "propertyWrapper":
            self = .propertyWrapper
        case "sourceFile":
            self = .sourceFile
        default:
            self = .sourceFile
        }
    }
}
public enum AccessModifiers: String, Access {
    case `open` = "open"
    case `public` = "public"
    case `internal` = "internal"
    case `private` = "private"
    case `filePrivate` = "fileprivate"
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
        case "fileprivate":
            self = .filePrivate
        case "":
            self = .internal
        default:
            self = .none
        }
    }
}
