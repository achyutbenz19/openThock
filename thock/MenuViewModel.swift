import Foundation
import Combine

class SettingsViewModel: ObservableObject {
    @Published var isThockEnabled: Bool = true
    @Published var volumeLevel: Double = 50
}
