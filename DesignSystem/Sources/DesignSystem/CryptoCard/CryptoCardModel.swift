import Foundation

public struct CryptoCardModel {
    public let symbol: String
    public let name: String
    public let price: String
    public let change: String
    public let isPositive: Bool
    public let imageURL: String?
    
    public init(
        symbol: String,
        name: String,
        price: String,
        change: String,
        isPositive: Bool,
        imageURL: String? = nil
    ) {
        self.symbol = symbol
        self.name = name
        self.price = price
        self.change = change
        self.isPositive = isPositive
        self.imageURL = imageURL
    }
}

