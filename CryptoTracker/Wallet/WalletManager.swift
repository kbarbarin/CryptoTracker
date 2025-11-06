//
//  WalletManager.swift
//  CryptoTracker
//
//  Created by Killian Barbarin on 05/11/2025.
//

import Foundation

/// Manager singleton pour gérer le portefeuille de l'utilisateur
@Observable
final class WalletManager {
    static let shared = WalletManager()
    
    // MARK: - Properties
    
    /// Solde en euros disponible
    private(set) var euroBalance: Double {
        didSet {
            saveToUserDefaults()
        }
    }
    
    /// Positions de cryptos détenues (cryptoId -> quantité)
    private(set) var cryptoHoldings: [String: CryptoHolding] {
        didSet {
            saveToUserDefaults()
        }
    }
    
    /// Historique des transactions
    private(set) var transactions: [TradeModel] {
        didSet {
            saveToUserDefaults()
        }
    }
    
    // MARK: - UserDefaults Keys
    
    private let euroBalanceKey = "euroBalance"
    private let cryptoHoldingsKey = "cryptoHoldings"
    private let transactionsKey = "transactions"
    
    // MARK: - Initialisation
    
    private init() {
        // Charger les positions
        if let data = UserDefaults.standard.data(forKey: cryptoHoldingsKey),
           let decoded = try? JSONDecoder().decode([String: CryptoHolding].self, from: data) {
            self.cryptoHoldings = decoded
        } else {
            self.cryptoHoldings = [:]
        }
        
        // Charger les transactions
        if let data = UserDefaults.standard.data(forKey: transactionsKey),
           let decoded = try? JSONDecoder().decode([TradeModel].self, from: data) {
            self.transactions = decoded
        } else {
            self.transactions = []
        }
        
        // Charger le solde en euros (doit être initialisé en dernier à cause du didSet)
        let savedBalance = UserDefaults.standard.double(forKey: euroBalanceKey)
        
        // Si c'est la première fois, on démarre avec 10,000€
        if savedBalance == 0 {
            self.euroBalance = 10_000.0
        } else {
            self.euroBalance = savedBalance
        }
    }
    
    // MARK: - Public Methods
    
    /// Acheter une crypto
    func buyCrypto(cryptoId: String, amount: Double, pricePerUnit: Double) -> Result<String, WalletError> {
        let totalCost = amount * pricePerUnit
        
        // Vérifier si on a assez d'argent
        guard euroBalance >= totalCost else {
            return .failure(.insufficientFunds)
        }
        
        // Déduire le montant
        euroBalance -= totalCost
        
        // Ajouter ou mettre à jour la position
        if var holding = cryptoHoldings[cryptoId] {
            // Calculer le nouveau prix moyen
            let totalAmount = holding.amount + amount
            let totalInvested = (holding.amount * holding.averageBuyPrice) + (amount * pricePerUnit)
            holding.amount = totalAmount
            holding.averageBuyPrice = totalInvested / totalAmount
            cryptoHoldings[cryptoId] = holding
        } else {
            cryptoHoldings[cryptoId] = CryptoHolding(
                cryptoId: cryptoId,
                amount: amount,
                averageBuyPrice: pricePerUnit
            )
        }
        
        // Ajouter la transaction
        let trade = TradeModel(
            cryptoId: cryptoId,
            cryptoSymbol: cryptoId.uppercased(),
            type: .buy,
            amount: amount,
            pricePerUnit: pricePerUnit
        )
        transactions.insert(trade, at: 0)
        
        return .success("Achat de \(String(format: "%.6f", amount)) \(cryptoId.uppercased()) réussi !")
    }
    
    /// Vendre une crypto
    func sellCrypto(cryptoId: String, amount: Double, pricePerUnit: Double) -> Result<String, WalletError> {
        // Vérifier si on possède cette crypto
        guard let holding = cryptoHoldings[cryptoId] else {
            return .failure(.cryptoNotOwned)
        }
        
        // Vérifier si on en a assez
        guard holding.amount >= amount else {
            return .failure(.insufficientCrypto(available: holding.amount))
        }
        
        let totalValue = amount * pricePerUnit
        
        // Ajouter l'argent
        euroBalance += totalValue
        
        // Mettre à jour ou supprimer la position
        if holding.amount == amount {
            // On vend tout
            cryptoHoldings.removeValue(forKey: cryptoId)
        } else {
            // On vend une partie
            var updatedHolding = holding
            updatedHolding.amount -= amount
            cryptoHoldings[cryptoId] = updatedHolding
        }
        
        // Ajouter la transaction
        let trade = TradeModel(
            cryptoId: cryptoId,
            cryptoSymbol: cryptoId.uppercased(),
            type: .sell,
            amount: amount,
            pricePerUnit: pricePerUnit
        )
        transactions.insert(trade, at: 0)
        
        return .success("Vente de \(String(format: "%.6f", amount)) \(cryptoId.uppercased()) réussie !")
    }
    
    /// Obtenir la quantité possédée d'une crypto
    func getHolding(for cryptoId: String) -> Double {
        cryptoHoldings[cryptoId]?.amount ?? 0
    }
    
    /// Obtenir les positions sous forme de WalletPosition
    func getPositions(with cryptos: [CryptoModel]) -> [WalletPosition] {
        var positions: [WalletPosition] = []
        
        for (cryptoId, holding) in cryptoHoldings {
            if let crypto = cryptos.first(where: { $0.id == cryptoId }) {
                let position = WalletPosition(
                    id: cryptoId,
                    crypto: crypto,
                    amount: holding.amount,
                    averageBuyPrice: holding.averageBuyPrice
                )
                positions.append(position)
            }
        }
        
        return positions.sorted { $0.currentValue > $1.currentValue }
    }
    
    /// Réinitialiser le compte
    func resetAccount() {
        euroBalance = 10_000.0
        cryptoHoldings = [:]
        transactions = []
        saveToUserDefaults()
    }
    
    // MARK: - Private Methods
    
    private func saveToUserDefaults() {
        // Sauvegarder le solde
        UserDefaults.standard.set(euroBalance, forKey: euroBalanceKey)
        
        // Sauvegarder les positions
        if let encoded = try? JSONEncoder().encode(cryptoHoldings) {
            UserDefaults.standard.set(encoded, forKey: cryptoHoldingsKey)
        }
        
        // Sauvegarder les transactions
        if let encoded = try? JSONEncoder().encode(transactions) {
            UserDefaults.standard.set(encoded, forKey: transactionsKey)
        }
    }
}

// MARK: - Supporting Types

/// Structure représentant une position de crypto détenue
struct CryptoHolding: Codable {
    let cryptoId: String
    var amount: Double
    var averageBuyPrice: Double
}

/// Erreurs possibles du wallet
enum WalletError: LocalizedError {
    case insufficientFunds
    case cryptoNotOwned
    case insufficientCrypto(available: Double)
    
    var errorDescription: String? {
        switch self {
        case .insufficientFunds:
            return "Solde insuffisant"
        case .cryptoNotOwned:
            return "Vous ne possédez pas cette crypto"
        case .insufficientCrypto(let available):
            return "Quantité insuffisante (disponible: \(String(format: "%.6f", available)))"
        }
    }
}

