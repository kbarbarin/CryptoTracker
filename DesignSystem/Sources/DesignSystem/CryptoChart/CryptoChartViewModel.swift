import Foundation

@Observable
public final class CryptoChartViewModel {
    public let model: CryptoChartModel
    
    public init(model: CryptoChartModel) {
        self.model = model
    }
    
    /// Données formatées pour le graphique
    public var chartData: [ChartDataPoint] {
        model.prices.enumerated().map { index, price in
            ChartDataPoint(day: index, price: price)
        }
    }
    
    /// Couleur du graphique selon la tendance
    public var chartColor: ChartColor {
        model.isPositive ? .positive : .negative
    }
}

public struct ChartDataPoint: Identifiable {
    public let id = UUID()
    public let day: Int
    public let price: Double
    
    public init(day: Int, price: Double) {
        self.day = day
        self.price = price
    }
}

public enum ChartColor {
    case positive
    case negative
}

