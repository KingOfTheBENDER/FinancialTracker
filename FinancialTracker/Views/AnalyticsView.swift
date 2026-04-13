import SwiftUI
import SwiftData
import Charts

struct AnalyticsView: View {
  @Query private var stocks: [Stock]
  @Environment(\.modelContext) private var context

  // Группируем дивиденды по месяцам
  var dividendsByMonth: [(month: Date, total: Double)] {
    let allDividends = stocks.flatMap {
      stock in stock.dividends.map {
        dividend in (date: dividend.date, amount: dividend.totalPayout(shares: stock.shares))
      }
    }
      
    // Группируем по месяцу — как .reduce в TS но через Dictionary
    let calendar = Calendar.current
    var grouped: [Date: Double] = [:]
      
    for item in allDividends {
        let month = calendar.startOfMonth(for: item.date)
        grouped[month, default: 0] += item.amount
    }
    
    // Берём только последние 12 месяцев от сегодня
    let twelveMonthsAgo = calendar.date(byAdding: .month, value: -12, to: Date()) ?? Date()
    return grouped
      .map { (month: $0.key, total: $0.value) }
      .filter { $0.month >= twelveMonthsAgo }
      .sorted { $0.month < $1.month }
  }

  // Суммарный годовой доход
  var totalAnnualIncome: Double {
    stocks.reduce(0) { $0 + $1.annualIncome }
  }
  
  // Следующая выплата
  var nextDividend: (stock: Stock, dividend: Dividend)? {
    let now = Date()
    return stocks
      .flatMap { stock in
        stock.dividends
          .filter { $0.date > now }
          .map { (stock: stock, dividend: $0) }
      }
      .min { $0.dividend.date < $1.dividend.date }
  }

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(spacing: 16) {
          // Карточки с суммарными данными
          HStack(spacing: 12) {
            SummaryCard(
              title: "Годовой доход",
              value: String(format: "$%.2f", totalAnnualIncome),
              icon: "dollarsign.circle.fill",
              color: .green
            )
            if let next = nextDividend {
              SummaryCard(
                title: "След. выплата",
                value: next.stock.ticker,
                icon: "calendar.circle.fill",
                color: .blue
              )
            }
          }
          .padding(.horizontal)
                    
          // График дивидендов по месяцам
          DividendChartView(data: dividendsByMonth)
            .padding(.horizontal)
          
          // Список акций с их вкладом
          IncomeBreakdownView(stocks: stocks)
            .padding(.horizontal)
        }
        .padding(.vertical)
      }
      .navigationTitle("Аналитика")
    }
  }
}
