//
//  DashboardViewModel.swift
//  CryptoTracker
//
//  Created by Killian Barbarin on 05/11/2025.
//

import Foundation

@Observable
final class DashboardViewModel {
    // MARK: - Properties
    var walletPositions: [WalletPosition] = []
    var selectedCrypto: CryptoModel?
    var isLoading: Bool = false
    private let walletManager = WalletManager.shared
    private let priceManager = PriceUpdateManager.shared
    private var availableCryptos: [CryptoModel] = []
    private var updateTask: Task<Void, Never>?
    
    // MARK: - Computed Properties
    
    /// Solde total du portefeuille (cryptos + euros)
    var totalBalance: Double {
        let cryptoValue = walletPositions.reduce(0) { $0 + $1.currentValue }
        return cryptoValue + walletManager.euroBalance
    }
    
    /// Solde en euros
    var euroBalance: Double {
        walletManager.euroBalance
    }
    
    /// Investissement total
    var totalInvested: Double {
        walletPositions.reduce(0) { $0 + $1.investedValue }
    }
    
    /// Profit/Perte total
    var totalProfitLoss: Double {
        totalBalance - totalInvested
    }
    
    /// Profit/Perte en pourcentage
    var totalProfitLossPercentage: Double {
        guard totalInvested > 0 else { return 0 }
        return ((totalBalance - totalInvested) / totalInvested) * 100
    }
    
    /// Indique si le portefeuille est en gain
    var isPositive: Bool {
        totalProfitLoss > 0
    }
    
    /// Solde total formaté
    var formattedBalance: String {
        String(format: "%.2f €", totalBalance)
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
        loadData()
        startPriceUpdates()
    }
    
    deinit {
        stopPriceUpdates()
    }
    
    // MARK: - Methods
    
    func loadData() {
        isLoading = true
        
        // Charger les cryptos disponibles avec les prix à jour
        availableCryptos = priceManager.cryptos
        
        // Simulation de chargement
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            // Obtenir les vraies positions depuis le WalletManager
            self.walletPositions = self.walletManager.getPositions(with: self.availableCryptos)
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
                    self.walletPositions = self.walletManager.getPositions(with: self.availableCryptos)
                }
            }
        }
    }
    
    /// Arrêter les mises à jour de prix
    func stopPriceUpdates() {
        updateTask?.cancel()
        updateTask = nil
    }
    
    func selectCrypto(_ crypto: CryptoModel) {
        selectedCrypto = crypto
    }
    
    func refresh() {
        loadData()
    }
    
    /// Génère les données de prix pour le graphique
    func getChartPrices() -> [Double] {
        guard !walletPositions.isEmpty else {
            return Array(repeating: totalBalance, count: 30)
        }
        
        // Génération de prix historiques simulés
        var prices: [Double] = []
        var currentValue = totalInvested
        
        for _ in 0..<30 {
            let randomChange = Double.random(in: -0.03...0.03)
            currentValue *= (1 + randomChange)
            prices.append(currentValue)
        }
        
        return prices
    }
}

