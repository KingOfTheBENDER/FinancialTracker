import SwiftUI
import SwiftData

struct AddStockView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var ticker = ""
    @State private var companyName = ""
    @State private var shares = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Тикер (AAPL)", text: $ticker)
                    .textInputAutocapitalization(.characters)
                TextField("Название компании", text: $companyName)
                TextField("Количество акций", text: $shares)
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Новая акция")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Отмена") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Добавить") { saveStock() }
                        .disabled(ticker.isEmpty || companyName.isEmpty || shares.isEmpty)
                }
            }
        }
    }

    private func saveStock() {
        guard let sharesDouble = Double(shares) else { return }
        let stock = Stock(
            ticker: ticker.uppercased(),
            companyName: companyName,
            shares: sharesDouble
        )
        context.insert(stock)
        dismiss()
    }
}