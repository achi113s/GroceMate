//
//  ChatGPTCloudFunctionsHandler.swift
//  Grocemate
//
//  Created by Giorgio Latour on 3/13/24.
//

import FirebaseFunctions
import SwiftUI

protocol OpenAIManaging2: ObservableObject {
    func postPromptToCompletionsEndpoint(requestObject: CompletionRequest,
                                         completion: @escaping (OpenAIResponse?, Error?) -> Void)
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

    func postPromptToCompletionsEndpoint(requestObject: CompletionRequest,
                                         completion: @escaping (OpenAIResponse?, Error?) -> Void) {
        guard let requestData = try? JSONEncoder().encode(requestObject) else {
            return
        }

        if let json = String(data: requestData, encoding: .utf8) {
              print("json as a string", json)
        }

        print("Below is the response:")

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

//        functions.httpsCallable("makeOpenAIAPICompletionsRequest").call(requestObject.toFirebaseFunctionArray) { result, error in
//            if let error = error {
//                print("there was an error: \(error)")
//                return
//            }
//
//            if let data = result?.data as? [String: Any] {
//                if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: []) {
//                    if let responseObject = try? JSONDecoder().decode(OpenAIResponse.self, from: jsonData) {
//                        
//                    }
//                }
//            } else {
//                print("no data")
//            }
//        }
    }

    func fakePostPrompt() {
        let testPayload = TestPayload(name: "Giorgio", ingredient: "lettuce")

        functions.httpsCallable("myTestFunctionAppCheck").call(testPayload.asArray) { result, error in
            if let error = error {
                print("there was an error: \(error)")
                return
            }

            if let data = result?.data as? [String: String] {
                print(data)
            } else {
                print("no data")
            }
        }
    }
}
