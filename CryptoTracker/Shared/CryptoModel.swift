//
//  CryptoModel.swift
//  CryptoTracker
//
//  Created by Killian Barbarin on 05/11/2025.
//

import Foundation

/// Modèle représentant une cryptomonnaie
struct CryptoModel: Identifiable, Codable {
    let id: String
    let name: String
    let symbol: String
    let currentPrice: Double
    let priceChange24h: Double
    let priceChangePercentage24h: Double
    let marketCap: Double
    let volume24h: Double
    let image: String
    
    /// URL de l'image depuis CoinGecko
    var imageURL: String {
        CryptoImageHelper.imageURL(for: id)
    }
    
    /// Indique si le prix a augmenté
    var isPositiveChange: Bool {
        priceChangePercentage24h > 0
    }
    
    /// Prix formaté en euros
    var formattedPrice: String {
        String(format: "%.2f €", currentPrice)
    }
    
    /// Variation en pourcentage formatée
    var formattedPercentage: String {
        let sign = isPositiveChange ? "+" : ""
        return String(format: "%@%.2f%%", sign, priceChangePercentage24h)
    }
    
    /// Market cap formaté
    var formattedMarketCap: String {
        formatLargeNumber(marketCap)
    }
    
    /// Volume formaté
    var formattedVolume: String {
        formatLargeNumber(volume24h)
    }
    
    private func formatLargeNumber(_ number: Double) -> String {
        if number >= 1_000_000_000 {
            return String(format: "%.2fB €", number / 1_000_000_000)
        } else if number >= 1_000_000 {
            return String(format: "%.2fM €", number / 1_000_000)
        } else {
            return String(format: "%.2f €", number)
        }
    }
}

/// Extension pour les données mockées
extension CryptoModel {
    static let mock = CryptoModel(
        id: "bitcoin",
        name: "Bitcoin",
        symbol: "BTC",
        currentPrice: 42750.00,
        priceChange24h: 1250.50,
        priceChangePercentage24h: 3.02,
        marketCap: 835_000_000_000,
        volume24h: 28_500_000_000,
        image: "bitcoin"
    )
    
    static let mockList: [CryptoModel] = [
        CryptoModel(
            id: "bitcoin",
            name: "Bitcoin",
            symbol: "BTC",
            currentPrice: 42750.00,
            priceChange24h: 1250.50,
            priceChangePercentage24h: 3.02,
            marketCap: 835_000_000_000,
            volume24h: 28_500_000_000,
            image: "bitcoin"
        ),
        CryptoModel(
            id: "ethereum",
            name: "Ethereum",
            symbol: "ETH",
            currentPrice: 2250.75,
            priceChange24h: -45.25,
            priceChangePercentage24h: -1.97,
            marketCap: 270_000_000_000,
            volume24h: 12_300_000_000,
            image: "ethereum"
        ),
        CryptoModel(
            id: "binancecoin",
            name: "BNB",
            symbol: "BNB",
            currentPrice: 315.40,
            priceChange24h: 8.90,
            priceChangePercentage24h: 2.90,
            marketCap: 48_500_000_000,
            volume24h: 1_200_000_000,
            image: "bnb"
        ),
        CryptoModel(
            id: "solana",
            name: "Solana",
            symbol: "SOL",
            currentPrice: 98.50,
            priceChange24h: 5.30,
            priceChangePercentage24h: 5.68,
            marketCap: 42_000_000_000,
            volume24h: 2_100_000_000,
            image: "solana"
        ),
        CryptoModel(
            id: "cardano",
            name: "Cardano",
            symbol: "ADA",
            currentPrice: 0.52,
            priceChange24h: -0.03,
            priceChangePercentage24h: -5.45,
            marketCap: 18_200_000_000,
            volume24h: 450_000_000,
            image: "cardano"
        )
    ]
    
    /// Génère des données de prix historiques mockées pour le graphique
    func generateMockPriceHistory(days: Int = 30) -> [Double] {
        var prices: [Double] = []
        var currentValue = currentPrice
        
        for _ in 0..<days {
            let randomChange = Double.random(in: -0.05...0.05)
            currentValue *= (1 + randomChange)
            prices.append(currentValue)
        }
        
        return prices
    }
}

