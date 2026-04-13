//
//  AppConfig.swift
//  FinancialTracker
//
//  Created by Никита Бондаренко on 09.04.2026.
//
import Foundation

enum AppConfig {
    static let finnhubAPIkey = Bundle.main.object(forInfoDictionaryKey: "FINNHUB_API_KEY") as? String ?? ""
    static let baseURL = "https://finnhub.io/api/v1"
}
