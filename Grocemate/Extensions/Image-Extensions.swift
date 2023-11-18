//
//  Image-Extensions.swift
//  Grocemate
//
//  Created by Giorgio Latour on 11/18/23.
//

import SwiftUI

extension Image {
    init(data: Data) {
        self.init(uiImage: UIImage(data: data) ?? UIImage(systemName: "questionmark")!)
    }
}
