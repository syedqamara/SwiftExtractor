//
//  File.swift
//  SwiftExtractor
//
//  Created by Qammar Abbas on 28/04/2025.
//

import Foundation

// MARK: - ChatGPT API Constants
struct ChatGPTAPI {
    static let endpoint = URL(string: "https://api.openai.com/v1/chat/completions")!
    static let apiKey = "YOUR_API_KEY" // Replace with your OpenAI API key
    static let model = "gpt-4" // or "gpt-3.5-turbo"
}

// MARK: - Request and Response Models
struct ChatMessage: Codable {
    let role: String // "user", "system", or "assistant"
    let content: String
}

struct ChatRequest: Codable {
    let model: String
    let messages: [ChatMessage]
    let temperature: Double?
    let max_tokens: Int?
}

struct ChatResponse: Codable {
    struct Choice: Codable {
        let message: ChatMessage
    }
    let choices: [Choice]
}

// MARK: - ChatGPT Network Manager
class ChatGPTService {
    static let shared = ChatGPTService()
    
    private init() {}
    
    func sendMessage(prompt: String,
                     temperature: Double = 0.7,
                     maxTokens: Int = 200,
                     completion: @escaping (Result<[String], Error>) -> Void) {
        
        var request = URLRequest(url: ChatGPTAPI.endpoint)
        request.httpMethod = "POST"
        request.addValue("Bearer \(ChatGPTAPI.apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let userMessage = ChatMessage(role: "user", content: prompt)
        let chatRequest = ChatRequest(
            model: ChatGPTAPI.model,
            messages: [userMessage],
            temperature: temperature,
            max_tokens: maxTokens
        )
        
        do {
            request.httpBody = try JSONEncoder().encode(chatRequest)
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 0)))
                return
            }
            do {
                let decoded = try JSONDecoder().decode(ChatResponse.self, from: data)
                let replies = decoded.choices.isEmpty ? ["No Reply"] : decoded.choices.map { $0.message.content }
                completion(.success(replies))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
