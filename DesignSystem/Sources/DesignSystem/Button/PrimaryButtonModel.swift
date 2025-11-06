import Foundation
import SwiftUI

public struct PrimaryButtonModel {
    public var title: String
    public var backgroundColor: Color
    public var textColor: Color
    public var cornerRadius: CGFloat

    public init(
        title: String,
        backgroundColor: Color = .blue,
        textColor: Color = .white,
        cornerRadius: CGFloat = 12
    ) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.cornerRadius = cornerRadius
    }
}
