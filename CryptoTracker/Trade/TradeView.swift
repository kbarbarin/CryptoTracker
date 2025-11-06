//
//  TradeView.swift
//  CryptoTracker
//
//  Created by Killian Barbarin on 05/11/2025.
//

import SwiftUI
import DesignSystem

struct TradeView: View {
    @State private var viewModel: TradeViewModel
    @State private var toastViewModel = AppToastViewModel()
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: FocusedField?
    
    enum FocusedField {
        case crypto
        case fiat
    }
    
    init(crypto: CryptoModel = CryptoModel.mock) {
        _viewModel = State(initialValue: TradeViewModel(selectedCrypto: crypto))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColor.backgroundPrimary
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header - Crypto sélectionnée
                        VStack(spacing: 16) {
                            AsyncImage(url: URL(string: viewModel.selectedCrypto.imageURL)) { phase in
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
                                            Text(String(viewModel.selectedCrypto.symbol.prefix(1)))
                                                .font(.system(size: 36, weight: .bold))
                                                .foregroundStyle(AppColor.accentYellow)
                                        )
                                @unknown default:
                                    Circle()
                                        .fill(AppColor.accentYellow.opacity(0.2))
                                        .frame(width: 80, height: 80)
                                }
                            }
                            
                            Text(viewModel.selectedCrypto.name)
                                .font(AppFont.title)
                                .foregroundStyle(AppColor.textPrimary)
                            
