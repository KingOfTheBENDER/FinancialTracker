//
//  AppConfig.swift
//  FinancialTracker
//
//  Created by Никита Бондаренко on 09.04.2026.
//
import Foundation

enum AppConfig {
    static let finnhubAPIkey = ProcessInfo.processInfo.environment["FINNHUB_API_KEY"] ?? ""
    static let baseURL = "https://finnhub.io/api/v1"
}
