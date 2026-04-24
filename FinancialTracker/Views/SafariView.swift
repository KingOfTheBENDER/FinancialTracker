//
//  SafariView.swift
//  FinancialTracker
//
//  Created by Никита Бондаренко on 24.04.2026.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
  let url: URL

  func makeUIViewController(context: Context) -> SFSafariViewController {
    SFSafariViewController(url: url)
  }

  func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}
