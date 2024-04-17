import SwiftUI

@main
struct thockApp: App {
    var body: some Scene {
        MenuBarExtra("Menu", systemImage: "sparkles") {
            Menu()
        }
        .menuBarExtraStyle(.window)
    }
}
