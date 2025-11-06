import Foundation
import SwiftUI

@Observable
public class PrimaryButtonViewModel {
    public var model: PrimaryButtonModel
    public var isLoading: Bool
    public var isDisabled: Bool
    public var action: () -> Void

    public init(
        model: PrimaryButtonModel,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.model = model
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }

    public func onTap() {
        guard !isDisabled else { return }
        isLoading = true
        Task {
            await Task.sleep(1_000_000_000) // Simule une courte attente (1 sec)
            isLoading = false
            action()
        }
    }
}
