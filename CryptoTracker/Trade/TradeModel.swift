//
//  TradeModel.swift
//  CryptoTracker
//
//  Created by Killian Barbarin on 05/11/2025.
//

import Foundation

/// Type de transaction
enum TradeType: String, Codable {
    case buy = "Achat"
    case sell = "Vente"
}

/// Modèle représentant une transaction
struct TradeModel: Identifiable, Codable {
    let id: UUID
    let cryptoId: String
    let cryptoSymbol: String
    let type: TradeType
    let amount: Double
    let pricePerUnit: Double
    let totalValue: Double
    let date: Date
    
    init(
        id: UUID = UUID(),
        cryptoId: String,
        cryptoSymbol: String,
        type: TradeType,
        amount: Double,
        pricePerUnit: Double,
        date: Date = Date()
    ) {
        self.id = id
        self.cryptoId = cryptoId
        self.cryptoSymbol = cryptoSymbol
        self.type = type
        self.amount = amount
        self.pricePerUnit = pricePerUnit
        self.totalValue = amount * pricePerUnit
        self.date = date
    }
    
    /// Valeur totale formatée
    var formattedTotalValue: String {
        String(format: "%.2f €", totalValue)
    }
    
    /// Montant de crypto formaté
    var formattedAmount: String {
        String(format: "%.6f %@", amount, cryptoSymbol)
    }
    
    /// Date formatée
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

/// Extension pour les données mockées
extension TradeModel {
    static let mockList: [TradeModel] = [
        TradeModel(
            cryptoId: "bitcoin",
            cryptoSymbol: "BTC",
            type: .buy,
            amount: 0.05,
            pricePerUnit: 40000.00,
            date: Date().addingTimeInterval(-86400 * 5)
        ),
        TradeModel(
            cryptoId: "ethereum",
            cryptoSymbol: "ETH",
            type: .buy,
            amount: 1.5,
            pricePerUnit: 2100.00,
            date: Date().addingTimeInterval(-86400 * 3)
        ),
        TradeModel(
            cryptoId: "bitcoin",
            cryptoSymbol: "BTC",
            type: .sell,
            amount: 0.01,
            pricePerUnit: 42000.00,
            date: Date().addingTimeInterval(-86400)
        )
    ]
}

