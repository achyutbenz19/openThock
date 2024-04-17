import SwiftUI

@main
struct ThockApp: App {
    @StateObject var settingsViewModel = SettingsViewModel()
    
    var body: some Scene {
        MenuBarExtra("Menu", systemImage: "keyboard.macwindow") {
            Menu(settingsViewModel: settingsViewModel)
        }
        .menuBarExtraStyle(.window)
        
        WindowGroup {
            Sound(settingsViewModel: settingsViewModel)
        }
    }
}
