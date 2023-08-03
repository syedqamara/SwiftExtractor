//
//  SwiftVisitor.swift
//  Architecture
//
//  Created by Syed Qamar Abbas on 02/07/2023.
//

import SwiftSyntax
import Foundation


class SwiftVisitor: SyntaxVisitor {
    var entities: [Swift] = []
    var url: URL
    private var currentEntity: Swift?
    init(viewMode: SyntaxTreeViewMode, url: URL) {
        self.url = url
        super.init(viewMode: viewMode)
    }
    override func visit(_ node: GenericParameterClauseSyntax) -> SyntaxVisitorContinueKind {
        if let extracted = SwiftExtractor(syntax: node, url: url)?.parse() {
            entities.append(extracted)
        }
        return .visitChildren
    }
    override func visit(_ node: ArrayElementListSyntax) -> SyntaxVisitorContinueKind {
        if let extracted = SwiftExtractor(syntax: node, url: url)?.parse() {
            entities.append(extracted)
        }
        return .visitChildren
    }
    override func visit(_ node: MissingSyntax) -> SyntaxVisitorContinueKind {
        if let extracted = SwiftExtractor(syntax: node, url: url)?.parse() {
            entities.append(extracted)
        }
        return .visitChildren
    }
    override func visit(_ node: MissingTypeSyntax) -> SyntaxVisitorContinueKind {
        if let extracted = SwiftExtractor(syntax: node, url: url)?.parse() {
            entities.append(extracted)
        }
        return .visitChildren
    }
    open override func visit(_ node: SourceFileSyntax) -> SyntaxVisitorContinueKind {
        if let extracted = SwiftExtractor(syntax: node, url: url)?.parse() {
            entities.append(extracted)
        }
        return .visitChildren
    }
    override func visit(_ node: CodeBlockItemListSyntax) -> SyntaxVisitorContinueKind {
        if let extracted = SwiftExtractor(syntax: node, url: url)?.parse() {
            entities.append(extracted)
        }
        return .visitChildren
    }
    override func visit(_ node: CodeBlockItemSyntax) -> SyntaxVisitorContinueKind {
        if let extracted = SwiftExtractor(syntax: node.item._syntaxNode, url: url)?.parse() {
            entities.append(extracted)
        }
        return .visitChildren
    }
    func visit(_ node: Syntax) -> SyntaxVisitorContinueKind {
        if let extractor = SwiftExtractor(syntax: node, url: url), let extracted = extractor.parse() {
            entities.append(extracted)
        }
        return .visitChildren
    }
    func visitPost(_ node: Syntax) {
        if node.is(StructDeclSyntax.self) || node.is(ClassDeclSyntax.self) ||
            node.is(ProtocolDeclSyntax.self) || node.is(EnumDeclSyntax.self) {
            currentEntity = nil
        }
    }
}



