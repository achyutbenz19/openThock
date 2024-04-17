import SwiftUI

@main
struct ThockApp: App {
    @StateObject var settingsViewModel = SettingsViewModel()
    @StateObject private var keyListener = KeyListener()
    
    var body: some Scene {
        
        MenuBarExtra("Menu", systemImage: "keyboard.macwindow") {
            Menu(settingsViewModel: settingsViewModel)
        }
        .menuBarExtraStyle(.window)
        .environmentObject(keyListener)
    }
}
