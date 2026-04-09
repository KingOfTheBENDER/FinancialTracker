//
//  Item.swift
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
    
    init(ticker: String, companyName: String, shares: Double) {
        self.ticker = ticker
        self.companyName = companyName
        self.shares = shares
    }
}
