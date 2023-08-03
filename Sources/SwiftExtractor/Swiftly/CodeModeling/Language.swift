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

protocol Language {
    associatedtype I: Interface
    var reference: I {get set}
    var inheritances: [CodeType] {get set}
    var conformance: [CodeType] {get set}
}
protocol Sourcable {
    var url: URL { get set }
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
