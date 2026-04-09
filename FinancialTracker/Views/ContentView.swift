//
//  ContentView.swift
//  FinancialTracker
//
//  Created by Никита Бондаренко on 09.04.2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query private var stocks: [Stock]
    @State private var showAddStock = false

    var body: some View {
        NavigationStack {
            List {
                if stocks.isEmpty {
                    ContentUnavailableView("Портфель пуст", systemImage: "chart.line.uptrend.xyaxis", description: Text("Добавьте акцию, чтобы начать отслеживать свои инвестиции"))
                } else {
                    ForEach(stocks) { stock in
                        StockRowView(stock: stock)
                    }
                    .onDelete(perform: deleteStock)
                }
            }
            .navigationTitle("Портфель")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddStock = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddStock) {
                AddStockView()
            }
        }
    }

    private func deleteStock(at offsets: IndexSet) {
        for index in offsets {
            context.delete(stocks[index])
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Stock.self, inMemory: true)
}
