import Cocoa
import SwiftUI
import AppKit

class KeyListener: ObservableObject {
    private var eventTap: CFMachPort?
    @ObservedObject var settings: SettingsViewModel

    init(settings: SettingsViewModel) {
        self.settings = settings
        setupEventTap()
    }

    deinit {
        stopListening()
    }

    private func setupEventTap() {
        let eventMask = (1 << CGEventType.keyDown.rawValue)
        eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(eventMask),
            callback: KeyListener.eventCallback,
            userInfo: Unmanaged.passUnretained(self).toOpaque()
        )

        if let eventTap = eventTap {
            let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
            CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
            CGEvent.tapEnable(tap: eventTap, enable: true)
        }
    }

    func stopListening() {
        if let eventTap = eventTap {
            CGEvent.tapEnable(tap: eventTap, enable: false)
        }
    }

    private static let eventCallback: CGEventTapCallBack = { (proxy, type, event, refcon) -> Unmanaged<CGEvent>? in
        guard let refcon = refcon else { return Unmanaged.passRetained(event) }
        let mySelf = Unmanaged<KeyListener>.fromOpaque(refcon).takeUnretainedValue()
        return mySelf.handleEvent(proxy: proxy, type: type, event: event)
    }

    private func handleEvent(proxy: CGEventTapProxy?, type: CGEventType, event: CGEvent) -> Unmanaged<CGEvent>? {
        if type == .keyDown && settings.isThockEnabled {
            let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
            print("Key Pressed: \(keyCode)")

            if let sound = NSSound(named: NSSound.Name("Hero"))?.copy() as? NSSound {
                sound.play()
            }
        }
        return Unmanaged.passRetained(event)
    }
}
