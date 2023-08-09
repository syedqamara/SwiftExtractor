//
//  Language.swift
//  Architecture
//
//  Created by Syed Qamar Abbas on 02/07/2023.
//

import Foundation


protocol RawValue {
    associatedtype R
    var rawValue: R {get}
}
protocol Packagable {
    var name: String { get }
}
protocol Importable {
    var packages: [Packagable] { get }
}
protocol Language: Importable {
    associatedtype I: Interface
    var reference: I {get set}
    var inheritances: [CodeType] {get set}
    var conformance: [CodeType] {get set}
}
protocol Commenting {
    var lineComment: String { get }
    var blockComment: String { get }
    var docLineComment: String { get }
    var docBlockComment: String { get }
}
protocol CodeCommenting {
    var leadingComments: Commenting? { get set }
    var trailingComments: Commenting? { get set }
}
protocol Sourcable {
    var url: URL { get set }
    var comment: CodeCommenting? { get set }
}
protocol CodeType: Sourcable {
    var name: String {get set}
}
protocol GenericType: CodeType {
    var type: String? {get set}
}
protocol Genericable: CodeType {
    var generics: [GenericType] { get set }
}
protocol Interface: Genericable {
    associatedtype F: Functionality
    associatedtype A: Attributes
    associatedtype T: Types
    associatedtype ACS: Access
    var functions: [F] {get set}
    var attributes: [A] {get set}
    
    var access: ACS {get set}
}

protocol Implementation: Interface {
    
}
protocol Functionality: Genericable {
    
}
protocol Attributes: Sourcable {
    
}
protocol Access: RawValue {}
protocol Types: RawValue {}
