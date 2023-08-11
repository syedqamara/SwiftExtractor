//
//  Interface.swift
//  
//
//  Created by Apple on 11/08/2023.
//

import Foundation
public struct InterfaceType: Interface {
    public typealias F = Function
    public typealias A = Variable
    public typealias T = Swiftype
    public typealias ACS = AccessModifiers
    
    public var url: URL
    public var name: String
    public var type: T
    public var access: AccessModifiers
    public var functions: [Function]
    public var attributes: [Variable]
    public var comment: CodeCommenting?
    public var declarationSyntax: SwiftDeclarations
    public var generics: [GenericType] = []
    public init(url: URL, name: String, type: T, access: AccessModifiers, functions: [Function], attributes: [Variable], comment: CodeCommenting? = nil, declarationSyntax: SwiftDeclarations, generics: [GenericType]) {
        self.url = url
        self.name = name
        self.type = type
        self.access = access
        self.functions = functions
        self.attributes = attributes
        self.comment = comment
        self.declarationSyntax = declarationSyntax
        self.generics = generics
    }
}
