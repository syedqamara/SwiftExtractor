//
//  File.swift
//  SwiftExtractor
//
//  Created by Qammar Abbas on 27/04/2025.
//

import Foundation
import SwiftSyntax


public struct SwiftTypeAddress {
    public enum Types {
        case protocols(name: String), classes(name: String), enums(name: String), structs(name: String), propertyWrapper(name: String), source(name: String)
        
        var rawValue: String {
            switch self {
            case .protocols(let name):
                return "Protocol \(name)"
            case .classes(let name):
                return "Class \(name)"
            case .enums(let name):
                return "Enum \(name)"
            case .structs(let name):
                return "Struct \(name)"
            case .propertyWrapper(let name):
                return "PropertyWrapper \(name)"
            case .source(let name):
                return "Source \(name)"
            }
        }
    }
    public let type: Types
    public let url: URL
    public let sourceFileSyntax: SourceFileSyntax
    public init(type: Types, url: URL, sourceFileSyntax: SourceFileSyntax) {
        self.type = type
        self.url = url
        self.sourceFileSyntax = sourceFileSyntax
    }
    public init(swift: Swift, url: URL, sourceFileSyntax: SourceFileSyntax) {
        func swiftAddressType(name: String, type: Swiftype) -> SwiftTypeAddress.Types {
            switch type {
            case .class:
                return .classes(name: name)
            case .struct:
                return .structs(name: name)
            case .enum:
                return .enums(name: name)
            case .protocol:
                return .protocols(name: name)
            case .propertyWrapper:
                return .propertyWrapper(name: name)
            case .sourceFile:
                return .source(name: name)
            }
        }
        let type = swiftAddressType(name: swift.reference.name, type: swift.reference.type)
        self.init(type: type, url: url, sourceFileSyntax: sourceFileSyntax)
    }
    
}


@preconcurrency public protocol SwiftTypeStorageProtocol {
    func add(_ address: SwiftTypeAddress)
    func exists(name: String) -> Bool
    func get(name: String) -> SwiftTypeAddress?
    func clear()
}

public class SwiftTypeStorage: SwiftTypeStorageProtocol {
    private var storage: [String: SwiftTypeAddress]
    private let queue = DispatchQueue(label: "com.swiftTypeStorage.queue")
    public init(storage: [String : SwiftTypeAddress] = [:]) {
        self.storage = storage
    }

    public func add(_ address: SwiftTypeAddress) {
        switch address.type {
        case .protocols(let name),
             .classes(let name),
             .enums(let name),
             .structs(let name),
             .propertyWrapper(let name),
             .source(let name):
            queue.sync(flags: .barrier) { [weak self] in
                self?.storage[name] = address
            }
        }
    }

    public func exists(name: String) -> Bool {
        get(name: name) != nil
    }

    public func get(name: String) -> SwiftTypeAddress? {
        queue.sync { [weak self] in
            return self?.storage[name]
        }
    }

    func all() -> [SwiftTypeAddress] {
        queue.sync { [weak self] in
            guard let welf = self else { return [] }
            return Array(welf.storage.values)
        }
    }

    public func clear() {
        queue.sync(flags: .barrier) { [weak self] in
            self?.storage.removeAll()
        }
    }
}
