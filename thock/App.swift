import SwiftUI

@main
struct thockApp: App {
    var body: some Scene {
        MenuBarExtra("Menu", systemImage: "keyboard.macwindow") {
            Menu()
        }
        .menuBarExtraStyle(.window)
    }
}
