import SwiftUI

struct StockRowView: View {
    let stock: Stock

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
          HStack {
            Text(stock.ticker)
              .font(.headline)
            Spacer()
            Text("$\(stock.annualIncome, specifier: "%.2f")/год")
              .font(.subheadline)
              .foregroundStyle(.green)
          }
          HStack {
            Text(stock.companyName)
              .font(.subheadline)
              .foregroundStyle(.secondary)
            Spacer()
            Text("$\(stock.shares, specifier: "%.0f") акций")
              .font(.caption)
              .foregroundStyle(.secondary)
          }
        }
        .padding(.vertical, 4)
    }
}
