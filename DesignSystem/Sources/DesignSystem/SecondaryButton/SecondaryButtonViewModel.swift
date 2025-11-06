import Foundation

@Observable
public final class SecondaryButtonViewModel {
    public let model: SecondaryButtonModel
    public let action: () -> Void
    
    public init(model: SecondaryButtonModel, action: @escaping () -> Void) {
        self.model = model
        self.action = action
    }
}

