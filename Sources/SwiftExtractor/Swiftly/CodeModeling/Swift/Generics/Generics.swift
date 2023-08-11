//
//  Generics.swift
//  
//
//  Created by Apple on 11/08/2023.
//

import Foundation

public struct Generic: GenericType {
    public var url: URL
    public var name: String
    public var type: String?
    public var comment: CodeCommenting?
    public init(url: URL, name: String, type: String? = nil, comment: CodeCommenting? = nil) {
        self.url = url
        self.name = name
        self.type = type
        self.comment = comment
    }
}
