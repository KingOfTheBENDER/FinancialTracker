import SwiftUI

struct IncomeBreakdownView: View {
    let stocks: [Stock]
    
    // Общий доход для расчёта процентов
    var totalIncome: Double {
        stocks.reduce(0) { $0 + $1.annualIncome }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("По акциям")
                .font(.headline)
            
            ForEach(stocks.sorted { $0.annualIncome > $1.annualIncome }) { stock in
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(stock.ticker).font(.subheadline).fontWeight(.medium)
                        Text(stock.companyName).font(.caption).foregroundStyle(.secondary)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("$\(stock.annualIncome, specifier: "%.2f")")
                            .font(.subheadline)
                        // Доля от общего дохода в процентах
                        Text(totalIncome > 0 ? "\(stock.annualIncome / totalIncome * 100, specifier: "%.1f")%" : "—")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 4)
                
                if stock.id != stocks.sorted(by: { $0.annualIncome > $1.annualIncome }).last?.id {
                    Divider()
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}