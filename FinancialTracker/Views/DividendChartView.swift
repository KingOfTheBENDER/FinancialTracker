import SwiftUI
import Charts

struct DividendChartView: View {
  let data: [(month: Date, total: Double)]

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("Дивиденды по месяцам")
        .font(.headline)
      
      if data.isEmpty {
        ContentUnavailableView("Нет данных", systemImage: "chart.bar", description: Text("Добавь акции чтобы увидеть график"))
        .frame(height: 200)
      } else {
        Chart(data, id: \.month) {
          item in BarMark(x: .value("Месяц", item.month, unit: .month), y:.value("Сумма", item.total))
          .foregroundStyle(.green.gradient)
          .cornerRadius(4)
        }
        .chartXAxis {
          AxisMarks(values: .stride(by: .month, count: 3)) { value in
            AxisValueLabel(format: .dateTime.month(.abbreviated).year(.twoDigits))
                .font(.system(size: 9))
          }
        }
        .chartYAxis {
          AxisMarks {
            value in AxisValueLabel {
              if let amount = value.as(Double.self) {
                Text(String(format: "$%.0f", amount))
                  .font(.caption2)
              }
            }
          }
        }
        .frame(height: 200)
      }
    }
    .padding()
    .background(Color(.secondarySystemBackground))
    .clipShape(RoundedRectangle(cornerRadius: 12))
  }
}