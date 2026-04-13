import SwiftUI
import SwiftData

@Observable
@MainActor
final class SearchViewModel {
    var results: [SearchResult] = []
    var isSearching = false
    var errorMessage: String?

    private let service = FinnhubService()
    private var searchTask: Task<Void, Never>?

    func search(query: String) {
        searchTask?.cancel()
        searchTask = nil

        guard !query.isEmpty else {
            results = []
            isSearching = false
            return
        }

        isSearching = true
        results = []

        searchTask = Task {
            do {
                try await Task.sleep(for: .milliseconds(300))
                let found = try await service.searchStocks(query: query)
                if !Task.isCancelled {
                    results = found
                    isSearching = false
                }
            } catch {
                if !Task.isCancelled {
                    errorMessage = error.localizedDescription
                    results = []
                    isSearching = false
                }
            }
        }
    }

    func cancel() {
        searchTask?.cancel()
        searchTask = nil
        results = []
        isSearching = false
    }
}

struct AddStockView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    var portfolioViewModel: PortfolioViewModel
    @State private var searchViewModel = SearchViewModel()
    @State private var query = ""

    var body: some View {
        NavigationStack {
            List {
                TextField("Поиск: AAPL, Apple...", text: $query)
                    .onChange(of: query) { _, newValue in
                        searchViewModel.search(query: newValue)
                    }

                if query.isEmpty {
                    ContentUnavailableView(
                        "Найдите акцию",
                        systemImage: "magnifyingglass",
                        description: Text("Введите тикер или название компании")
                    )
                } else if !searchViewModel.isSearching && searchViewModel.results.isEmpty {
                    ContentUnavailableView(
                        "Ничего не найдено",
                        systemImage: "xmark.circle",
                        description: Text("Попробуйте другой запрос")
                    )
                } else {
                    ForEach(searchViewModel.results) { result in
                        Button {
                            addStock(result)
                        } label: {
                            VStack(alignment: .leading) {
                                Text(result.symbol).font(.headline)
                                Text(result.description)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .overlay {
                if searchViewModel.isSearching {
                    ProgressView()
                }
            }
            .navigationTitle("Добавить акцию")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Отмена") {
                        searchViewModel.cancel()
                        dismiss()
                    }
                }
            }
        }
    }

    private func addStock(_ result: SearchResult) {
        let stock = Stock(
            ticker: result.symbol,
            companyName: result.description,
            shares: 1
        )
        context.insert(stock)
        Task {
            await portfolioViewModel.loadDividends(for: stock, context: context)
        }
        dismiss()
    }
}
