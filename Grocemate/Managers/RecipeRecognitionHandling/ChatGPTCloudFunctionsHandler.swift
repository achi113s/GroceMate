//
//  ChatGPTCloudFunctionsHandler.swift
//  Grocemate
//
//  Created by Giorgio Latour on 3/13/24.
//

import FirebaseFunctions
import SwiftUI

protocol OpenAIManaging2: ObservableObject {
    func postRequestToCompletionsEndpoint(requestObject: CompletionRequest,
                                         completion: @escaping (OpenAIResponse?, Error?) -> Void)
}

final class ChatGPTCloudFunctionsHandler: OpenAIManaging2 {
    let functions = Functions.functions(region: "us-central1")

    func postRequestToCompletionsEndpoint(requestObject: CompletionRequest,
                                         completion: @escaping (OpenAIResponse?, Error?) -> Void) {
        functions.httpsCallable("makeOpenAIAPICompletionsRequest",
                                requestAs: CompletionRequest.self,
                                responseAs: OpenAIResponse.self).call(requestObject) { result in
            // result has type Result<OpenAIResponse, any Error>
            switch result {
            case .success(let openAIResponseObject):
                completion(openAIResponseObject, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
