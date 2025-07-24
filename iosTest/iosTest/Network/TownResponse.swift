//
//  TownResponse.swift
//  iosTest
//
//  Created by Александра Згонникова on 24.07.2025.
//

import Foundation

struct Town: Decodable {
    let id: Int
    let city_name: String
    let region: String
}
