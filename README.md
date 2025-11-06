# 🚀 CryptoTracker - Application iOS

## 📱 Description

CryptoTracker est une application iOS moderne développée en **SwiftUI** permettant de suivre le prix des cryptomonnaies en temps réel, visualiser les variations et effectuer des transactions via un compte démo (aucune transaction réelle).

Cette application est un **POC (Proof of Concept)** conçu pour démontrer une architecture propre et scalable pour une application de suivi de cryptomonnaies.

## ✨ Fonctionnalités

### 🏠 Dashboard
- Affichage du solde total du portefeuille
- Liste des cryptos possédées avec valeurs et variations
- Graphique d'évolution du portefeuille (30 jours)
- Actualisation automatique des prix
- Vue détaillée de chaque position

### 📊 Marché
- Liste complète des cryptomonnaies disponibles
- Prix actuels et variations sur 24h
- Barre de recherche pour filtrer les cryptos
- Détails complets de chaque crypto (prix, market cap, volume)
- Graphique de prix sur 30 jours

### 💱 Trade
- Interface intuitive d'achat/vente
- **Conversion automatique en temps réel** Crypto ↔ Fiat (EUR)
- **Boutons de vente rapide** : 25%, 50%, 75%, 100%
- Sélecteur de type de transaction (Achat/Vente)
- Affichage du solde disponible et quantité possédée
- **Pas d'autocomplétion** - contrôle total de la saisie
- Validation des transactions avec feedback visuel
- Compte démo avec 10,000 € de départ

### 💼 Portefeuille
- Vue d'ensemble de toutes les positions
- Valeur totale du portefeuille
- Profit/Perte par crypto et total
- Options de tri (par valeur ou P/L)
- Détails complets de chaque position

### ⚙️ Paramètres
- Mode sombre (activé par défaut)
- Réinitialisation du compte démo
- Informations sur l'application
- Version et crédits

## 🛠 Stack Technique

| Composant | Technologie |
|-----------|-------------|
| Langage | Swift 5.9+ |
| Framework UI | SwiftUI (iOS 17+) |
| Architecture | MVVM + Feature-based |
| État Management | @Observable + @Bindable |
| Charts | Swift Charts |
| Module Design | Swift Package Manager |
| Thème | Full Dark Mode Premium |

## 📁 Structure du Projet (Architecture par Feature)

```
CryptoTracker/
├── App/
│   ├── CryptoTrackerApp.swift         # Point d'entrée
│   └── ContentView.swift
│
├── Dashboard/
│   ├── DashboardView.swift            # Vue Dashboard
│   └── DashboardViewModel.swift       # Logique Dashboard
│
├── Market/
│   ├── MarketView.swift               # Vue Marché
│   └── MarketViewModel.swift          # Logique Marché
│
├── Trade/
│   ├── TradeView.swift                # Vue Trading
│   ├── TradeViewModel.swift           # Logique Trading
│   └── TradeModel.swift               # Modèle Transaction
│
├── Wallet/
│   ├── WalletView.swift               # Vue Portefeuille
│   ├── WalletViewModel.swift          # Logique Portefeuille
│   ├── WalletModel.swift              # Modèle Position
│   └── WalletManager.swift            # Manager singleton
│
├── Settings/
│   ├── SettingsView.swift             # Vue Paramètres
│   └── SettingsViewModel.swift        # Logique Paramètres
│
├── Shared/
│   ├── CryptoModel.swift              # Modèle Crypto
│   ├── CryptoImageHelper.swift        # Helper images
│   ├── PriceUpdateManager.swift       # Manager prix
│   └── MainTabView.swift              # Navigation principale
│
└── DesignSystem/                      # Package Swift séparé
    ├── Fondation/
    │   ├── AppColor.swift             # Palette de couleurs
    │   ├── AppFont.swift              # Typographie
    │   └── AppCard.swift              # Composant Card
    ├── Button/
    │   ├── PrimaryButtonView.swift
    │   ├── SecondaryButtonView.swift
    │   └── IconButtonView.swift
    ├── Input/
    │   ├── AppTextFieldView.swift
    │   └── AmountInputView.swift
    ├── Display/
    │   ├── CryptoCardView.swift
    │   ├── ProfitBadgeView.swift
    │   └── DashboardHeaderView.swift
    ├── Feedback/
    │   ├── AppToastView.swift
    │   └── AppLoaderView.swift
    └── Chart/
        └── CryptoChartView.swift
```

