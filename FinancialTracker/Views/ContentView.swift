import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            PortfolioView()
                .tabItem {
                    Label("Портфель", systemImage: "chart.line.uptrend.xyaxis")
                }
            
            AnalyticsView()
                .tabItem {
                    Label("Аналитика", systemImage: "chart.bar.fill")
                }
        }
    }
}
