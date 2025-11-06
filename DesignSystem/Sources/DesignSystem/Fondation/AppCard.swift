import SwiftUI

public struct AppCard<Content: View>: View {
    let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColor.cardBackground)
                    .shadow(color: AppColor.softShadow, radius: 10, x: 0, y: 5)
            )
    }
}
