//
//  Dividend.swift
//  FinancialTracker
//
//  Created by Никита Бондаренко on 09.04.2026.
//

import Foundation
import SwiftData

@Model
final class Dividend {
    var ticker: String
    var amount: Double // сумма на 1 акцию
    var date: Date
    var stock: Stock? // связь с Stock(акцией)

    init(ticker: String, amount: Double, date: Date) {
        self.ticker = ticker
        self.amount = amount
        self.date = date
    }

    func totalPayout(shares: Double) -> Double {
        return amount * shares
    }
}