//
//  OpenAIManageable.swift
//  Grocemate
//
//  Created by Giorgio Latour on 12/29/23.
//

import Foundation

protocol OpenAIManageable {
    var completionsEndpoint: String { get set }
    var apiKey: String { get set }
    var organization: String { get set }

    func postMessageToCompletionsEndpoint(requestObject: CompletionRequest) -> OpenAIResponse
}
