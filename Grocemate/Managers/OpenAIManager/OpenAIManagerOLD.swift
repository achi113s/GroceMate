//
//  OpenAIManager.swift
//  Grocemate
//
//  Created by Giorgio Latour on 12/18/23.
//

import Foundation

/// Manage the connection with the OpenAI API for Chat Completion.
class OpenAIManagerOLD: NSObject, ObservableObject {
    private let completionsEndpoint = "https://api.openai.com/v1/chat/completions"

    private var apiKey: String? {
        Bundle.main.infoDictionary?["OPENAI_API_KEY"] as? String
    }

    private var organization: String? {
        Bundle.main.infoDictionary?["OPENAI_ORGANIZATION"] as? String
    }

    public func postMessageToCompletionsEndpoint(
        requestObject: CompletionRequest,
        completion: @escaping (OpenAIResponse?, Error?) -> Void
    ) {
        guard let url = URL(string: completionsEndpoint) else {
            completion(nil, URLError(.badURL))
            return
        }

        guard let apiKey = self.apiKey, !apiKey.isEmpty else {
            completion(nil, OpenAIError.invalidAPIKey)
            return
        }

        // Construct the request.
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        guard let requestData = try? JSONEncoder().encode(requestObject) else {
            completion(nil, OpenAIError.requestObjectEncodingError)
            return
        }

        request.httpBody = requestData

        // Construct the URLSession task.
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("An error occurred processing this URLSession task: \(error)")
                completion(nil, error)
            } else if (response as? HTTPURLResponse)?.statusCode != 200 {
                let code = (response as? HTTPURLResponse)?.statusCode ?? 400
                let error = URLError(URLError.Code(rawValue: code))
                print("The HTTP request returned a non-200 code: \(code), \(error)")
                completion(nil, error)
            } else {
                guard let data = data else {
                    print("The HTTP request returned empty data.")
                    completion(nil, OpenAIError.emptyDataError)
                    return
                }

                do {
                    let responseObject = try JSONDecoder().decode(OpenAIResponse.self, from: data)
                    completion(responseObject, nil)
                    return
                } catch {
                    print("An error occured decoding the HTTP response data to an OpenAIResponse. \(error)")
                    completion(nil, error)
                }
            }
        }

        task.resume()
        print("Exiting postMessageToCompletionsEndpoint")
    }
}
