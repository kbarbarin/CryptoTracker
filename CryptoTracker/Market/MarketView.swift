//
//  MarketView.swift
//  CryptoTracker
//
//  Created by Killian Barbarin on 05/11/2025.
//

import SwiftUI
import DesignSystem

struct MarketView: View {
    @State private var viewModel = MarketViewModel()
    @State private var showTradeSheet = false
    @State private var selectedCryptoForTrade: CryptoModel?
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColor.backgroundPrimary
                    .ignoresSafeArea()
                
                if viewModel.isLoading {
                    LoadingOverlay()
                } else {
                    VStack(spacing: 0) {
                        // Barre de recherche
                        SearchBar(searchText: $viewModel.searchText)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                        
                        // Liste des cryptos
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.filteredCryptos) { crypto in
                                    CryptoCardView(
                                        viewModel: CryptoCardViewModel(
                                            model: CryptoCardModel(
                                                symbol: crypto.symbol,
                                                name: crypto.name,
                                                price: crypto.formattedPrice,
                                                change: crypto.formattedPercentage,
                                                isPositive: crypto.isPositiveChange,
                                                imageURL: crypto.imageURL
                                            ),
                                            action: {
                                                viewModel.selectCrypto(crypto)
                                            }
                                        )
                                    )
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                        }
                    }
                }
            }
            .navigationTitle("Marché")
            .navigationBarTitleDisplayMode(.large)
            .preferredColorScheme(.dark)
            .sheet(item: $viewModel.selectedCrypto) { crypto in
                CryptoDetailView(
                    crypto: crypto,
                    onBuyTap: {
                        selectedCryptoForTrade = crypto
                        viewModel.selectedCrypto = nil
                        showTradeSheet = true
                    },
                    onSellTap: {
                        selectedCryptoForTrade = crypto
                        viewModel.selectedCrypto = nil
                        showTradeSheet = true
                    }
                )
            }
            .sheet(isPresented: $showTradeSheet, onDismiss: {
                // Rafraîchir les données après fermeture du trade
                selectedCryptoForTrade = nil
            }) {
                if let crypto = selectedCryptoForTrade {
                    TradeView(crypto: crypto)
                }
            }
        }
    }
}

// MARK: - Search Bar Component

private struct SearchBar: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(AppColor.textSecondary)
            
            TextField("Rechercher une crypto...", text: $searchText)
                .font(AppFont.body)
                .foregroundStyle(AppColor.textPrimary)
            
            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(AppColor.textSecondary)
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColor.cardBackground)
        )
    }
}

// MARK: - Crypto Detail View

