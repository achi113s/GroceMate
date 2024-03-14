//
//  ChatGPTCloudFunctionsHandler.swift
//  Grocemate
//
//  Created by Giorgio Latour on 3/13/24.
//

import FirebaseFunctions
import SwiftUI

protocol OpenAIManaging2: ObservableObject {
    func postPromptToCompletionsEndpoint(requestObject: CompletionRequest) -> OpenAIResponse
    func fakePostPrompt()
}

struct TestPayload: Codable {
    let name: String
    let ingredient: String

    var asArray: [String: String] {
        return ["name": name, "ingredient": ingredient]
    }
}

final class ChatGPTCloudFunctionsHandler: OpenAIManaging2 {
    let functions = Functions.functions(region: "us-central1")

    let testPayload = TestPayload(name: "Giorgio", ingredient: "lettuce")

    func postPromptToCompletionsEndpoint(requestObject: CompletionRequest) -> OpenAIResponse {
        OpenAIResponse(id: "asdf", object: "asdf", created: 1, model: "asdf", 
                       usage: Usage(promptTokens: 3, completionTokens: 2, totalTokens: 2),
                       choices: [Choice(message: Message(role: "32", content: "23rwe"), finishReason: "asdf")])
    }

    func fakePostPrompt() {
        functions.httpsCallable("myTestFunctionAppCheck").call(testPayload.asArray) { result, error in
            if let error = error {
                print("there was an error: \(error)")
                return
            }

            if let data = result?.data as? [String: Any] {
                print(data)
            } else {
                print("no data")
            }
        }
    }
}
