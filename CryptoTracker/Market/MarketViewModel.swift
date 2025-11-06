//
//  MarketViewModel.swift
//  CryptoTracker
//
//  Created by Killian Barbarin on 05/11/2025.
//

import Foundation

@Observable
final class MarketViewModel {
    // MARK: - Properties
    var cryptos: [CryptoModel] = []
    var searchText: String = ""
    var isLoading: Bool = false
    var selectedCrypto: CryptoModel?
    private let priceManager = PriceUpdateManager.shared
    private var updateTask: Task<Void, Never>?
    
    // MARK: - Computed Properties
    
    /// Cryptos filtrées selon la recherche
    var filteredCryptos: [CryptoModel] {
        if searchText.isEmpty {
            return cryptos
        }
        
        return cryptos.filter { crypto in
            crypto.name.localizedCaseInsensitiveContains(searchText) ||
            crypto.symbol.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    // MARK: - Initialisation
    
    init() {
        loadMarketData()
        startPriceUpdates()
    }
    
    deinit {
        stopPriceUpdates()
    }
    
    // MARK: - Methods
    
    func loadMarketData() {
        isLoading = true
        
        // Simulation de chargement
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.cryptos = self?.priceManager.cryptos ?? []
            self?.isLoading = false
        }
    }
    
    /// Démarrer les mises à jour de prix en temps réel
    func startPriceUpdates() {
        priceManager.startUpdating()
        
        // Observer les changements toutes les secondes
        updateTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                
                guard !Task.isCancelled else { break }
                
                await MainActor.run {
                    self?.cryptos = self?.priceManager.cryptos ?? []
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
        loadMarketData()
    }
    
    func clearSearch() {
        searchText = ""
    }
}

