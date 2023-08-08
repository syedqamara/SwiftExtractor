//
//  File.swift
//  
//
//  Created by Apple on 03/08/2023.
//

import Foundation
import SwiftSyntax
@testable import SwiftExtractor
import XCTest

class BaseTestCase: XCTestCase {
    struct BaseCodeResult {
        var isSuccess: Bool
        var message: String
        init(_ isSuccess: Bool, _ message: String) {
            self.isSuccess = isSuccess
            self.message = message
        }
    }
    private let parser = SwiftCodeParser()
    
    func parse(code: TestStates) async throws -> [Swift] {
        let parserResult = await parser.parse(code: code.state, url: URL(string: "https://www.google.com")!)
        if parserResult.isEmpty {
            XCTFail("Parsing Swift code failed")
            return []
        }else {
            return parserResult
        }
    }
}

protocol TestStates {
    var state: String { get }
}
