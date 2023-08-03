//
//  Swift+Extensions.swift
//  Architecture
//
//  Created by Syed Qamar Abbas on 03/07/2023.
//

import Foundation

extension String {
    func components(separatedBy separator: String) -> [String] {
        return self.components(separatedBy: CharacterSet(charactersIn: separator))
    }
    func clip(from token: String) -> Self? {
        self.components(separatedBy: token).first
    }
    func abstractCode() -> String {
        if let declarationStatement = self.clip(from: "{") {
            return declarationStatement
        }
        return ""
    }
}
