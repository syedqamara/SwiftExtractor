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
    
    func parse(code: GenericTests) async throws -> [Swift] {
        let parserResult = await parser.parse(code: code.rawValue, url: URL(string: "https://www.google.com")!)
        if parserResult.isEmpty {
            XCTFail("Parsing Swift code failed")
            return []
        }else {
            return parserResult
        }
    }
}


extension BaseTestCase {
    enum GenericTests {
        case simple, simpleMultipleArgument, specialised, specliasedMultipleArgument, simpleSpecialMixed
        var rawValue: String {
            switch self {
            case .simple:
                return Self._simple
            case .simpleMultipleArgument:
                return Self._simpleMultiple
            case .specialised:
                return Self._special
            case .specliasedMultipleArgument:
                return Self._specialMultiple
            case .simpleSpecialMixed:
                return Self._singleSpecialMultiple
            }
        }
        
        private static var _simple: String {
        """
        class Wrapper<T> {
            private var wrappedValue: T!
            private let wrappedValueConst: T!
            let isBool = false
            let intValue = 0
            let stringValue = "0"
            func setWrapped(value: T) {
                self.wrappedValue = value
            }
            func getWrappedValue() -> T {
                wrappedValue
            }
        }
        """ }
        private static var _simpleMultiple: String {
        """
        class Wrapper<T,U> {
            private var wrappedValue: T!
            private let wrappedValueConst: T!
            let isBool = false
            let intValue = 0
            let stringValue = "0"
            func setWrapped(value: T) {
                self.wrappedValue = value
            }
            func getWrappedValue() -> T {
                wrappedValue
            }
        }
        """ }
        private static var _special: String {
        """
        class Wrapper<T: Equatable> {
            private var wrappedValue: T!
            private let wrappedValueConst: T!
            let isBool = false
            let intValue = 0
            let stringValue = "0"
            func setWrapped(value: T) {
                self.wrappedValue = value
            }
            func getWrappedValue() -> T {
                wrappedValue
            }
        }
        """
        }
        private static var _specialMultiple: String {
        """
        class Wrapper<T: Equatable, U: Equatable> {
            private var wrappedValue: T!
            private let wrappedValueConst: T!
            let isBool = false
            let intValue = 0
            let stringValue = "0"
            func setWrapped(value: T) {
                self.wrappedValue = value
            }
            func getWrappedValue() -> T {
                wrappedValue
            }
        }
        """
        }
        private static var _singleSpecialMultiple: String {
        """
        class Wrapper<U, T: Equatable> {
            private var wrappedValue: T!
            private let wrappedValueConst: T!
            let isBool = false
            let intValue = 0
            let stringValue = "0"
            func setWrapped(value: T) {
                self.wrappedValue = value
            }
            func getWrappedValue() -> T {
                wrappedValue
            }
        }
        """
        }
    }
}
