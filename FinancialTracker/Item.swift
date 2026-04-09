//
//  Item.swift
//  FinancialTracker
//
//  Created by Никита Бондаренко on 09.04.2026.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
