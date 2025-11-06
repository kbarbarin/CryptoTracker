//
//  TradeViewModel.swift
//  CryptoTracker
//
//  Created by Killian Barbarin on 05/11/2025.
//

import Foundation

@Observable
final class TradeViewModel {
    // MARK: - Properties
    var selectedCrypto: CryptoModel
    var cryptoAmount: String = ""
    var fiatAmount: String = ""
    var tradeType: TradeType = .buy
    var isProcessing: Bool = false
    var isEditingCrypto: Bool = false
    var isEditingFiat: Bool = false
    private let walletManager = WalletManager.shared
    private let priceManager = PriceUpdateManager.shared
    private var updateTask: Task<Void, Never>?
    
    // Callback pour afficher le toast
    var onTradeComplete: ((String, Bool) -> Void)?
    
    // MARK: - Computed Properties
    
    /// Montant de crypto en valeur numérique
    var numericCryptoAmount: Double {
        Double(cryptoAmount.replacingOccurrences(of: ",", with: ".")) ?? 0
    }
    
    /// Montant fiat en valeur numérique
    var numericFiatAmount: Double {
        Double(fiatAmount.replacingOccurrences(of: ",", with: ".")) ?? 0
    }
    
    /// Valeur totale de la transaction
    var totalValue: Double {
        if !cryptoAmount.isEmpty {
            return numericCryptoAmount * selectedCrypto.currentPrice
        } else if !fiatAmount.isEmpty {
            return numericFiatAmount
        }
        return 0
    }
    
    /// Vérifie si la transaction est valide
    var isValidTrade: Bool {
        guard totalValue > 0 else { return false }
        
        if tradeType == .buy {
            return totalValue <= walletManager.euroBalance
        } else {
            // Pour la vente, vérifier qu'on possède assez
            let owned = walletManager.getHolding(for: selectedCrypto.id)
            return numericCryptoAmount <= owned
        }
    }
    
    /// Message d'erreur si la transaction n'est pas valide
    var errorMessage: String? {
        if totalValue == 0 {
            return "Veuillez entrer un montant"
        }
        
        if tradeType == .buy && totalValue > walletManager.euroBalance {
            return "Solde insuffisant"
        }
        
        if tradeType == .sell {
            let owned = walletManager.getHolding(for: selectedCrypto.id)
            if owned == 0 {
                return "Vous ne possédez pas cette crypto"
            }
            if numericCryptoAmount > owned {
                return "Quantité insuffisante (vous avez \(String(format: "%.6f", owned)) \(selectedCrypto.symbol))"
            }
        }
        
        return nil
    }
    
    /// Quantité possédée de cette crypto
    var ownedAmount: Double {
        walletManager.getHolding(for: selectedCrypto.id)
    }
    
    /// Quantité possédée formatée
    var formattedOwnedAmount: String {
        String(format: "%.6f %@", ownedAmount, selectedCrypto.symbol)
    }
    
    // MARK: - Initialisation
    
    init(selectedCrypto: CryptoModel) {
        self.selectedCrypto = selectedCrypto
        startPriceUpdates()
    }
    
    deinit {
        stopPriceUpdates()
    }
    
