import Foundation

public struct ProfitBadgeModel {
    public let value: String
    public let isPositive: Bool
    
    public init(value: String, isPositive: Bool) {
        self.value = value
        self.isPositive = isPositive
    }
}

