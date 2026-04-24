//
//  NewsViewModel.swift
//  FinancialTracker
//
//  Created by Никита Бондаренко on 24.04.2026.
//

import Foundation

@Observable
@MainActor
final class NewsViewModel {
  var items: [MarketNews] = []
  var category: NewsCategory = .general
  var isLoading = false
  var errorMessage: String?

  private let service = FinnhubService()
  private var cache: [NewsCategory: (items: [MarketNews], timestamp: Date)] = [:]
  private let cacheTTL: TimeInterval = 300

  func load(force: Bool = false) async {
    if !force, let cached = cache[category], Date().timeIntervalSince(cached.timestamp) < cacheTTL {
      items = cached.items
      return
    }

    isLoading = true
    errorMessage = nil
    defer { isLoading = false }

    do {
      let fetched = try await service.fetchMarketNews(category: category)
      items = fetched
      cache[category] = (fetched, Date())
    } catch {
      errorMessage = error.localizedDescription
      items = []
    }
  }

  func changeCategory(_ new: NewsCategory) async {
    guard new != category else { return }
    category = new
    await load()
  }

  func refresh() async {
    await load(force: true)
  }
}
