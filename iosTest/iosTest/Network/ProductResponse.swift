//
//  ProductResponse.swift
//  iosTest
//
//  Created by Александра Згонникова on 24.07.2025.
//

import Foundation

struct Category: Codable, Identifiable, Hashable {
    var id: String { slug }
    let slug: String
    let name: String
    let url: String
}

struct ProductsResponse: Codable {
    let products: [Product]
}

struct Product: Codable, Identifiable {
    let id: Int
    let title: String
    let price: Double
    let thumbnail: String
    let category: String
}

struct ErrorWrapper: Identifiable {
    let id = UUID()
    let message: String
}
