import SwiftUI
import SwiftData

struct AddStockView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var query = ""
    @State private var viewModel = PortfolioViewModel()

    var body: some View {
            NavigationStack {
                List {
                    // Поле поиска
                    TextField("Поиск: AAPL, Apple...", text: $query)
                        .onChange(of: query) { _, newValue in
                            Task {
                                await viewModel.search(query: newValue)
                            }
                        }
                    
                    // Результаты поиска
                    if viewModel.isSearching {
                        ProgressView()  // спиннер — как ActivityIndicator в RN
                    } else {
                        ForEach(viewModel.searchResults) { result in
                            Button {
                                addStock(result)
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(result.symbol).font(.headline)
                                    Text(result.description).font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Добавить акцию")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Отмена") { dismiss() }
                    }
                }
            }
        }

    private func addStock(_ result: SearchResult) {
        let stock = Stock(
            ticker: result.symbol,
            companyName: result.description,
            shares: 1  // потом можно редактировать
        )
        context.insert(stock)
        
        // Загружаем дивиденды сразу после добавления
        Task {
            await viewModel.loadDividends(for: stock, context: context)
        }
        
        dismiss()
    }
}
