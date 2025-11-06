//
//  WalletModel.swift
//  CryptoTracker
//
//  Created by Killian Barbarin on 05/11/2025.
//

import Foundation

/// Modèle représentant une position dans le portefeuille
struct WalletPosition: Identifiable {
    let id: String
    let crypto: CryptoModel
    var amount: Double
    let averageBuyPrice: Double
    
    /// Valeur actuelle de la position
    var currentValue: Double {
        amount * crypto.currentPrice
    }
    
    /// Investissement initial
    var investedValue: Double {
        amount * averageBuyPrice
    }
    
    /// Profit/Perte en valeur absolue
    var profitLoss: Double {
        currentValue - investedValue
    }
    
    /// Profit/Perte en pourcentage
    var profitLossPercentage: Double {
        ((currentValue - investedValue) / investedValue) * 100
    }
    
    /// Indique si la position est en gain
    var isProfit: Bool {
        profitLoss > 0
    }
    
    /// Valeur actuelle formatée
    var formattedCurrentValue: String {
        String(format: "%.2f €", currentValue)
    }
    
    /// Profit/Perte formaté
    var formattedProfitLoss: String {
        let sign = isProfit ? "+" : ""
        return String(format: "%@%.2f €", sign, profitLoss)
    }
    
    /// Profit/Perte en pourcentage formaté
    var formattedProfitLossPercentage: String {
        let sign = isProfit ? "+" : ""
        return String(format: "%@%.2f%%", sign, profitLossPercentage)
    }
    
    /// Quantité formatée
    var formattedAmount: String {
        String(format: "%.6f %@", amount, crypto.symbol)
    }
}

/// Extension pour les données mockées
extension WalletPosition {
    static let mockList: [WalletPosition] = [
        WalletPosition(
            id: "bitcoin",
            crypto: CryptoModel.mockList[0],
            amount: 0.5,
            averageBuyPrice: 38000.00
        ),
        WalletPosition(
            id: "ethereum",
            crypto: CryptoModel.mockList[1],
            amount: 2.5,
            averageBuyPrice: 2400.00
        ),
        WalletPosition(
            id: "solana",
            crypto: CryptoModel.mockList[3],
            amount: 15.0,
            averageBuyPrice: 85.00
        )
    ]
}

