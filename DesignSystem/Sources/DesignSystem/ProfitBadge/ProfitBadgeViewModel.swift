import Foundation

@Observable
public final class ProfitBadgeViewModel {
    public let model: ProfitBadgeModel
    
    public init(model: ProfitBadgeModel) {
        self.model = model
    }
    
    /// Icône appropriée selon le sens
    public var iconName: String {
        model.isPositive ? "arrow.up.right" : "arrow.down.right"
    }
    
    /// Couleur appropriée selon le sens
    public var badgeColor: BadgeColor {
        model.isPositive ? .positive : .negative
    }
}

public enum BadgeColor {
    case positive
    case negative
}

