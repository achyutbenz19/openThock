import SwiftUI

struct Sound: View {
    @ObservedObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        VStack {
            Text("Thock is \(settingsViewModel.isThockEnabled ? "Enabled" : "Disabled")")
            Text("Volume Level is \(Int(settingsViewModel.volumeLevel))")
        }
    }
}

