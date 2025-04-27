//
//  File.swift
//  
//
//  Created by Apple on 03/08/2023.
//

import Foundation

public protocol FileLoaderProtocol {
    func loadFile(at url: URL) async throws -> String
}

public final class FileLoader: Sendable, FileLoaderProtocol {
    
    public init() {}
    
    public func loadFile(at url: URL) async throws -> String {
        try await Task.detached(priority: .utility) {
            return try String(contentsOf: url, encoding: .utf8)
        }.value
    }
}