### 🏗️ Architecture Feature-based

Chaque fonctionnalité est **autonome** et contient tous ses fichiers :
- ✅ **Meilleure organisation** - Facile de trouver les fichiers
- ✅ **Cohérence** - Même approche que le Design System
- ✅ **Scalabilité** - Facile d'ajouter de nouvelles features
- ✅ **Maintenance** - Isolation des responsabilités

## 🎨 Design System

### Palette de Couleurs

| Nom | Hex | Utilisation |
|-----|-----|-------------|
| backgroundPrimary | `#0D0D0D` | Fond global |
| cardBackground | `#1A1A1A` | Blocs, cards |
| accentGreen | `#3DDC84` | Gain, bouton principal |
| accentRed | `#FF4D4D` | Perte |
| accentYellow | `#E5FF78` | Surbrillance |
| textPrimary | `#FFFFFF` | Texte principal |
| textSecondary | `#A3A3A3` | Texte gris clair |
| chartLine | `#FFD84C` | Courbe de prix |

### Typographie

| Style | Taille | Poids |
|-------|--------|-------|
| title | 34 | bold |
| subtitle | 22 | semibold |
| body | 16 | regular |
| label | 13 | medium |
| percentage | 14 | semibold |

### Style Global

- **Coins arrondis**: 20pt (cards), 12pt (inputs/buttons)
- **Espacement**: 16pt par défaut
- **Animation**: `.easeInOut(duration: 0.25)`
- **Mode**: Dark uniquement
- **Ombres**: `Color.black.opacity(0.4)`

## 🚀 Installation

### Prérequis

- macOS 14.0+ (Sonoma)
- Xcode 15.0+
- iOS 17.0+ (Simulateur ou appareil physique)

### Étapes

1. **Ouvrir le projet dans Xcode**
```bash
cd /Users/killianbarbarin/Desktop/IIM/CryptoTracker
open CryptoTracker.xcodeproj
```

2. **Le DesignSystem est automatiquement inclus**
   - Xcode 15+ synchronise automatiquement les fichiers
   - Aucune configuration manuelle nécessaire

3. **Compiler et lancer**
   - Sélectionner un simulateur iOS 17+
   - Appuyer sur `Cmd + R` pour lancer l'application

### En cas d'erreur de build

Si vous voyez "Multiple commands produce...", suivez ces étapes :

1. **Fermer Xcode complètement** (Cmd+Q)
2. **Nettoyer le cache** :
```bash
cd /Users/killianbarbarin/Desktop/IIM/CryptoTracker
rm -rf ~/Library/Developer/Xcode/DerivedData/CryptoTracker-*
xcodebuild clean -project CryptoTracker.xcodeproj -scheme CryptoTracker
```
3. **Rouvrir le projet** :
```bash
open CryptoTracker.xcodeproj
```
4. **Compiler** (Cmd+B)

## 📊 Données Mock

L'application utilise des données simulées pour les cryptomonnaies :

- **Bitcoin (BTC)** : ~43,000 € (varie)
- **Ethereum (ETH)** : ~2,250 € (varie)
- **BNB (BNB)** : ~315 € (varie)
- **Solana (SOL)** : ~98 € (varie)
- **Cardano (ADA)** : ~0.52 € (varie)

Le **compte démo** démarre avec **10,000 €** et peut être réinitialisé via les paramètres.

## 🔑 Fonctionnalités Techniques

### Architecture MVVM + Feature-based

Chaque feature suit le pattern MVVM et regroupe tous ses fichiers :
- **Model** : Structures de données (Codable, Identifiable)
- **View** : Interface SwiftUI déclarative
- **ViewModel** : Logique métier (@Observable)
- **Manager** : Services partagés (si nécessaire)

### Observation API (iOS 17+)

Utilisation de `@Observable` au lieu de `ObservableObject` pour une gestion d'état moderne et performante :

```swift
@Observable
final class TradeViewModel {
    var cryptoAmount: String = ""
    var fiatAmount: String = ""
    var isProcessing: Bool = false
    // Pas de @Published nécessaire !
}
```

### TextField Intelligent

