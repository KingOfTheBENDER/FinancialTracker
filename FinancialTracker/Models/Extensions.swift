import Foundation

extension Calendar {
    // Вспомогательный метод — начало месяца для группировки
    func startOfMonth(for date: Date) -> Date {
        let components = dateComponents([.year, .month], from: date)
        return self.date(from: components) ?? date
    }
}