//
//  NewsView.swift
//  FinancialTracker
//
//  Created by Никита Бондаренко on 24.04.2026.
//

import SwiftUI

struct NewsView: View {
  @State private var viewModel = NewsViewModel()
  @State private var selectedURL: URL?

  var body: some View {
    @Bindable var viewModel = viewModel

    NavigationStack {
      VStack(spacing: 0) {
        Picker("Категория", selection: $viewModel.category) {
          ForEach(NewsCategory.allCases) { category in
            Text(category.title).tag(category)
          }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
        .padding(.vertical, 8)
        .onChange(of: viewModel.category) { _, newValue in
          Task { await viewModel.changeCategory(newValue) }
        }

        content
      }
      .navigationTitle("Новости")
      .task {
        if viewModel.items.isEmpty {
          await viewModel.load()
        }
      }
      .sheet(item: $selectedURL) { url in
        SafariView(url: url)
          .ignoresSafeArea()
      }
    }
  }

  @ViewBuilder
  private var content: some View {
    if viewModel.isLoading && viewModel.items.isEmpty {
      Spacer()
      ProgressView("Загрузка…")
      Spacer()
    } else if let errorMessage = viewModel.errorMessage, viewModel.items.isEmpty {
      Spacer()
      ContentUnavailableView {
        Label("Ошибка загрузки", systemImage: "exclamationmark.triangle")
      } description: {
        Text(errorMessage)
      } actions: {
        Button("Повторить") {
          Task { await viewModel.refresh() }
        }
        .buttonStyle(.borderedProminent)
      }
      Spacer()
    } else if viewModel.items.isEmpty {
      Spacer()
      ContentUnavailableView(
        "Нет новостей",
        systemImage: "newspaper",
        description: Text("Попробуйте обновить ленту позже.")
      )
      Spacer()
    } else {
      List(viewModel.items) { news in
        Button {
          selectedURL = news.url
        } label: {
          NewsRowView(news: news)
        }
        .buttonStyle(.plain)
      }
      .listStyle(.plain)
      .refreshable {
        await viewModel.refresh()
      }
    }
  }
}

extension URL: @retroactive Identifiable {
  public var id: String { absoluteString }
}
