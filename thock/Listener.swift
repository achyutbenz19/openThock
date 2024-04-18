import Cocoa
import SwiftUI
import AppKit

class KeyListener: ObservableObject {
    private var eventTap: CFMachPort?
    @ObservedObject var settings: SettingsViewModel
    private var activeKeys: Set<CGKeyCode> = []

    init(settings: SettingsViewModel) {
        self.settings = settings
        setupEventTap()
    }

    deinit {
        stopListening()
    }

    private func setupEventTap() {
        let eventMask = (1 << CGEventType.keyDown.rawValue) | (1 << CGEventType.keyUp.rawValue)
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
        let keyCode = CGKeyCode(event.getIntegerValueField(.keyboardEventKeycode))
        switch type {
        case .keyDown:
            if !activeKeys.contains(keyCode) {
                activeKeys.insert(keyCode)
                if settings.isThockEnabled {
                    playSoundForKeyPress()
                }
            }
        case .keyUp:
            activeKeys.remove(keyCode)
        default:
            break
        }
        return Unmanaged.passRetained(event)
    }

    private func playSoundForKeyPress() {
        if let soundURL = Bundle.main.url(forResource: "thock", withExtension: "wav"),
           let sound = NSSound(contentsOf: soundURL, byReference: false) {
            sound.volume = Float(CGFloat(settings.volumeLevel / 100.0))
            sound.play()
        } else {
            print("Failed to load sound.")
        }
    }
}
