//
//  PriceUpdateManager.swift
//  CryptoTracker
//
//  Created by Killian Barbarin on 05/11/2025.
//

import Foundation

/// Manager qui simule les variations de prix des cryptomonnaies en temps réel
@Observable
final class PriceUpdateManager {
    static let shared = PriceUpdateManager()
    
    // MARK: - Properties
    
    private(set) var cryptos: [CryptoModel] = []
    private var updateTask: Task<Void, Never>?
    
    // MARK: - Initialisation
    
    private init() {
        // Initialiser avec les cryptos mockées
        cryptos = CryptoModel.mockList
    }
    
    // MARK: - Public Methods
    
    /// Démarrer les mises à jour automatiques
    func startUpdating() {
        // Annuler toute tâche existante
        stopUpdating()
        
        updateTask = Task { [weak self] in
            while !Task.isCancelled {
                // Attendre 1 seconde
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                
                guard !Task.isCancelled else { break }
                
                // Mettre à jour les prix
                await self?.updatePrices()
            }
        }
    }
    
    /// Arrêter les mises à jour automatiques
    func stopUpdating() {
        updateTask?.cancel()
        updateTask = nil
    }
    
    /// Obtenir une crypto par son ID
    func getCrypto(id: String) -> CryptoModel? {
        cryptos.first(where: { $0.id == id })
    }
    
    // MARK: - Private Methods
    
    @MainActor
    private func updatePrices() {
        cryptos = cryptos.map { crypto in
            // Générer une variation réaliste entre -0.5% et +0.5%
            let randomVariation = Double.random(in: -0.005...0.005)
            let newPrice = crypto.currentPrice * (1 + randomVariation)
            
            // Calculer la nouvelle variation 24h
            let priceChange = newPrice - crypto.currentPrice
            let newPriceChange24h = crypto.priceChange24h + priceChange
            let newPercentageChange = (newPriceChange24h / (newPrice - newPriceChange24h)) * 100
            
            return CryptoModel(
                id: crypto.id,
                name: crypto.name,
                symbol: crypto.symbol,
                currentPrice: newPrice,
                priceChange24h: newPriceChange24h,
                priceChangePercentage24h: newPercentageChange,
                marketCap: crypto.marketCap * (1 + randomVariation * 0.5),
                volume24h: crypto.volume24h * (1 + randomVariation * 0.3),
                image: crypto.image
            )
        }
    }
}

