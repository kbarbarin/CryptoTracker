import Foundation

@Observable
public final class DashboardHeaderViewModel {
    public let model: DashboardHeaderModel
    
    public init(model: DashboardHeaderModel) {
        self.model = model
    }
    
    /// Couleur du changement
    public var changeColor: ChangeColor {
        model.isPositive ? .positive : .negative
    }
    
    /// Badge pour afficher le pourcentage
    public var profitBadgeViewModel: ProfitBadgeViewModel {
        ProfitBadgeViewModel(
            model: ProfitBadgeModel(
                value: model.changePercentage,
                isPositive: model.isPositive
            )
        )
    }
}

public enum ChangeColor {
    case positive
    case negative
}

