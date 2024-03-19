//
//  OpenAIResponseModel.swift
//  Grocemate
//
//  Created by Giorgio Latour on 12/17/23.
//

import Foundation

struct OpenAIResponse: Codable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let usage: Usage
    let choices: [Choice]
}

struct Usage: Codable {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int

    private enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}

struct Choice: Codable {
    let message: Message
    let finishReason: String

    private enum CodingKeys: String, CodingKey {
        case message = "message"
        case finishReason = "finish_reason"
    }
}

struct Message: Codable {
    let role: String
    let content: String

    var toString: String {
        return "\(role), \(content)"
    }
}

struct CompletionRequest: Codable {
    let model: String
    let maxTokens: Int32
    let messages: [Message]
    let temperature: Double
    let stream: Bool

    private enum CodingKeys: String, CodingKey {
        case model = "model"
        case maxTokens = "max_tokens"
        case messages = "messages"
        case temperature = "temperature"
        case stream = "stream"
    }
}

struct DecodedIngredients: Codable {
    let ingredients: [String]
}