    /// Démarrer les mises à jour de prix en temps réel
    func startPriceUpdates() {
        updateTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                
                guard !Task.isCancelled else { break }
                
                await MainActor.run {
                    guard let self = self else { return }
                    // Mettre à jour uniquement le prix de la crypto sélectionnée
                    // SANS recalculer les montants saisis par l'utilisateur
                    if let updatedCrypto = self.priceManager.getCrypto(id: self.selectedCrypto.id) {
                        self.selectedCrypto = updatedCrypto
                    }
                }
            }
        }
    }
    
    /// Arrêter les mises à jour de prix
    func stopPriceUpdates() {
        updateTask?.cancel()
        updateTask = nil
    }
    
    // MARK: - Methods
    
    /// Met à jour le montant fiat en fonction du montant crypto (après la saisie)
    func updateFiatFromCrypto() {
        guard !cryptoAmount.isEmpty, let amount = Double(cryptoAmount.replacingOccurrences(of: ",", with: ".")) else {
            if cryptoAmount.isEmpty {
                fiatAmount = ""
            }
            return
        }
        
        let fiat = amount * selectedCrypto.currentPrice
        // Formater uniquement quand on quitte le champ
        fiatAmount = String(format: "%.2f", fiat)
    }
    
    /// Met à jour le montant fiat en temps réel SANS formater (pendant la saisie crypto)
    func updateFiatFromCryptoWithoutFormatting() {
        guard !cryptoAmount.isEmpty, let amount = Double(cryptoAmount.replacingOccurrences(of: ",", with: ".")) else {
            if cryptoAmount.isEmpty {
                fiatAmount = ""
            }
            return
        }
        
        let fiat = amount * selectedCrypto.currentPrice
        // Convertir en string proprement (enlever les zéros inutiles)
        fiatAmount = cleanNumberString(fiat)
    }
    
    /// Nettoie un nombre pour enlever les zéros et points inutiles
    private func cleanNumberString(_ value: Double) -> String {
        let string = "\(value)"
        // Si ça contient un point décimal
        if string.contains(".") {
            // Enlever les zéros à la fin
            var cleaned = string
            while cleaned.hasSuffix("0") && !cleaned.hasSuffix(".0") {
                cleaned.removeLast()
            }
            // Si c'est juste ".0", enlever le ".0"
            if cleaned.hasSuffix(".0") {
                cleaned.removeLast(2)
            }
            return cleaned
        }
        return string
    }
    
    /// Met à jour le montant crypto en fonction du montant fiat (après la saisie)
    func updateCryptoFromFiat() {
        guard !fiatAmount.isEmpty, let amount = Double(fiatAmount.replacingOccurrences(of: ",", with: ".")) else {
            if fiatAmount.isEmpty {
                cryptoAmount = ""
            }
            return
        }
        
        let crypto = amount / selectedCrypto.currentPrice
        // Convertir en string proprement (enlever les zéros inutiles)
        cryptoAmount = cleanNumberString(crypto)
    }
    
    /// Met à jour le montant crypto en temps réel SANS formater (pendant la saisie EUR)
    func updateCryptoFromFiatWithoutFormatting() {
        guard !fiatAmount.isEmpty, let amount = Double(fiatAmount.replacingOccurrences(of: ",", with: ".")) else {
            if fiatAmount.isEmpty {
                cryptoAmount = ""
            }
            return
        }
        
        let crypto = amount / selectedCrypto.currentPrice
        // Convertir en string proprement (enlever les zéros inutiles)
        cryptoAmount = cleanNumberString(crypto)
    }
    
    /// Change le type de transaction
    func toggleTradeType() {
        tradeType = tradeType == .buy ? .sell : .buy
    }
    
    /// Définir un pourcentage de vente
    func setSellPercentage(_ percentage: Double) {
        guard tradeType == .sell else { return }
        let ownedAmount = walletManager.getHolding(for: selectedCrypto.id)
        
        // Pour 100%, on vend exactement ce qu'on possède (pas d'arrondi)
        let amountToSell: Double
        if percentage == 100.0 {
            amountToSell = ownedAmount
        } else {
            amountToSell = ownedAmount * (percentage / 100.0)
        }
        
        // Utiliser cleanNumberString pour éviter les ".0" inutiles
        cryptoAmount = cleanNumberString(amountToSell)
        updateFiatFromCryptoWithoutFormatting()
    }
    
    /// Exécute la transaction
    func executeTrade() {
        guard isValidTrade else { return }
        
        isProcessing = true
        
        // Simulation de traitement
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            let result: Result<String, WalletError>
            
            if self.tradeType == .buy {
                result = self.walletManager.buyCrypto(
                    cryptoId: self.selectedCrypto.id,
                    amount: self.numericCryptoAmount,
                    pricePerUnit: self.selectedCrypto.currentPrice
                )
            } else {
                result = self.walletManager.sellCrypto(
                    cryptoId: self.selectedCrypto.id,
                    amount: self.numericCryptoAmount,
                    pricePerUnit: self.selectedCrypto.currentPrice
                )
            }
            
            switch result {
            case .success(let message):
                self.onTradeComplete?(message, true)
                self.resetForm()
            case .failure(let error):
                self.onTradeComplete?(error.localizedDescription, false)
            }
            
            self.isProcessing = false
        }
    }
    
    /// Réinitialise le formulaire
    func resetForm() {
        cryptoAmount = ""
        fiatAmount = ""
    }
    
    /// Solde formaté
    var formattedBalance: String {
        String(format: "%.2f €", walletManager.euroBalance)
    }
}

