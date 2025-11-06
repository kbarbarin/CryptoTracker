import Foundation

public struct DashboardHeaderModel {
    public let balance: String
    public let change: String
    public let changePercentage: String
    public let isPositive: Bool
    
    public init(
        balance: String,
        change: String,
        changePercentage: String,
        isPositive: Bool
    ) {
        self.balance = balance
        self.change = change
        self.changePercentage = changePercentage
        self.isPositive = isPositive
    }
}

