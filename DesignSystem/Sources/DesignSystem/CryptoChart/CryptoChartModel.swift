import Foundation

public struct CryptoChartModel {
    public let prices: [Double]
    public let isPositive: Bool
    
    public init(prices: [Double], isPositive: Bool) {
        self.prices = prices
        self.isPositive = isPositive
    }
}