**Aucun formatage automatique pendant la saisie** :
- Vous tapez "1000" → reste "1000" (pas de ".0" ajouté)
- Conversion en temps réel dans l'autre champ
- Détection du focus pour éviter les loops
- Support clavier Apple (physique et virtuel)

```swift
TextField("0.00", text: $viewModel.fiatAmount)
    .keyboardType(.decimalPad)
    .textContentType(.none)
    .autocorrectionDisabled()
    .focused($focusedField, equals: .fiat)
```

### Boutons de Vente Rapide

Vendre rapidement un pourcentage de vos avoirs :
- **25%** - Vendre un quart
- **50%** - Vendre la moitié
- **75%** - Vendre trois quarts
- **100%** - Vendre tout (utilise le montant exact)

### Design System Modulaire

Le DesignSystem est un package Swift séparé, réutilisable dans d'autres projets :

```swift
import DesignSystem

PrimaryButtonView(
    viewModel: PrimaryButtonViewModel(
        model: PrimaryButtonModel(title: "Acheter BTC"),
        action: { /* ... */ }
    )
)
```

### Swift Charts

Graphiques natifs avec Swift Charts pour des performances optimales :

```swift
CryptoChartView(
    viewModel: CryptoChartViewModel(
        model: CryptoChartModel(
            prices: [42000, 42500, 43000...],
            isPositive: true
        )
    )
)
```

### Mise à Jour des Prix

Les prix se mettent à jour automatiquement toutes les secondes via `PriceUpdateManager` :
- Variation aléatoire de ±0.5%
- Simulation de volatilité réaliste
- Arrêt automatique en arrière-plan

## 🎯 Roadmap

### Phase 1 (POC) ✅
- [x] Architecture MVVM + Feature-based
- [x] Design System complet
- [x] 5 écrans principaux
- [x] Navigation TabView
- [x] Données mockées avec variations
- [x] Charts dynamiques
- [x] TextField intelligent sans formatage
- [x] Boutons de vente rapide
- [x] Support clavier Apple

### Phase 2 (Future)
- [ ] Intégration API réelle (CoinGecko/Binance)
- [ ] Authentification utilisateur
- [ ] Persistance locale (Core Data / SwiftData)
- [ ] Notifications push
- [ ] Watchlist personnalisée
- [ ] Mode Portrait/Paysage
- [ ] iPad support
- [ ] Dark/Light mode toggle
- [ ] Multi-devises (USD, GBP, etc.)
- [ ] Historique des transactions

## 💡 Points Techniques Importants

### Gestion du Focus et TextFields

Pour éviter les loops de mise à jour entre les champs crypto et fiat :
```swift
@FocusState private var focusedField: FocusedField?

.onChange(of: viewModel.fiatAmount) { oldValue, newValue in
    // Calculer crypto seulement si on tape dans EUR
    guard focusedField == .fiat || focusedField == nil else { return }
    viewModel.updateCryptoFromFiatWithoutFormatting()
}
```

### Calcul 100% Précis

Pour éviter les erreurs de précision lors de la vente à 100% :
```swift
if percentage == 100.0 {
    amountToSell = ownedAmount  // Exact, pas d'arrondi !
} else {
    amountToSell = ownedAmount * (percentage / 100.0)
}
```

### UserDefaults Persistance

Le portefeuille est sauvegardé automatiquement dans UserDefaults :
- Solde EUR
- Positions crypto (quantité + prix moyen d'achat)
- Historique des transactions

## 🐛 Bugs Connus

Aucun bug connu actuellement. Si vous rencontrez un problème :
1. Fermez et rouvrez Xcode
2. Nettoyez le DerivedData
3. Vérifiez que vous êtes sur iOS 17+

## 👤 Auteur

**Killian Barbarin**
- École : IIM Digital School
- Date : Novembre 2025

## 📝 Licence

Ce projet est un POC éducatif. Aucune utilisation commerciale.

## 🙏 Remerciements

- Design inspiré de Binance, Coinbase et Crypto.com
- SwiftUI et Swift Charts par Apple
- Icônes : SF Symbols

---

**⚠️ Attention** : Cette application est un prototype (POC). Aucune transaction réelle n'est effectuée. Les prix et les données sont simulés.

**🚀 Bon trading (virtuel) !**
