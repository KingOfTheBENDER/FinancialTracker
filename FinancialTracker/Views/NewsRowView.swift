//
//  NewsRowView.swift
//  FinancialTracker
//
//  Created by Никита Бондаренко on 24.04.2026.
//

import SwiftUI

struct NewsRowView: View {
  let news: MarketNews

  var body: some View {
    HStack(alignment: .top, spacing: 12) {
      thumbnail
      VStack(alignment: .leading, spacing: 4) {
        Text(news.headline)
          .font(.headline)
          .lineLimit(3)

        Text(news.summary)
          .font(.subheadline)
          .foregroundStyle(.secondary)
          .lineLimit(2)

        HStack(spacing: 6) {
          Text(news.source)
            .font(.caption)
            .foregroundStyle(.secondary)
          Text("•")
            .font(.caption)
            .foregroundStyle(.secondary)
          Text(news.datetime, style: .relative)
            .font(.caption)
            .foregroundStyle(.secondary)
          if let symbol = news.relatedSymbols.first {
            Text("•")
              .font(.caption)
              .foregroundStyle(.secondary)
            Text(symbol)
              .font(.caption.weight(.semibold))
              .foregroundStyle(.blue)
          }
        }
      }
    }
    .padding(.vertical, 4)
  }

  @ViewBuilder
  private var thumbnail: some View {
    if let imageURL = news.image {
      AsyncImage(url: imageURL) { phase in
        switch phase {
        case .success(let image):
          image
            .resizable()
            .scaledToFill()
        case .failure:
          placeholder
        case .empty:
          ProgressView()
        @unknown default:
          placeholder
        }
      }
      .frame(width: 84, height: 84)
      .clipShape(RoundedRectangle(cornerRadius: 8))
    } else {
      placeholder
        .frame(width: 84, height: 84)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
  }

  private var placeholder: some View {
    ZStack {
      Color.gray.opacity(0.2)
      Image(systemName: "newspaper")
        .foregroundStyle(.secondary)
    }
  }
}
