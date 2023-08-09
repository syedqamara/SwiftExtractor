//
//  Language.swift
//  Architecture
//
//  Created by Syed Qamar Abbas on 02/07/2023.
//

import Foundation


public protocol RawValue {
    associatedtype R
    var rawValue: R {get}
}
public protocol Packagable {
    var name: String { get }
}
public protocol Importable {
    var packages: [Packagable] { get }
}
public protocol Language: Importable {
    associatedtype I: Interface
    var reference: I {get set}
    var inheritances: [CodeType] {get set}
    var conformance: [CodeType] {get set}
}
public protocol Commenting {
    var lineComment: String { get }
    var blockComment: String { get }
    var docLineComment: String { get }
    var docBlockComment: String { get }
}
public protocol CodeCommenting {
    var leadingComments: Commenting? { get set }
    var trailingComments: Commenting? { get set }
}
public protocol Sourcable {
    var url: URL { get set }
    var comment: CodeCommenting? { get set }
}
public protocol CodeType: Sourcable {
    var name: String {get set}
}
public protocol GenericType: CodeType {
    var type: String? {get set}
}
public protocol Genericable: CodeType {
    var generics: [GenericType] { get set }
}
public protocol Interface: Genericable {
    associatedtype F: Functionality
    associatedtype A: Attributes
    associatedtype T: Types
    associatedtype ACS: Access
    var functions: [F] {get set}
    var attributes: [A] {get set}
    
    var access: ACS {get set}
}

public protocol Implementation: Interface {
    
}
public protocol Functionality: Genericable {
    
}
public protocol Attributes: Sourcable {
    
}
public protocol Access: RawValue {}
public protocol Types: RawValue {}
