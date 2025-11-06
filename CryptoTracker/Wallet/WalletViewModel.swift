//
//  WalletViewModel.swift
//  CryptoTracker
//
//  Created by Killian Barbarin on 05/11/2025.
//

import Foundation

@Observable
final class WalletViewModel {
    // MARK: - Properties
    var positions: [WalletPosition] = []
    var isLoading: Bool = false
    var selectedPosition: WalletPosition?
    private let walletManager = WalletManager.shared
    private let priceManager = PriceUpdateManager.shared
    private var availableCryptos: [CryptoModel] = []
    private var updateTask: Task<Void, Never>?
    
    // MARK: - Computed Properties
    
    /// Valeur totale du portefeuille
    var totalValue: Double {
        positions.reduce(0) { $0 + $1.currentValue }
    }
    
    /// Investissement total
    var totalInvested: Double {
        positions.reduce(0) { $0 + $1.investedValue }
    }
    
    /// Profit/Perte total
    var totalProfitLoss: Double {
        totalValue - totalInvested
    }
    
    /// Profit/Perte en pourcentage
    var totalProfitLossPercentage: Double {
        guard totalInvested > 0 else { return 0 }
        return ((totalValue - totalInvested) / totalInvested) * 100
    }
    
    /// Indique si le portefeuille est en gain
    var isPositive: Bool {
        totalProfitLoss > 0
    }
    
    /// Valeur totale formatée
    var formattedTotalValue: String {
        String(format: "%.2f €", totalValue)
    }
    
    /// Profit/Perte formaté
    var formattedProfitLoss: String {
        let sign = isPositive ? "+" : ""
        return String(format: "%@%.2f €", sign, totalProfitLoss)
    }
    
    /// Profit/Perte en pourcentage formaté
    var formattedProfitLossPercentage: String {
        let sign = isPositive ? "+" : ""
        return String(format: "%@%.2f%%", sign, totalProfitLossPercentage)
    }
    
    // MARK: - Initialisation
    
    init() {
        loadPositions()
        startPriceUpdates()
    }
    
    deinit {
        stopPriceUpdates()
    }
    
    // MARK: - Methods
    
    func loadPositions() {
        isLoading = true
        
        // Charger les cryptos disponibles avec les prix à jour
        availableCryptos = priceManager.cryptos
        
        // Simulation de chargement
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            // Obtenir les vraies positions depuis le WalletManager
            self.positions = self.walletManager.getPositions(with: self.availableCryptos)
            self.isLoading = false
        }
    }
    
    /// Démarrer les mises à jour de prix en temps réel
    func startPriceUpdates() {
        // Observer les changements toutes les secondes
        updateTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                
                guard !Task.isCancelled else { break }
                
                await MainActor.run {
                    guard let self = self else { return }
                    self.availableCryptos = self.priceManager.cryptos
                    self.positions = self.walletManager.getPositions(with: self.availableCryptos)
                }
            }
        }
    }
    
    /// Arrêter les mises à jour de prix
    func stopPriceUpdates() {
        updateTask?.cancel()
        updateTask = nil
    }
    
    func selectPosition(_ position: WalletPosition) {
        selectedPosition = position
    }
    
    func refresh() {
        loadPositions()
    }
    
    /// Trie les positions par valeur décroissante
    var sortedByValue: [WalletPosition] {
        positions.sorted { $0.currentValue > $1.currentValue }
    }
    
    /// Trie les positions par profit/perte décroissante
    var sortedByProfitLoss: [WalletPosition] {
        positions.sorted { $0.profitLoss > $1.profitLoss }
    }
}

