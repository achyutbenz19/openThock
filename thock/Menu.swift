import SwiftUI

struct Menu: View {
    @ObservedObject var settingsViewModel: SettingsViewModel
    @State private var hoverEffect = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "keyboard")
                Text("Enable thock")
                Spacer()
                Toggle("Enable thock", isOn: $settingsViewModel.isThockEnabled)
                    .labelsHidden()
                    .scaleEffect(0.75)
            }
            .toggleStyle(SwitchToggleStyle(tint: .blue))
            .padding(2)
            
            HStack {
                Image(systemName: "speaker.wave.3")
                Text("Volume")
                Spacer()
            }
            .accentColor(.blue)
            .buttonStyle(PlainButtonStyle())
            .padding(2)
            
            Slider(value: $settingsViewModel.volumeLevel, in: 0...100).transition(.opacity)
            
            Divider()
            
            HStack {
                Image(systemName: "door.left.hand.open")
                Text("Quit")
                Spacer()
            }
            .padding(4)
            .onTapGesture {
                quitApplication()
            }
        }
        .padding(8)
        .frame(width: 200)
    }

    private func quitApplication() {
        NSApplication.shared.terminate(nil)
    }
}

struct BluetoothSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Menu(settingsViewModel: SettingsViewModel())
    }
}
