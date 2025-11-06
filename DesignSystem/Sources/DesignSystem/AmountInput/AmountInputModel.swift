import SwiftUI

public struct AmountInputModel {
    public let placeholder: String
    public let symbol: String
    public let keyboardType: UIKeyboardType
    
    public init(
        placeholder: String,
        symbol: String,
        keyboardType: UIKeyboardType = .decimalPad
    ) {
        self.placeholder = placeholder
        self.symbol = symbol
        self.keyboardType = keyboardType
    }
}

