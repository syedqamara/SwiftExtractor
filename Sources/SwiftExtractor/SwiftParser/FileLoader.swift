//
//  File.swift
//  
//
//  Created by Apple on 03/08/2023.
//

import Foundation
public class FileLoader {
    private let queue: DispatchQueue
    
    init() {
        queue = DispatchQueue(label: "com.example.FileLoader", attributes: .concurrent)
    }
    
    public func loadFile(at url: URL) async throws -> String {
        return try await withCheckedThrowingContinuation { cont in
            queue.async {
                do {
                    let result = try self.readFile(at: url)
                    cont.resume(with: .success(result))
                }
                catch let err {
                    cont.resume(with: .failure(err))
                }
                
            }
        }
    }
    
    private func readFile(at url: URL) throws -> String {
        do {
            let content = try String(contentsOf: url, encoding: .utf8)
            return content
        } catch {
            throw error
        }
    }
}
