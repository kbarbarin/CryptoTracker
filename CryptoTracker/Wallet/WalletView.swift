//
//  WalletView.swift
//  CryptoTracker
//
//  Created by Killian Barbarin on 05/11/2025.
//

import SwiftUI
import DesignSystem

struct WalletView: View {
    @State private var viewModel = WalletViewModel()
    @State private var sortOption: SortOption = .byValue
    
    enum SortOption: String, CaseIterable {
        case byValue = "Valeur"
        case byProfitLoss = "P/L"
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColor.backgroundPrimary
                    .ignoresSafeArea()
                
                if viewModel.isLoading {
                    LoadingOverlay()
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            // Header - Résumé du portefeuille
                            WalletSummaryCard(viewModel: viewModel)
                                .padding(.horizontal, 16)
                            
                            // Options de tri
                            Picker("Trier par", selection: $sortOption) {
                                ForEach(SortOption.allCases, id: \.self) { option in
                                    Text(option.rawValue).tag(option)
                                }
                            }
                            .pickerStyle(.segmented)
                            .padding(.horizontal, 16)
                            
                            // Liste des positions
                            VStack(spacing: 12) {
                                ForEach(sortedPositions) { position in
                                    WalletPositionCard(position: position)
                                        .onTapGesture {
                                            viewModel.selectPosition(position)
                                        }
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        .padding(.vertical, 16)
                    }
                }
            }
            .navigationTitle("Portefeuille")
            .navigationBarTitleDisplayMode(.large)
            .preferredColorScheme(.dark)
            .onAppear {
                viewModel.refresh()
            }
            .sheet(item: $viewModel.selectedPosition) { position in
                PositionDetailView(position: position)
            }
        }
    }
    
    private var sortedPositions: [WalletPosition] {
        switch sortOption {
        case .byValue:
            return viewModel.sortedByValue
        case .byProfitLoss:
            return viewModel.sortedByProfitLoss
        }
    }
}

// MARK: - Wallet Summary Card

private struct WalletSummaryCard: View {
    let viewModel: WalletViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            // Valeur totale
            VStack(spacing: 8) {
                Text("Valeur Totale")
                    .font(AppFont.label)
                    .foregroundStyle(AppColor.textSecondary)
                
                Text(viewModel.formattedTotalValue)
                    .font(.system(size: 42, weight: .bold))
                    .foregroundStyle(AppColor.textPrimary)
            }
            
            // P/L
            HStack(spacing: 16) {
                VStack(spacing: 4) {
                    Text("Profit/Perte")
                        .font(AppFont.label)
                        .foregroundStyle(AppColor.textSecondary)
                    
                    Text(viewModel.formattedProfitLoss)
                        .font(AppFont.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(viewModel.isPositive ? AppColor.accentGreen : AppColor.accentRed)
                }
                
                ProfitBadgeView(
                    viewModel: ProfitBadgeViewModel(
                        model: ProfitBadgeModel(
                            value: viewModel.formattedProfitLossPercentage,
                            isPositive: viewModel.isPositive
                        )
                    )
                )
            }
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColor.cardBackground)
                .shadow(color: AppColor.softShadow, radius: 10, x: 0, y: 5)
        )
    }
}

// MARK: - Wallet Position Card

private struct WalletPositionCard: View {
    let position: WalletPosition
    
