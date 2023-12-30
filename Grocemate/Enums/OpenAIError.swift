//
//  OpenAIError.swift
//  Grocemate
//
//  Created by Giorgio Latour on 12/18/23.
//

import Foundation

enum OpenAIError: Error {
    /*
     Throw when ChatGPT returns a bad JSON String
     and we can't convert it to a JSON data object.
     */
    case badJSONString, invalidAPIKey, requestObjectEncodingError, emptyDataError
}

extension OpenAIError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .badJSONString:
            return "ChatGPT returned an inconvertible JSON string or none at all."
        case .invalidAPIKey:
            return "The provided API Key is blank or invalid."
        case .requestObjectEncodingError:
            return "The completions request object could not be encoded to JSON."
        case .emptyDataError:
            return "The completions request returned an empty data object."
        }
    }
}

enum ChatGPTCompletionsError: Error {
    case unknownError, requestObjectEncodingError, emptyDataError, non200CodeError
}
