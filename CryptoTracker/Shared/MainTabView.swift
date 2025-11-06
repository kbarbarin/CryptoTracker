//
//  MainTabView.swift
//  CryptoTracker
//
//  Created by Killian Barbarin on 05/11/2025.
//

import SwiftUI
import DesignSystem

struct MainTabView: View {
    @State private var selectedTab: Tab = .dashboard
    
    enum Tab {
        case dashboard
        case market
        case wallet
        case settings
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(Tab.dashboard)
            
            MarketView()
                .tabItem {
                    Label("Marché", systemImage: "chart.bar.fill")
                }
                .tag(Tab.market)
            
            WalletView()
                .tabItem {
                    Label("Portefeuille", systemImage: "wallet.pass.fill")
                }
                .tag(Tab.wallet)
            
            SettingsView()
                .tabItem {
                    Label("Paramètres", systemImage: "gearshape.fill")
                }
                .tag(Tab.settings)
        }
        .tint(AppColor.accentGreen)
        .preferredColorScheme(.dark)
        .onAppear {
            configureTabBarAppearance()
        }
    }
    
    private func configureTabBarAppearance() {
        // Configuration de l'apparence de la TabBar pour un style premium
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(AppColor.cardBackground)
        
        // Style des items non sélectionnés
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(AppColor.textSecondary)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(AppColor.textSecondary)
        ]
        
        // Style des items sélectionnés
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(AppColor.accentGreen)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(AppColor.accentGreen)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    MainTabView()
}

