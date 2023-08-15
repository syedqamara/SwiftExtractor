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
            return .init(
                url: url,
                name: url.lastPathComponent,
                packages: [],
                reference: extractedValue,
                inheritances: [],
                conformance: []
            )
        }
        if let extractedValue = protocolExtractor?.parse() {
            return .init(
                url: url,
                name: url.lastPathComponent,
                packages: [],
                reference: extractedValue,
                inheritances: [],
                conformance: []
            )
        }
        if let extractedValue = classExtractor?.parse() {
            return .init(
                url: url,
                name: url.lastPathComponent,
                packages: [],
                reference: extractedValue,
                inheritances: [],
                conformance: []
            )
        }
        if let extractedValue = enumExtractor?.parse() {
            return .init(
                url: url,
                name: url.lastPathComponent,
                packages: [],
                reference: extractedValue,
                inheritances: [],
                conformance: []
            )
        }
        return nil
    }
}
class LeadingCommentExtractor: SourceCodeParsable {
    typealias Input = SyntaxProtocol
    typealias Output = Comment
    var url: URL
    var syntax: Input
    required init?(syntax: Input, url: URL) {
        self.url = url
        self.syntax = syntax
    }
    func parse() -> Comment? {
        guard let trivia = syntax.leadingTrivia else { return nil }
        return .init(
            lineComment: trivia.lineCommentText,
            blockComment: trivia.blockCommentText,
            docLineComment: trivia.docLineCommentText,
            docBlockComment: trivia.docBlockCommentText
        )
    }
}
class TrailingCommentExtractor: SourceCodeParsable {
    typealias Input = SyntaxProtocol
    typealias Output = Comment
    var url: URL
    var syntax: Input
    required init?(syntax: Input, url: URL) {
        self.url = url
        self.syntax = syntax
    }
    func parse() -> Comment? {
        guard let trivia = syntax.leadingTrivia else { return nil }
        return .init(
            lineComment: trivia.lineCommentText,
            blockComment: trivia.blockCommentText,
            docLineComment: trivia.docLineCommentText,
            docBlockComment: trivia.docBlockCommentText
        )
    }
}
class CommentExtractor: SourceCodeParsable {
    typealias Input = SyntaxProtocol
    typealias Output = CodeComment
    
    var url: URL
    var syntax: Input
    var leadingCommentExtractor: LeadingCommentExtractor
    var trailingCommentExtractor: TrailingCommentExtractor
    required init?(syntax: Input, url: URL) {
        guard let trailingCommentExtractor = TrailingCommentExtractor(syntax: syntax, url: url) else {return nil}
        guard let leadingCommentExtractor = LeadingCommentExtractor(syntax: syntax, url: url) else {return nil}
        self.url = url
        self.syntax = syntax
        self.leadingCommentExtractor = leadingCommentExtractor
        self.trailingCommentExtractor = trailingCommentExtractor
    }
    func parse() -> Output? {
        guard let leadingComment = leadingCommentExtractor.parse() else {return nil}
        guard let trailingComment = trailingCommentExtractor.parse() else {return nil}
        return .init(
            leadingComments: leadingComment,
            trailingComments: trailingComment
        )
    }
}
