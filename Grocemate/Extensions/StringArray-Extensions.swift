//
//  StringArray-Extensions.swift
//  Grocemate
//
//  Created by Giorgio Latour on 12/8/23.
//

import Foundation

extension Collection where Iterator.Element == String {
    func areThereEmptyStrings() -> Bool {
        return self
            .contains {
                $0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            }
    }
}
