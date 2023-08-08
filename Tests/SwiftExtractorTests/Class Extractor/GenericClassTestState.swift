//
//  File.swift
//  
//
//  Created by Apple on 09/08/2023.
//

import Foundation

extension SwiftClassExtractorTests {
    enum GenericClassTestState: TestStates {
        case simple, simpleMultipleArgument, specialised, specliasedMultipleArgument, simpleSpecialMixed
        var state: String {
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