                            Text(viewModel.selectedCrypto.formattedPrice)
                                .font(AppFont.subtitle)
                                .foregroundStyle(AppColor.textSecondary)
                        }
                        .padding(.top, 24)
                        
                        // Sélecteur Achat/Vente
                        TradeTypeSelector(tradeType: $viewModel.tradeType)
                            .padding(.horizontal, 16)
                        
                        // Solde disponible
                        VStack(spacing: 12) {
                            BalanceCard(
                                title: "Solde disponible",
                                value: viewModel.formattedBalance,
                                color: AppColor.accentGreen
                            )
                            
                            if viewModel.tradeType == .sell && viewModel.ownedAmount > 0 {
                                BalanceCard(
                                    title: "Vous possédez",
                                    value: viewModel.formattedOwnedAmount,
                                    color: AppColor.accentYellow
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        
                        // Boutons de pourcentage pour la vente
                        if viewModel.tradeType == .sell && viewModel.ownedAmount > 0 {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Vendre rapidement")
                                    .font(AppFont.label)
                                    .foregroundStyle(AppColor.textSecondary)
                                
                                HStack(spacing: 12) {
                                    ForEach([25, 50, 75, 100], id: \.self) { percentage in
                                        Button(action: {
                                            viewModel.setSellPercentage(Double(percentage))
                                        }) {
                                            Text("\(percentage)%")
                                                .font(AppFont.body)
                                                .fontWeight(.semibold)
                                                .foregroundStyle(AppColor.textPrimary)
                                                .frame(maxWidth: .infinity)
                                                .padding(.vertical, 12)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .fill(AppColor.cardBackground)
                                                )
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(AppColor.accentYellow, lineWidth: 1.5)
                                                )
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        
                        // Champs de montant
                        VStack(spacing: 16) {
                            // Montant Crypto
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Montant \(viewModel.selectedCrypto.symbol)")
                                    .font(AppFont.label)
                                    .foregroundStyle(AppColor.textSecondary)
                                
                                HStack(spacing: 12) {
                                    TextField("0.000000", text: $viewModel.cryptoAmount)
                                        .font(AppFont.subtitle)
                                        .foregroundStyle(AppColor.textPrimary)
                                        .keyboardType(.numbersAndPunctuation)
                                        .textContentType(.none)
                                        .autocorrectionDisabled()
                                        .textInputAutocapitalization(.never)
                                        .disableAutocorrection(true)
                                        .focused($focusedField, equals: .crypto)
                                        .padding(.vertical, 16)
                                        .onChange(of: viewModel.cryptoAmount) { oldValue, newValue in
                                            // Calculer EUR seulement si on est en train de taper dans crypto
                                            guard focusedField == .crypto || focusedField == nil else { return }
                                            
                                            if newValue.isEmpty {
                                                viewModel.fiatAmount = ""
                                            } else if !newValue.isEmpty {
                                                viewModel.updateFiatFromCryptoWithoutFormatting()
                                            }
                                        }
                                    
                                    Text(viewModel.selectedCrypto.symbol)
                                        .font(AppFont.body)
                                        .foregroundStyle(AppColor.textSecondary)
                                        .padding(.trailing, 8)
                                }
                                .padding(.horizontal, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColor.cardBackground)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            viewModel.cryptoAmount.isEmpty ? AppColor.textSecondary.opacity(0.3) : AppColor.accentGreen,
                                            lineWidth: 1.5
                                        )
                                )
                            }
                            
                            // Icône de conversion
                            Image(systemName: "arrow.up.arrow.down")
                                .font(.system(size: 20))
                                .foregroundStyle(AppColor.textSecondary)
                            
                            // Montant Fiat
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Montant EUR")
                                    .font(AppFont.label)
                                    .foregroundStyle(AppColor.textSecondary)
                                
                                HStack(spacing: 12) {
                                    TextField("0.00", text: $viewModel.fiatAmount)
                                        .font(AppFont.subtitle)
                                        .foregroundStyle(AppColor.textPrimary)
                                        .keyboardType(.numbersAndPunctuation)
                                        .textContentType(.none)
                                        .autocorrectionDisabled()
                                        .textInputAutocapitalization(.never)
                                        .disableAutocorrection(true)
                                        .focused($focusedField, equals: .fiat)
                                        .padding(.vertical, 16)
                                        .onChange(of: viewModel.fiatAmount) { oldValue, newValue in
                                            // Calculer crypto seulement si on est en train de taper dans EUR
                                            guard focusedField == .fiat || focusedField == nil else { return }
                                            
                                            if newValue.isEmpty {
                                                viewModel.cryptoAmount = ""
                                            } else if !newValue.isEmpty {
                                                viewModel.updateCryptoFromFiatWithoutFormatting()
                                            }
                                        }
                                    
                                    Text("EUR")
                                        .font(AppFont.body)
                                        .foregroundStyle(AppColor.textSecondary)
                                        .padding(.trailing, 8)
                                }
                                .padding(.horizontal, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColor.cardBackground)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            viewModel.fiatAmount.isEmpty ? AppColor.textSecondary.opacity(0.3) : AppColor.accentGreen,
                                            lineWidth: 1.5
                                        )
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        
                        // Message d'erreur
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .font(AppFont.body)
                                .foregroundStyle(AppColor.accentRed)
                                .padding(.horizontal, 16)
                        }
                        
                        // Bouton d'exécution
                        PrimaryButtonView(
                            viewModel: PrimaryButtonViewModel(
                                model: PrimaryButtonModel(
                                    title: viewModel.tradeType == .buy ? "Acheter \(viewModel.selectedCrypto.symbol)" : "Vendre \(viewModel.selectedCrypto.symbol)"
                                ),
                                action: {
                                    viewModel.executeTrade()
                                }
                            )
                        )
                        .disabled(!viewModel.isValidTrade || viewModel.isProcessing)
                        .opacity(viewModel.isValidTrade ? 1.0 : 0.5)
                        .padding(.horizontal, 16)
                        
                        // Loader pendant le traitement
                        if viewModel.isProcessing {
                            AppLoaderView()
                        }
                    }
                    .padding(.vertical, 16)
                }
                
                // Toast
                VStack {
                    AppToastView(viewModel: toastViewModel)
                        .padding(.top, 16)
                    Spacer()
                }
            }
            .navigationTitle("Trade")
            .navigationBarTitleDisplayMode(.large)
            .preferredColorScheme(.dark)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Terminé") {
                        focusedField = nil
                    }
                    .foregroundStyle(AppColor.accentGreen)
                }
            }
            .onAppear {
                viewModel.onTradeComplete = { message, success in
                    toastViewModel.show(
                        message: message,
                        type: success ? .success : .error
                    )
                    
                    // Fermer après un trade réussi
                    if success {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Trade Type Selector

private struct TradeTypeSelector: View {
    @Binding var tradeType: TradeType
    
    var body: some View {
        HStack(spacing: 0) {
            Button(action: { tradeType = .buy }) {
                Text("Acheter")
                    .font(AppFont.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(tradeType == .buy ? AppColor.backgroundPrimary : AppColor.textPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        tradeType == .buy ? AppColor.accentGreen : Color.clear
                    )
            }
            
            Button(action: { tradeType = .sell }) {
                Text("Vendre")
                    .font(AppFont.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(tradeType == .sell ? AppColor.backgroundPrimary : AppColor.textPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        tradeType == .sell ? AppColor.accentRed : Color.clear
                    )
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColor.cardBackground)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .animation(.easeInOut(duration: 0.25), value: tradeType)
    }
}

// MARK: - Balance Card

private struct BalanceCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Text(title)
                .font(AppFont.body)
                .foregroundStyle(AppColor.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(AppFont.body)
                .fontWeight(.semibold)
                .foregroundStyle(color)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColor.cardBackground)
        )
    }
}

#Preview {
    TradeView()
}


