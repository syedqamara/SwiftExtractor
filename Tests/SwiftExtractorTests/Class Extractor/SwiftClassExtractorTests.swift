import XCTest
import SwiftSyntax
@testable import SwiftExtractor

final class SwiftClassExtractorTests: BaseTestCase {
    let parser = SwiftCodeParser()
    
    func testIsClass(swift: Swift) throws {
        XCTAssertTrue(swift.reference.name.isNotEmpty, "Mismatch name")
        XCTAssertTrue(swift.reference.type.rawValue == "class", "Is not a class")
    }
    func testHaveVariables(swift: Swift) throws {
        for attr in swift.reference.attributes {
            XCTAssertTrue(attr.name.isNotEmpty, "Have no variables names")
            XCTAssertTrue(attr.kind.name.isNotEmpty , "Have no variables type")
        }
    }
    func testHaveFunctions(swift: Swift) throws {
        XCTAssertTrue(swift.reference.functions.isNotEmpty, "Have no variables")
    }
    
    // MARK: - Simple Single Generic
    func testIsSimpleGenericWithSingleGenericType() async throws {
        let result = try await parse(code: GenericClassTestState.simple)
        if let first = result.first {
            try testIsClass(swift: first)
            try testHaveVariables(swift: first)
            try testHaveFunctions(swift: first)
            XCTAssertTrue(first.reference.generics.isNotEmpty, "Is not a Generic")
            if let generic = first.reference.generics.first {
                XCTAssertTrue(generic.name.isNotEmpty, "Is Generic")
                XCTAssertTrue(generic.type == nil, "Is Generic")
            }
        }
    }
    // MARK: - Specialised Single Generic
    func testIsSpecialisedGenericWithSingleGenericType() async throws {
        let result = try await parse(code: GenericClassTestState.specialised)
        if let first = result.first {
            try testIsClass(swift: first)
            try testHaveVariables(swift: first)
            try testHaveFunctions(swift: first)
            XCTAssertTrue(first.reference.generics.isNotEmpty, "Is not a Generic")
            if let generic = first.reference.generics.first {
                XCTAssertTrue(generic.name.isNotEmpty, "Is Generic")
                XCTAssertTrue(generic.type != nil, "Is Generic")
            }
        }
    }
    // MARK: - Simple Multiple Generic
    func testIsSimpleGenericWithMultipleGenericType() async throws {
        let result = try await parse(code: GenericClassTestState.simpleMultipleArgument)
        if let first = result.first {
            try testIsClass(swift: first)
            try testHaveVariables(swift: first)
            try testHaveFunctions(swift: first)
            XCTAssertTrue(first.reference.generics.isNotEmpty, "Is not a Generic")
            for generic in first.reference.generics {
                XCTAssertTrue(generic.name.isNotEmpty, "Is Generic")
                XCTAssertTrue(generic.type == nil, "Is Generic")
            }
        }
    }
    // MARK: - Specialised Multiple Generic
    
    func testIsSpecialisedGenericWithMultipleGenericType() async throws {
        let result = try await parse(code: GenericClassTestState.specliasedMultipleArgument)
        if let first = result.first {
            try testIsClass(swift: first)
            try testHaveVariables(swift: first)
            try testHaveFunctions(swift: first)
            XCTAssertTrue(first.reference.generics.isNotEmpty, "Is not a Generic")
            for generic in first.reference.generics {
                XCTAssertTrue(generic.name.isNotEmpty, "Is Generic")
                XCTAssertTrue(generic.type != nil, "Is Generic")
            }
        }
    }
    // MARK: - Simple & Specialised Multiple Generic
    
    func testIsSimpleAndSpecialisedGenericWithMultipleGenericType() async throws {
        let result = try await parse(code: GenericClassTestState.simpleSpecialMixed)
        if let first = result.first {
            try testIsClass(swift: first)
            try testHaveVariables(swift: first)
            try testHaveFunctions(swift: first)
            XCTAssertTrue(first.reference.generics.isNotEmpty, "Is not a Generic")
            if let generic = first.reference.generics.first {
                XCTAssertTrue(generic.name.isNotEmpty, "Is Generic")
                XCTAssertTrue(generic.type == nil, "Is Generic")
            }
            if let generic = first.reference.generics.last {
                XCTAssertTrue(generic.name.isNotEmpty, "Is Generic")
                XCTAssertTrue(generic.type != nil, "Is Generic")
            }
        }
    }
}

