//
//  SettingsView.swift
//  CryptoTracker
//
//  Created by Killian Barbarin on 05/11/2025.
//

import SwiftUI
import DesignSystem

struct SettingsView: View {
    @State private var viewModel = SettingsViewModel()
    @State private var toastViewModel = AppToastViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColor.backgroundPrimary
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Section App
                        SettingsSection(title: "Application") {
                            SettingsRow(
                                icon: "moon.fill",
                                label: "Mode Sombre",
                                value: "Activé"
                            )
                            
                            SettingsRow(
                                icon: "globe",
                                label: "Langue",
                                value: viewModel.language
                            )
                            
                            SettingsRow(
                                icon: "dollarsign.circle",
                                label: "Devise",
                                value: viewModel.currency
                            )
                        }
                        
                        // Section Compte
                        SettingsSection(title: "Compte Démo") {
                            Button(action: {
                                viewModel.resetDemoAccount()
                            }) {
                                HStack {
                                    Image(systemName: "arrow.clockwise.circle.fill")
                                        .font(.system(size: 24))
                                        .foregroundStyle(AppColor.accentRed)
                                    
                                    Text("Réinitialiser le compte")
                                        .font(AppFont.body)
                                        .foregroundStyle(AppColor.textPrimary)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14))
                                        .foregroundStyle(AppColor.textSecondary)
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColor.cardBackground)
                                )
                            }
                        }
                        
                        // Section Info
                        SettingsSection(title: "Informations") {
                            SettingsRow(
                                icon: "info.circle",
                                label: "Version",
                                value: viewModel.appVersion
                            )
                            
                            SettingsRow(
                                icon: "heart.fill",
                                label: "Développé par",
                                value: "Killian Barbarin"
                            )
                        }
                        
                        // Note POC
                        Text("🚀 Ceci est un prototype (POC)\nAucune transaction réelle")
                            .font(AppFont.label)
                            .foregroundStyle(AppColor.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.top, 16)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                }
                
                // Toast
                VStack {
                    AppToastView(viewModel: toastViewModel)
                        .padding(.top, 16)
                    Spacer()
                }
            }
            .navigationTitle("Paramètres")
            .navigationBarTitleDisplayMode(.large)
            .preferredColorScheme(.dark)
            .alert("Réinitialiser le compte", isPresented: $viewModel.showResetConfirmation) {
                Button("Annuler", role: .cancel) {
                    viewModel.cancelReset()
                }
                Button("Confirmer", role: .destructive) {
                    viewModel.confirmReset()
                }
            } message: {
                Text("Êtes-vous sûr de vouloir réinitialiser votre compte démo ? Cette action est irréversible.")
            }
            .onAppear {
                viewModel.onResetComplete = { message in
                    toastViewModel.show(message: message, type: .success)
                }
            }
        }
    }
}

// MARK: - Settings Section

private struct SettingsSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(AppFont.label)
                .foregroundStyle(AppColor.textSecondary)
                .textCase(.uppercase)
                .padding(.horizontal, 4)
            
            VStack(spacing: 8) {
                content
            }
        }
    }
}

// MARK: - Settings Row

private struct SettingsRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundStyle(AppColor.accentYellow)
                .frame(width: 32)
            
            Text(label)
                .font(AppFont.body)
                .foregroundStyle(AppColor.textPrimary)
            
            Spacer()
            
            Text(value)
                .font(AppFont.body)
                .foregroundStyle(AppColor.textSecondary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColor.cardBackground)
        )
    }
}

#Preview {
    SettingsView()
}