private struct CryptoDetailView: View {
    let crypto: CryptoModel
    let onBuyTap: () -> Void
    let onSellTap: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColor.backgroundPrimary
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 12) {
                            AsyncImage(url: URL(string: crypto.imageURL)) { phase in
                                switch phase {
                                case .empty:
                                    Circle()
                                        .fill(AppColor.accentYellow.opacity(0.2))
                                        .frame(width: 80, height: 80)
                                        .overlay(ProgressView().tint(AppColor.accentYellow))
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 80, height: 80)
                                case .failure:
                                    Circle()
                                        .fill(AppColor.accentYellow.opacity(0.2))
                                        .frame(width: 80, height: 80)
                                        .overlay(
                                            Text(String(crypto.symbol.prefix(1)))
                                                .font(.system(size: 36, weight: .bold))
                                                .foregroundStyle(AppColor.accentYellow)
                                        )
                                @unknown default:
                                    Circle()
                                        .fill(AppColor.accentYellow.opacity(0.2))
                                        .frame(width: 80, height: 80)
                                }
                            }
                            
                            Text(crypto.name)
                                .font(AppFont.title)
                                .foregroundStyle(AppColor.textPrimary)
                            
                            Text(crypto.symbol)
                                .font(AppFont.body)
                                .foregroundStyle(AppColor.textSecondary)
                        }
                        .padding(.top, 24)
                        
                        // Prix actuel
                        VStack(spacing: 8) {
                            Text(crypto.formattedPrice)
                                .font(.system(size: 48, weight: .bold))
                                .foregroundStyle(AppColor.textPrimary)
                            
                            ProfitBadgeView(
                                viewModel: ProfitBadgeViewModel(
                                    model: ProfitBadgeModel(
                                        value: crypto.formattedPercentage,
                                        isPositive: crypto.isPositiveChange
                                    )
                                )
                            )
                        }
                        
                        // Graphique
                        CryptoChartView(
                            viewModel: CryptoChartViewModel(
                                model: CryptoChartModel(
                                    prices: crypto.generateMockPriceHistory(),
                                    isPositive: crypto.isPositiveChange
                                )
                            )
                        )
                        .padding(.horizontal, 16)
                        
                        // Stats
                        VStack(spacing: 16) {
                            StatRow(label: "Market Cap", value: crypto.formattedMarketCap)
                            StatRow(label: "Volume 24h", value: crypto.formattedVolume)
                            StatRow(
                                label: "Variation 24h",
                                value: String(format: "%.2f €", crypto.priceChange24h),
                                valueColor: crypto.isPositiveChange ? AppColor.accentGreen : AppColor.accentRed
                            )
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(AppColor.cardBackground)
                        )
                        .padding(.horizontal, 16)
                        
                        // Informations supplémentaires
                        VStack(spacing: 16) {
                            InfoCard(
                                title: "À propos",
                                items: [
                                    ("Rang", "#\(Int.random(in: 1...100))"),
                                    ("ATH", String(format: "%.2f €", crypto.currentPrice * 1.5)),
                                    ("ATL", String(format: "%.2f €", crypto.currentPrice * 0.3))
                                ]
                            )
                            
                            InfoCard(
                                title: "Statistiques",
                                items: [
                                    ("Volume/Market Cap", String(format: "%.2f%%", (crypto.volume24h / crypto.marketCap) * 100)),
                                    ("Circulating Supply", "\(Int.random(in: 10...999))M \(crypto.symbol)"),
                                    ("Max Supply", "\(Int.random(in: 1000...9999))M \(crypto.symbol)")
                                ]
                            )
                        }
                        .padding(.horizontal, 16)
                        
                        // Boutons Acheter / Vendre
                        HStack(spacing: 12) {
                            Button(action: {
                                dismiss()
                                onBuyTap()
                            }) {
                                Text("Acheter")
                                    .font(AppFont.body)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(AppColor.backgroundPrimary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(AppColor.accentGreen)
                                    )
                            }
                            
                            Button(action: {
                                dismiss()
                                onSellTap()
                            }) {
                                Text("Vendre")
                                    .font(AppFont.body)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(AppColor.textPrimary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(AppColor.accentRed)
                                    )
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 32)
                    }
                    .padding(.bottom, 24)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Fermer") {
                        dismiss()
                    }
                    .foregroundStyle(AppColor.accentGreen)
                }
            }
        }
    }
}

// MARK: - Info Card

private struct InfoCard: View {
    let title: String
    let items: [(String, String)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(AppFont.body)
                .fontWeight(.semibold)
                .foregroundStyle(AppColor.textPrimary)
            
            VStack(spacing: 12) {
                ForEach(items, id: \.0) { item in
                    HStack {
                        Text(item.0)
                            .font(AppFont.body)
                            .foregroundStyle(AppColor.textSecondary)
                        
                        Spacer()
                        
                        Text(item.1)
                            .font(AppFont.body)
                            .fontWeight(.medium)
                            .foregroundStyle(AppColor.textPrimary)
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColor.cardBackground)
        )
    }
}

// MARK: - Stat Row Component

private struct StatRow: View {
    let label: String
    let value: String
    var valueColor: Color = AppColor.textPrimary
    
    var body: some View {
        HStack {
            Text(label)
                .font(AppFont.body)
                .foregroundStyle(AppColor.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(AppFont.body)
                .fontWeight(.semibold)
                .foregroundStyle(valueColor)
        }
    }
}

#Preview {
    MarketView()
}

