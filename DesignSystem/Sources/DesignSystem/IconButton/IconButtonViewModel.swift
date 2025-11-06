import Foundation

@Observable
public final class IconButtonViewModel {
    public let model: IconButtonModel
    public let action: () -> Void
    
    public init(model: IconButtonModel, action: @escaping () -> Void) {
        self.model = model
        self.action = action
    }
}

