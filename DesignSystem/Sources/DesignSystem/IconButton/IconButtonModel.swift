import Foundation

public struct IconButtonModel {
    public let iconName: String
    public let size: CGFloat
    
    public init(iconName: String, size: CGFloat = 24) {
        self.iconName = iconName
        self.size = size
    }
}

