//
//  File.swift
//  
//
//  Created by Apple on 03/08/2023.
//

import Foundation
import SwiftSyntax

extension TokenKind {
    public var isAccessModifier: Bool {
        switch self {
        case .privateKeyword, .fileprivateKeyword, .internalKeyword, .publicKeyword:
            return true
        default:
            return false
        }
    }
}
extension Array {
    var compact: [Element] { compactMap { $0 } }
}
extension TokenSyntax {
    public static func filePrivateKeyword(
      leadingTrivia: Trivia = [],
      trailingTrivia: Trivia = [],
      presence: SourcePresence = .present
    ) -> TokenSyntax {
      return TokenSyntax(
        .fileprivateKeyword,
        leadingTrivia: leadingTrivia,
        trailingTrivia: trailingTrivia,
        presence: presence
      )
    }
}
extension VariableDeclSyntax {
    var isOptional: Bool {
        guard let modifiers = self.modifiers else { return false }
        return modifiers.contains { modifier in
            if let optionalModifier = modifier.as(OptionalTypeSyntax.self) {
                return !optionalModifier.questionMark.text.isEmpty
            }
            return false
        }
    }
}

extension Trivia {
    var lineCommentText: String {
        self.compactMap { triviaPiece in
            if case .lineComment(let text) = triviaPiece {
                return text
            }
            return nil
        }.joined(separator: ", ")
    }
    var docLineCommentText: String {
        self.compactMap { triviaPiece in
            if case .docLineComment(let text) = triviaPiece {
                return text
            }
            return nil
        }.joined(separator: ", ")
    }
    var blockCommentText: String {
        self.compactMap { triviaPiece in
            if case .blockComment(let text) = triviaPiece {
                return text
            }
            return nil
        }.joined(separator: ", ")
    }
    var docBlockCommentText: String {
        self.compactMap { triviaPiece in
            if case .docBlockComment(let text) = triviaPiece {
                return text
            }
            return nil
        }.joined(separator: ", ")
    }
}
