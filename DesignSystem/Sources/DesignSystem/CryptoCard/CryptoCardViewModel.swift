import Foundation

@Observable
public final class CryptoCardViewModel {
    public let model: CryptoCardModel
    public let action: () -> Void
    
    public init(model: CryptoCardModel, action: @escaping () -> Void = {}) {
        self.model = model
        self.action = action
    }
    
    /// Retourne la couleur appropriée selon le changement
    public var changeColor: CryptoCardColor {
        model.isPositive ? .positive : .negative
    }
    
    /// Première lettre du symbole pour l'icône
    public var iconLetter: String {
        String(model.symbol.prefix(1))
    }
}

public enum CryptoCardColor {
    case positive
    case negative
}

