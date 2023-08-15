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
public protocol Language: Sourcable, Importable {
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
public protocol Sourcable: CodeIdentifiable {
    var url: URL { get set }
    var comment: CodeCommenting? { get set }
}
public protocol CodeIdentifiable {
    var name: String {get set}
}
public protocol CodeType: Sourcable {

}
public protocol GenericType: Sourcable {
    var type: String? {get set}
}
public protocol Genericable: Sourcable {
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
    associatedtype _PropertyType_: Sourcable
    associatedtype _ModifierType_: Access
    associatedtype _WrapperType_: Wrappable
    associatedtype _FunctionParameter_: FunctionParameter
    
    var `return`: _PropertyType_? {get}
    var accessModifier: _ModifierType_ {get}
    var wrapper: _WrapperType_? {get}
    var parameters: [_FunctionParameter_] {get}
}
public protocol FunctionParameter: Sourcable {
    associatedtype AttributeType: PropertyAttributes
    var property: AttributeType { get }
}

public protocol PropertyAttributes: Sourcable {
    associatedtype _PropertyType_: Sourcable
    associatedtype _WrapperType_: Wrappable
    var kind: _PropertyType_ {get}
    var wrapper: _WrapperType_? {get}
    var isOptional: Bool {get}
}
public protocol Attributes: PropertyAttributes {
    associatedtype _ModifierType_: Access
    var accessModifier: _ModifierType_ {get}
}
public protocol Access: RawValue {}
public protocol Types: RawValue {}
public protocol Wrappable: CodeIdentifiable {}
