//
//  Extractor.swift
//  Architecture
//
//  Created by Syed Qamar Abbas on 02/07/2023.
//

import SwiftSyntax
import Foundation
import core_architecture

class SwiftExtractor<S: SyntaxProtocol>: SourceCodeParsable {
    typealias Input = S
    typealias Output = Swift
    var url: URL
    var syntax: S
    
    var structureExtractor: StructureExtractor? = nil
    var protocolExtractor: ProtocolExtractor? = nil
    var classExtractor: ClassExtractor? = nil
    var enumExtractor: EnumExtractor? = nil
    
    required init?(syntax: S, url: URL) {
        self.url = url
        self.syntax = syntax
        if let temp = syntax.as(StructDeclSyntax.self) {
            self.structureExtractor = .init(syntax: temp, url: url)
        }
        else if let temp = syntax.as(ProtocolDeclSyntax.self) {
            self.protocolExtractor = .init(syntax: temp, url: url)
        }
        else if let temp = syntax.as(ClassDeclSyntax.self) {
            self.classExtractor = .init(syntax: temp, url: url)
        }
        else if let temp = syntax.as(EnumDeclSyntax.self) {
            self.enumExtractor = .init(syntax: temp, url: url)
        }
        else {
            return nil
        }
    }
    func parse() -> Swift? {
        if let extractedValue = structureExtractor?.parse() {
            return .init(reference: extractedValue, inheritances: [], conformance: [])
        }
        if let extractedValue = protocolExtractor?.parse() {
            return .init(reference: extractedValue, inheritances: [], conformance: [])
        }
        if let extractedValue = classExtractor?.parse() {
            return .init(reference: extractedValue, inheritances: [], conformance: [])
        }
        if let extractedValue = enumExtractor?.parse() {
            return .init(reference: extractedValue, inheritances: [], conformance: [])
        }
        return nil
    }
}
