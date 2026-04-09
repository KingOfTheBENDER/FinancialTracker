//
//  Stock.swift
//  FinancialTracker
//
//  Created by Никита Бондаренко on 09.04.2026.
//

import Foundation
import SwiftData

@Model
final class Stock {
    var ticker: String
    var companyName: String
    var shares: Double
    @Relationship(deleteRule: .cascade) var dividends: [Dividend] = []

    init(ticker: String, companyName: String, shares: Double) {
        self.ticker = ticker
        self.companyName = companyName
        self.shares = shares
    }

    // Годовая доходность от дивидендов
    var annualIncome: Double {
        dividends
            .filter { Calendar.current.isDate($0.date, equalTo: .now, toGranularity: .year) }
            .reduce(0) { $0 + $1.totalPayout(shares: shares) }
    }
}
