import SwiftUI
import Observation

@Observable
public class AppTextFieldViewModel {
    public var model: AppTextFieldModel
    public var text: String = ""
    
    public init(model: AppTextFieldModel) {
        self.model = model
    }
}
