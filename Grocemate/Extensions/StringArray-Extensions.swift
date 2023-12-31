//
//  StringArray-Extensions.swift
//  Grocemate
//
//  Created by Giorgio Latour on 12/8/23.
//

import Foundation

extension Collection where Iterator.Element == String {
    /// A Boolean value indicating whether the collection is not empty.
    public var isNotEmpty: Bool {
        !self.isEmpty
    }

    func areThereEmptyStrings() -> Bool {
        return self
            .contains {
                $0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            }
    }
}
