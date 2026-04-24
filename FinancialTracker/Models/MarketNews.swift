//
//  MarketNews.swift
//  FinancialTracker
//
//  Created by Никита Бондаренко on 24.04.2026.
//

import Foundation

struct MarketNews: Identifiable, Hashable {
  let id: Int
  let articleCategory: String
  let datetime: Date
  let headline: String
  let image: URL?
  let source: String
  let summary: String
  let url: URL
  let relatedSymbols: [String]
}

enum NewsCategory: String, CaseIterable, Identifiable {
  case general
  case forex
  case crypto
  case merger

  var id: String { rawValue }

  var title: String {
    switch self {
    case .general: return "Общие"
    case .forex: return "Forex"
    case .crypto: return "Crypto"
    case .merger: return "M&A"
    }
  }
}
