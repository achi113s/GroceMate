//
//  OpenAIManager.swift
//  Grocemate
//
//  Created by Giorgio Latour on 12/18/23.
//

import Foundation

protocol OpenAIManageable {
    var completionsEndpoint: String { get set }
    var apiKey: String { get set }
    var organization: String { get set }

    func postMessageToCompletionsEndpoint(requestObject: CompletionRequest) -> OpenAIResponse
}

/// Manage the connection with the OpenAI API for Chat Completion.
class OpenAIManager: NSObject, ObservableObject {
    private let completionsEndpoint = "https://api.openai.com/v1/chat/completions"

    private var apiKey: String {
        Bundle.main.infoDictionary?["OPENAI_API_KEY"] as? String ?? ""
    }

    private var organization: String {
        Bundle.main.infoDictionary?["OPENAI_ORGANIZATION"] as? String ?? ""
    }

    public func postMessageToCompletionsEndpoint(
        requestObject: CompletionRequest,
        completion: @escaping (OpenAIResponse?, Error?) -> Void
    ) {
        guard let url = URL(string: completionsEndpoint) else {
            completion(nil, URLError(.badURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        print("apiKey \(apiKey)")
        guard let requestData = try? JSONEncoder().encode(requestObject) else {
            completion(nil, ChatGPTCompletionsError.requestObjectEncodingError)
            return
        }

        request.httpBody = requestData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("There was an error: \(error.localizedDescription).")
                completion(nil, error)
//            } else if (response as? HTTPURLResponse)?.statusCode != 200 {
//                print("HTTPURLResponse status code \((response as? HTTPURLResponse)?.statusCode)")
//                completion(nil, ChatGPTCompletionsError.non200CodeError)
            } else {
                guard let data = data else {
                    completion(nil, ChatGPTCompletionsError.emptyDataError)
                    return
                }

                do {
                    let responseObject = try JSONDecoder().decode(OpenAIResponse.self, from: data)

                    completion(responseObject, nil)
                    return
                } catch {
                    print("There was an error decoding the JSON object: \(error.localizedDescription)")
                    completion(nil, error)
                }
            }
        }

        task.resume()
        print("Exiting postMessageToCompletionsEndpoint")
    }
}
