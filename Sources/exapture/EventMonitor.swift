import Foundation
import CoreGraphics
import AppKit

class EventMonitor {
    private var eventTap: CFMachPort?
    private let onRightClick: () -> Void
    private let onMouseMove: (CGPoint) -> Void
    private let onEscapeKey: () -> Void
    
    init(onRightClick: @escaping () -> Void, 
         onMouseMove: @escaping (CGPoint) -> Void,
         onEscapeKey: @escaping () -> Void) {
        self.onRightClick = onRightClick
        self.onMouseMove = onMouseMove
        self.onEscapeKey = onEscapeKey
    }
    
    func start() {
        let eventMask = (1 << CGEventType.rightMouseDown.rawValue) | 
                       (1 << CGEventType.mouseMoved.rawValue) |
                       (1 << CGEventType.keyDown.rawValue)
        
        guard let eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(eventMask),
            callback: { (proxy, type, event, refcon) -> Unmanaged<CGEvent>? in
                guard let refcon = refcon else { return Unmanaged.passUnretained(event) }
                
                let monitor = Unmanaged<EventMonitor>.fromOpaque(refcon).takeUnretainedValue()
                return monitor.handleEvent(proxy: proxy, type: type, event: event)
            },
            userInfo: Unmanaged.passUnretained(self).toOpaque()
        ) else {
            print("Failed to create event tap. Make sure to grant accessibility permissions.")
            return
        }
        
        self.eventTap = eventTap
        
        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap, enable: true)
    }
    
    func stop() {
        if let eventTap = eventTap {
            CGEvent.tapEnable(tap: eventTap, enable: false)
            CFMachPortInvalidate(eventTap)
            self.eventTap = nil
        }
    }
    
    private func handleEvent(proxy: CGEventTapProxy, 
                           type: CGEventType, 
                           event: CGEvent) -> Unmanaged<CGEvent>? {
        switch type {
        case .rightMouseDown:
            onRightClick()
            return nil // Consume the event
            
        case .mouseMoved:
            let location = event.location
            onMouseMove(location)
            return Unmanaged.passUnretained(event)
            
        case .keyDown:
            let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
            if keyCode == 53 { // ESC key
                onEscapeKey()
                return nil
            }
            return Unmanaged.passUnretained(event)
            
        default:
            return Unmanaged.passUnretained(event)
        }
    }
}