import Cocoa
import SwiftUI
import AppKit

class KeyListener: ObservableObject {
    private var eventTap: CFMachPort?

    init() {
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
            callback: { (proxy, type, event, refcon) -> Unmanaged<CGEvent>? in
                if type == .keyDown {
                    let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
                    print("Key Pressed: \(keyCode)")

                    if let sound = NSSound(named: NSSound.Name("Hero"))?.copy() as? NSSound {
                        sound.play()
                    }
                }

                return Unmanaged.passRetained(event)
            },
            userInfo: nil
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
}
