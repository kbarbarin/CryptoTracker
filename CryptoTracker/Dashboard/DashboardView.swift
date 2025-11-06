//
//  DashboardView.swift
//  CryptoTracker
//
//  Created by Killian Barbarin on 05/11/2025.
//

import SwiftUI
import DesignSystem

struct DashboardView: View {
    @State private var viewModel = DashboardViewModel()
    @State private var toastViewModel = AppToastViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColor.backgroundPrimary
                    .ignoresSafeArea()
                
                if viewModel.isLoading {
                    LoadingOverlay()
                } else {
                    ScrollView {
                        VStack(spacing: 32) {
                            // Solde Total - Grand et centré
                            VStack(spacing: 16) {
                                Text("Solde Total")
                                    .font(AppFont.body)
                                    .foregroundStyle(AppColor.textSecondary)
                                
                                Text(viewModel.formattedBalance)
                                    .font(.system(size: 56, weight: .bold))
                                    .foregroundStyle(AppColor.textPrimary)
                                
                                // Détail euros disponibles
                                HStack(spacing: 4) {
                                    Text("dont")
                                        .font(AppFont.label)
                                        .foregroundStyle(AppColor.textSecondary)
                                    Text(String(format: "%.2f €", viewModel.euroBalance))
                                        .font(AppFont.label)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(AppColor.accentGreen)
                                    Text("disponibles")
                                        .font(AppFont.label)
                                        .foregroundStyle(AppColor.textSecondary)
                                }
                                
                                HStack(spacing: 8) {
                                    Text(viewModel.formattedProfitLoss)
                                        .font(AppFont.subtitle)
                                        .foregroundStyle(viewModel.isPositive ? AppColor.accentGreen : AppColor.accentRed)
                                    
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
                            .padding(.top, 24)
                            
                            // Graphique des performances
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Performance")
                                    .font(AppFont.body)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(AppColor.textPrimary)
                                    .padding(.horizontal, 16)
                                
                                CryptoChartView(
                                    viewModel: CryptoChartViewModel(
                                        model: CryptoChartModel(
                                            prices: viewModel.getChartPrices(),
                                            isPositive: viewModel.isPositive
                                        )
                                    )
                                )
                                .padding(.horizontal, 16)
                            }
                            
                            // Liste des actifs
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Text("Mes Actifs")
                                        .font(AppFont.subtitle)
                                        .foregroundStyle(AppColor.textPrimary)
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 16)
                                
                                ForEach(viewModel.walletPositions) { position in
                                    PositionCard(position: position)
                                        .padding(.horizontal, 16)
                                }
                            }
                        }
                        .padding(.vertical, 16)
                    }
                }
                
                // Toast
                VStack {
                    AppToastView(viewModel: toastViewModel)
                        .padding(.top, 16)
                    Spacer()
                }
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.large)
            .preferredColorScheme(.dark)
            .onAppear {
                viewModel.refresh()
            }
        }
    }
}

// MARK: - Position Card Component

private struct PositionCard: View {
    let position: WalletPosition
    
    var body: some View {
        HStack(spacing: 16) {
            // Icône crypto avec image
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
            
            // Info position
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
                    Text(position.formattedProfitLoss)
                        .font(AppFont.label)
                        .foregroundStyle(position.isProfit ? AppColor.accentGreen : AppColor.accentRed)
                    
                    Text("(\(position.formattedProfitLossPercentage))")
                        .font(AppFont.label)
                        .foregroundStyle(position.isProfit ? AppColor.accentGreen : AppColor.accentRed)
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

#Preview {
    DashboardView()
}