    var body: some View {
        HStack(spacing: 16) {
            // Icône avec image
            AsyncImage(url: URL(string: position.crypto.imageURL)) { phase in
                switch phase {
                case .empty:
                    Circle()
                        .fill(AppColor.accentYellow.opacity(0.2))
                        .frame(width: 56, height: 56)
                        .overlay(ProgressView().tint(AppColor.accentYellow))
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 56, height: 56)
                case .failure:
                    Circle()
                        .fill(AppColor.accentYellow.opacity(0.2))
                        .frame(width: 56, height: 56)
                        .overlay(
                            Text(String(position.crypto.symbol.prefix(1)))
                                .font(AppFont.subtitle)
                                .foregroundStyle(AppColor.accentYellow)
                        )
                @unknown default:
                    Circle()
                        .fill(AppColor.accentYellow.opacity(0.2))
                        .frame(width: 56, height: 56)
                }
            }
            
            // Info
            VStack(alignment: .leading, spacing: 6) {
                Text(position.crypto.symbol)
                    .font(AppFont.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColor.textPrimary)
                
                Text(position.formattedAmount)
                    .font(AppFont.label)
                    .foregroundStyle(AppColor.textSecondary)
            }
            
            Spacer()
            
            // Valeur et P/L
            VStack(alignment: .trailing, spacing: 6) {
                Text(position.formattedCurrentValue)
                    .font(AppFont.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColor.textPrimary)
                
                HStack(spacing: 4) {
                    Image(systemName: position.isProfit ? "arrow.up.right" : "arrow.down.right")
                        .font(.system(size: 10, weight: .bold))
                    
                    Text(position.formattedProfitLossPercentage)
                        .font(AppFont.label)
                }
                .foregroundStyle(position.isProfit ? AppColor.accentGreen : AppColor.accentRed)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColor.cardBackground)
        )
    }
}

// MARK: - Position Detail View

private struct PositionDetailView: View {
    let position: WalletPosition
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColor.backgroundPrimary
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 16) {
                            AsyncImage(url: URL(string: position.crypto.imageURL)) { phase in
                                switch phase {
                                case .empty:
                                    Circle()
                                        .fill(AppColor.accentYellow.opacity(0.2))
                                        .frame(width: 100, height: 100)
                                        .overlay(ProgressView().tint(AppColor.accentYellow))
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100, height: 100)
                                case .failure:
                                    Circle()
                                        .fill(AppColor.accentYellow.opacity(0.2))
                                        .frame(width: 100, height: 100)
                                        .overlay(
                                            Text(String(position.crypto.symbol.prefix(1)))
                                                .font(.system(size: 48, weight: .bold))
                                                .foregroundStyle(AppColor.accentYellow)
                                        )
                                @unknown default:
                                    Circle()
                                        .fill(AppColor.accentYellow.opacity(0.2))
                                        .frame(width: 100, height: 100)
                                }
                            }
                            
                            Text(position.crypto.name)
                                .font(AppFont.title)
                                .foregroundStyle(AppColor.textPrimary)
                            
                            Text(position.formattedAmount)
                                .font(AppFont.body)
                                .foregroundStyle(AppColor.textSecondary)
                        }
                        .padding(.top, 24)
                        
                        // Valeur actuelle
                        VStack(spacing: 8) {
                            Text("Valeur Actuelle")
                                .font(AppFont.label)
                                .foregroundStyle(AppColor.textSecondary)
                            
                            Text(position.formattedCurrentValue)
                                .font(.system(size: 48, weight: .bold))
                                .foregroundStyle(AppColor.textPrimary)
                        }
                        
                        // Stats détaillées
                        VStack(spacing: 16) {
                            DetailRow(
                                label: "Prix d'achat moyen",
                                value: String(format: "%.2f €", position.averageBuyPrice)
                            )
                            DetailRow(
                                label: "Prix actuel",
                                value: position.crypto.formattedPrice
                            )
                            DetailRow(
                                label: "Investissement initial",
                                value: String(format: "%.2f €", position.investedValue)
                            )
                            DetailRow(
                                label: "Profit/Perte",
                                value: position.formattedProfitLoss,
                                valueColor: position.isProfit ? AppColor.accentGreen : AppColor.accentRed
                            )
                            DetailRow(
                                label: "Rendement",
                                value: position.formattedProfitLossPercentage,
                                valueColor: position.isProfit ? AppColor.accentGreen : AppColor.accentRed
                            )
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(AppColor.cardBackground)
                        )
                        .padding(.horizontal, 16)
                        
                        // Graphique
                        CryptoChartView(
                            viewModel: CryptoChartViewModel(
                                model: CryptoChartModel(
                                    prices: position.crypto.generateMockPriceHistory(),
                                    isPositive: position.isProfit
                                )
                            )
                        )
                        .padding(.horizontal, 16)
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

// MARK: - Detail Row

private struct DetailRow: View {
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
    WalletView()
}

