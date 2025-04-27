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
    private let swiftTypeStorage: SwiftTypeStorageProtocol
    private let sourceFileSyntax: SourceFileSyntax
    init(viewMode: SyntaxTreeViewMode, url: URL, swiftTypeStorage: SwiftTypeStorageProtocol, sourceFileSyntax: SourceFileSyntax) {
        self.url = url
        self.swiftTypeStorage = swiftTypeStorage
        self.sourceFileSyntax = sourceFileSyntax
        super.init(viewMode: viewMode)
    }
    override func visit(_ node: BooleanLiteralExprSyntax) -> SyntaxVisitorContinueKind {
        if let extracted = swiftExtractor(node)?.parse() {
            entities.append(extracted)
        }
        return .visitChildren
    }
    override func visit(_ node: IntegerLiteralExprSyntax) -> SyntaxVisitorContinueKind {
        if let extracted = swiftExtractor(node)?.parse() {
            entities.append(extracted)
        }
        return .visitChildren
    }
    override func visit(_ node: FloatLiteralExprSyntax) -> SyntaxVisitorContinueKind {
        if let extracted = swiftExtractor(node)?.parse() {
            entities.append(extracted)
        }
        return .visitChildren
    }
    override func visit(_ node: StringLiteralExprSyntax) -> SyntaxVisitorContinueKind {
        if let extracted = swiftExtractor(node)?.parse() {
            entities.append(extracted)
        }
        return .visitChildren
    }
    override func visit(_ node: NilLiteralExprSyntax) -> SyntaxVisitorContinueKind {
        if let extracted = swiftExtractor(node)?.parse() {
            entities.append(extracted)
        }
        return .visitChildren
    }
    override func visit(_ node: SpecializeExprSyntax) -> SyntaxVisitorContinueKind {
        if let extracted = swiftExtractor(node)?.parse() {
            entities.append(extracted)
        }
        return .visitChildren
    }
    override func visit(_ node: RegexLiteralExprSyntax) -> SyntaxVisitorContinueKind {
        if let extracted = swiftExtractor(node)?.parse() {
            entities.append(extracted)
        }
        return .visitChildren
    }
    override func visit(_ node: KeyPathExprSyntax) -> SyntaxVisitorContinueKind {
        if let extracted = swiftExtractor(node)?.parse() {
            entities.append(extracted)
        }
        return .visitChildren
    }
    override func visit(_ node: MacroExpansionExprSyntax) -> SyntaxVisitorContinueKind {
        if let extracted = swiftExtractor(node)?.parse() {
            entities.append(extracted)
        }
        return .visitChildren
    }
    override func visit(_ node: PostfixIfConfigExprSyntax) -> SyntaxVisitorContinueKind {
        if let extracted = swiftExtractor(node)?.parse() {
            entities.append(extracted)
        }
        return .visitChildren
    }
    override func visit(_ node: EditorPlaceholderExprSyntax) -> SyntaxVisitorContinueKind {
        if let extracted = swiftExtractor(node)?.parse() {
            entities.append(extracted)
        }
        return .visitChildren
    }
    
    override func visit(_ node: GenericParameterClauseSyntax) -> SyntaxVisitorContinueKind {
        if let extracted = swiftExtractor(node)?.parse() {
            entities.append(extracted)
        }
        return .visitChildren
    }
    override func visit(_ node: ArrayElementListSyntax) -> SyntaxVisitorContinueKind {
        if let extracted = swiftExtractor(node)?.parse() {
            entities.append(extracted)
        }
        return .visitChildren
    }
    override func visit(_ node: MissingSyntax) -> SyntaxVisitorContinueKind {
        if let extracted = swiftExtractor(node)?.parse() {
            entities.append(extracted)
        }
        return .visitChildren
    }
    override func visit(_ node: MissingTypeSyntax) -> SyntaxVisitorContinueKind {
        if let extracted = swiftExtractor(node)?.parse() {
            entities.append(extracted)
        }
        return .visitChildren
    }
    open override func visit(_ node: SourceFileSyntax) -> SyntaxVisitorContinueKind {
        if let extracted = swiftExtractor(node)?.parse() {
            entities.append(extracted)
        }
        return .visitChildren
    }
    override func visit(_ node: CodeBlockItemListSyntax) -> SyntaxVisitorContinueKind {
        if let extracted = swiftExtractor(node)?.parse() {
            entities.append(extracted)
        }
        return .visitChildren
    }
    override func visit(_ node: CodeBlockItemSyntax) -> SyntaxVisitorContinueKind {
        if let extracted = swiftExtractor(node.item._syntaxNode)?.parse() {
            entities.append(extracted)
        }
        return .visitChildren
    }
    func visit(_ node: Syntax) -> SyntaxVisitorContinueKind {
        if let extractor = swiftExtractor(node), let extracted = extractor.parse() {
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
    func swiftExtractor<S: SyntaxProtocol>(_ syntax: S) -> SwiftExtractor<S>? {
        let extractor = SwiftExtractor(syntax: syntax, url: url)
        extractor?.sourceFileSyntax = sourceFileSyntax
        extractor?.swiftTypeStorage = swiftTypeStorage
        return extractor
    }
}



