//
//  SettingsViewModel.swift
//  CryptoTracker
//
//  Created by Killian Barbarin on 05/11/2025.
//

import Foundation

@Observable
final class SettingsViewModel {
    // MARK: - Properties
    var isDarkMode: Bool = true // Toujours en dark mode
    var showResetConfirmation: Bool = false
    var currency: String = "EUR"
    var language: String = "FR"
    private let walletManager = WalletManager.shared
    
    // Callback pour afficher le toast
    var onResetComplete: ((String) -> Void)?
    
    // MARK: - Computed Properties
    
    var appVersion: String {
        "1.0.0 (POC)"
    }
    
    // MARK: - Methods
    
    func resetDemoAccount() {
        showResetConfirmation = true
    }
    
    func confirmReset() {
        // Reset via le WalletManager
        walletManager.resetAccount()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.showResetConfirmation = false
            self?.onResetComplete?("Compte réinitialisé : 10,000€ disponibles ✅")
        }
    }
    
    func cancelReset() {
        showResetConfirmation = false
    }
    
    func changeCurrency(_ newCurrency: String) {
        currency = newCurrency
    }
    
    func changeLanguage(_ newLanguage: String) {
        language = newLanguage
    }
}

