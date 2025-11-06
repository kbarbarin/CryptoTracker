import Foundation

@Observable
public final class AmountInputViewModel {
    public let model: AmountInputModel
    public var text: String = ""
    
    public init(model: AmountInputModel) {
        self.model = model
    }
    
    /// Valeur numérique de l'input
    public var numericValue: Double {
        Double(text) ?? 0.0
    }
    
    /// Vérifie si l'input est valide
    public var isValid: Bool {
        numericValue > 0
    }
}

