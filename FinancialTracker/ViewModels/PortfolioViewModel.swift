//
//  PortfolioViewModel.swift
//  FinancialTracker
//
//  Created by Никита Бондаренко on 13.04.2026.
//

import Foundation
import SwiftData

@Observable
final class PortfolioViewModel {
    var searchResults: [SearchResult] = []
    var isSearching = false
    var errorMessage: String?
    
    private let service = FinnhubService()
    
    // Поиск акций по запросу
    func search(query: String) async {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        isSearching = true
        do {
            searchResults = try await service.searchStocks(query: query)
        } catch {
            errorMessage = "Ошибка поиска: \(error.localizedDescription)"
            searchResults = []
        }
        isSearching = false
    }

    // Загрузить дивиденды для акции и сохранить в БД
    func loadDividends(for stock: Stock, context: ModelContext) async {
        do {
            let data = try await service.fetchDividends(ticker: stock.ticker)
            
            // Удаляем старые дивиденды перед обновлением
            stock.dividends.forEach { context.delete($0) }
            
            // Конвертируем и сохраняем новые
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            for item in data {
                guard let date = formatter.date(from: item.date) else { continue }
                let dividend = Dividend(
                    ticker: stock.ticker,
                    amount: item.amount,
                    date: date,
                )
                dividend.stock = stock
                context.insert(dividend)
            }
        } catch {
            errorMessage = "Не удалось загрузить дивиденды: \(error.localizedDescription)"
        }
    }
    
}
