//
//  MenuViewModel.swift
//  iosTest
//
//  Created by Александра Згонникова on 24.07.2025.
//

import Foundation
import SwiftUI

@MainActor
class MenuViewModel: ObservableObject {
    @Published var cities: [String] = []
    
    @Published var allProducts: [Product] = []
    @Published var categories: [Category] = []
    @Published var productsByCategory: [String: [Product]] = [:]
    @Published var errorMessage: String?
    
    private let productsFileName = "allProducts.json"
    private let categoriesFileName = "categories.json"
    private let citiesFileName = "cities.json"

    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private func fileURL(for fileName: String) -> URL {
        getDocumentsDirectory().appendingPathComponent(fileName)
    }

    func save<T: Codable>(_ object: T, to fileName: String) {
        do {
            let url = fileURL(for: fileName)
            let data = try JSONEncoder().encode(object)
            try data.write(to: url, options: [.atomicWrite, .completeFileProtection])
            print("Сохранено в файл \(fileName)")
        } catch {
            print("Ошибка сохранения файла \(fileName): \(error)")
        }
    }

    func load<T: Codable>(_ fileName: String, as type: T.Type) -> T? {
        do {
            let url = fileURL(for: fileName)
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(type, from: data)
            print("Загружено из файла \(fileName)")
            return decoded
        } catch {
            print("Ошибка загрузки файла \(fileName): \(error)")
            return nil
        }
    }


    func fetchCSV() {
        if let localCities = UserDefaults.standard.array(forKey: citiesFileName) as? [String] {
            self.cities = localCities
        }
        
        guard let url = URL(string: "https://raw.githubusercontent.com/epogrebnyak/ru-cities/main/assets/towns.csv") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil,
                  let csvString = String(data: data, encoding: .utf8) else {
                print("Ошибка при получении CSV")
                return
            }

            let rows = self.convertCSVToDict(csvString: csvString)
            let cityNames = rows.compactMap { $0["city"] }

            DispatchQueue.main.async {
                self.cities = cityNames
                UserDefaults.standard.set(cityNames, forKey: self.citiesFileName)
            }

        }.resume()
    }

    func convertCSVToDict(csvString: String) -> [[String: String]] {
        var result: [[String: String]] = []
        
        let lines = csvString.components(separatedBy: .newlines).filter { !$0.isEmpty }
        guard let headerLine = lines.first else { return result }
        
        let headers = headerLine.components(separatedBy: ",")
        
        for line in lines.dropFirst() {
            let values = line.components(separatedBy: ",")
            guard values.count == headers.count else { continue }
            
            let dict = Dictionary(uniqueKeysWithValues: zip(headers, values))
            result.append(dict)
        }
        
        return result
    }
    
    func loadAllProducts() async {

        if let localProducts = load(productsFileName, as: [Product].self) {
            self.allProducts = localProducts
        }
        
        guard let url = URL(string: "https://dummyjson.com/products?limit=100") else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let result = try JSONDecoder().decode(ProductsResponse.self, from: data)
            self.allProducts = result.products

            save(result.products, to: productsFileName)
            
        } catch {
            self.errorMessage = "Ошибка загрузки всех продуктов: \(error.localizedDescription)"
        }
    }

    func loadCategories() async {
        if let localCategories = load(categoriesFileName, as: [Category].self) {
            categories = localCategories
        }
        
        do {
            categories = try await fetchCategories()
            save(categories, to: categoriesFileName)
            
        } catch {
            errorMessage = "Ошибка загрузки категорий: \(error.localizedDescription)"
        }
    }
    
    private func fetchCategories() async throws -> [Category] {
        guard let url = URL(string: "https://dummyjson.com/products/categories") else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let categories = try JSONDecoder().decode([Category].self, from: data)
        return categories
    }

    func fetchProducts(for categorySlug: String) async throws -> [Product] {
        let urlString = "https://dummyjson.com/products/category/\(categorySlug)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(ProductsResponse.self, from: data)
        return response.products
    }

    func selectCategory(_ category: Category) {
        Task {
            do {
                let products = try await fetchProducts(for: category.slug)
                DispatchQueue.main.async {
                    self.productsByCategory[category.slug] = products
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Ошибка загрузки товаров: \(error.localizedDescription)"
                }
            }
        }
    }
}


struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
