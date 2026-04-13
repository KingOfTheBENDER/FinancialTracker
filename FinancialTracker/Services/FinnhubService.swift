//
//  FinnhubService.swift
//  FinancialTracker
//
//  Created by Никита Бондаренко on 13.04.2026.
//

import Foundation

// Codable модели — структура ответа от Finnhub API
struct DividendResponse: Codable {
    let data: [DividendData]
}

struct DividendData: Codable {
    let date: String
    let amount: Double
    let symbol: String
    
    // Переименовываем symbol → ticker для единообразия
    enum CodingKeys: String, CodingKey {
        case date
        case amount
        case symbol
    }
}

// Модель для поиска акций
struct SearchResponse: Codable {
    let result: [SearchResult]
}

struct SearchResult: Codable, Identifiable {
    let symbol: String
    let description: String

    var id: String { symbol }  // computed property для Identifiable
}

// @Observable — аналог класса с @observable в MobX
@Observable
final class FinnhubService {
    
    // Состояние загрузки — enum вместо boolean флагов
    enum LoadingState {
        case idle
        case loading
        case loaded
        case error(String)
    }
    
    var state: LoadingState = .idle
    
    // Base функция для любого запроса
    // аналог: async function request<T>(url: string): Promise<T>
    private func request<T: Codable>(_ endpoint: String) async throws -> T {
        guard let url = URL(string: AppConfig.baseURL + endpoint + "&token=\(AppConfig.finnhubAPIkey)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Проверяем статус ответа — как response.ok в fetch
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    // Получить дивиденды по тикеру
    func fetchDividends(ticker: String) async throws -> [DividendData] {
        let endpoint = "/stock/dividend?symbol=\(ticker)"
        let response: DividendResponse = try await request(endpoint)
        return response.data
    }
    
    // Поиск акций по названию
    func searchStocks(query: String) async throws -> [SearchResult] {
        let endpoint = "/search?q=\(query)"
        let response: SearchResponse = try await request(endpoint)
        return response.result
    }
}
