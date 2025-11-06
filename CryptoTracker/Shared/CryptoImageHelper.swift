//
//  CryptoImageHelper.swift
//  CryptoTracker
//
//  Created by Killian Barbarin on 05/11/2025.
//

import Foundation

/// Helper pour obtenir les URLs des images de cryptos depuis CoinGecko
enum CryptoImageHelper {
    /// Retourne l'URL de l'image pour une crypto donnée
    static func imageURL(for cryptoId: String) -> String {
        switch cryptoId.lowercased() {
        case "bitcoin":
            return "https://assets.coingecko.com/coins/images/1/large/bitcoin.png"
        case "ethereum":
            return "https://assets.coingecko.com/coins/images/279/large/ethereum.png"
        case "binancecoin", "bnb":
            return "https://assets.coingecko.com/coins/images/825/large/bnb-icon2_2x.png"
        case "solana":
            return "https://assets.coingecko.com/coins/images/4128/large/solana.png"
        case "cardano":
            return "https://assets.coingecko.com/coins/images/975/large/cardano.png"
        case "ripple", "xrp":
            return "https://assets.coingecko.com/coins/images/44/large/xrp-symbol-white-128.png"
        case "polkadot":
            return "https://assets.coingecko.com/coins/images/12171/large/polkadot.png"
        case "dogecoin":
            return "https://assets.coingecko.com/coins/images/5/large/dogecoin.png"
        case "avalanche":
            return "https://assets.coingecko.com/coins/images/12559/large/Avalanche_Circle_RedWhite_Trans.png"
        case "polygon":
            return "https://assets.coingecko.com/coins/images/4713/large/matic-token-icon.png"
        default:
            return "https://assets.coingecko.com/coins/images/1/large/bitcoin.png"
        }
    }
    
    /// Retourne le symbole coloré pour l'icône
    static func symbolColor(for cryptoId: String) -> String {
        switch cryptoId.lowercased() {
        case "bitcoin":
            return "₿"
        case "ethereum":
            return "Ξ"
        case "binancecoin", "bnb":
            return "B"
        case "solana":
            return "◎"
        case "cardano":
            return "₳"
        default:
            return String(cryptoId.prefix(1).uppercased())
        }
    }
}

