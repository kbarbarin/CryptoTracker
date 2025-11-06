import SwiftUI

public struct AppTextFieldModel {
    public let placeholder: String
    public let keyboardType: UIKeyboardType
    public let isSecure: Bool
    
    public init(
        placeholder: String,
        keyboardType: UIKeyboardType = .default,
        isSecure: Bool = false
    ) {
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.isSecure = isSecure
    }
}
