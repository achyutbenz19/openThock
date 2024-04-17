import SwiftUI
import Combine

@main
struct ThockApp: App {
    @StateObject var settingsViewModel = SettingsViewModel()
    @StateObject private var keyListener: KeyListener

    init() {
        let settingsViewModel = SettingsViewModel()
        _settingsViewModel = StateObject(wrappedValue: settingsViewModel)
        _keyListener = StateObject(wrappedValue: KeyListener(settings: settingsViewModel))
    }

    var body: some Scene {
        MenuBarExtra("Menu", systemImage: "keyboard.macwindow") {
            Menu(settingsViewModel: settingsViewModel)
        }
        .menuBarExtraStyle(.window)
        .environmentObject(keyListener)
    }
}
