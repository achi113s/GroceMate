//
//  Codable-Extensions.swift
//  Grocemate
//
//  Created by Giorgio Latour on 3/19/24.
//

import Foundation

extension Encodable {
    func jsonToString(with encoding: String.Encoding) -> String? {
        guard let requestData = try? JSONEncoder().encode(self) else {
            return nil
        }

        guard let jsonString = String(data: requestData, encoding: .utf8) else {
            return nil
        }

        return jsonString
    }
}
