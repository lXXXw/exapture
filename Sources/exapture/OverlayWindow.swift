import Foundation
import AppKit
import CoreGraphics

class DashedBorderView: NSView {
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        guard let context = NSGraphicsContext.current?.cgContext else { return }
        
        // Set up the dashed line
        context.setStrokeColor(NSColor.systemRed.withAlphaComponent(0.7).cgColor)
        context.setLineWidth(2.0)
        context.setLineDash(phase: 0, lengths: [8.0, 4.0]) // 8pt dash, 4pt gap
        
        // Draw the border rectangle
        let borderRect = bounds.insetBy(dx: 1.0, dy: 1.0) // Inset to avoid clipping
        context.stroke(borderRect)
    }
}

class OverlayWindow: NSWindow {
    private let dimensionLabel: NSTextField
    private let borderView: DashedBorderView
    private let captureWidth: Int
    private let captureHeight: Int
    
    init(width: Int, height: Int) {
        self.captureWidth = width
        self.captureHeight = height
        
        // Create border view
        self.borderView = DashedBorderView()
        
        // Create dimension label
        self.dimensionLabel = NSTextField(labelWithString: "\(width) × \(height)")
        
        // Initialize the window with zero frame - we'll update it when cursor moves
        super.init(
            contentRect: NSMakeRect(0, 0, CGFloat(width), CGFloat(height)),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        
        // Configure window properties
        self.level = NSWindow.Level.screenSaver
        self.backgroundColor = NSColor.clear
        self.isOpaque = false
        self.hasShadow = false
        self.ignoresMouseEvents = true
        self.collectionBehavior = [.canJoinAllSpaces, .stationary]
        
        // Configure border view
        borderView.frame = contentView!.bounds
        borderView.wantsLayer = false // Use custom drawing instead of layer
        
        // Configure dimension label
        dimensionLabel.textColor = NSColor.systemRed.withAlphaComponent(0.8)
        dimensionLabel.backgroundColor = NSColor.black.withAlphaComponent(0.5)
        dimensionLabel.font = NSFont.monospacedSystemFont(ofSize: 14, weight: .medium)
        dimensionLabel.alignment = .center
        dimensionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add views
        contentView?.addSubview(borderView)
        contentView?.addSubview(dimensionLabel)
        
        // Setup constraints for label positioning (top-left corner)
        NSLayoutConstraint.activate([
            dimensionLabel.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 4),
            dimensionLabel.topAnchor.constraint(equalTo: contentView!.topAnchor, constant: 4)
        ])
    }
    
    func updatePosition(cursorLocation: CGPoint) {
        // cursorLocation from CGEvent uses top-left origin, but NSWindow expects bottom-left origin
        // Convert from CoreGraphics coordinates (top-left) to AppKit coordinates (bottom-left)
        // Position the window so the cursor is at the TOP-LEFT corner of the overlay
        guard let screen = NSScreen.main else { return }
        let screenHeight = screen.frame.height
        
        let windowRect = NSMakeRect(
            cursorLocation.x,
            screenHeight - cursorLocation.y - CGFloat(captureHeight), // Position so cursor is at top-left of overlay
            CGFloat(captureWidth),
            CGFloat(captureHeight)
        )
        
        setFrame(windowRect, display: true, animate: false)
    }
    
    func show() {
        orderFrontRegardless()
    }
    
    func hide() {
        orderOut(nil)
    }
}

class CaptureController {
    private let overlayWindow: OverlayWindow
    private var eventMonitor: EventMonitor?
    private let screenCapture: ScreenCapture
    private let captureWidth: Int
    private let captureHeight: Int
    private var lastCursorPosition: CGPoint = CGPoint.zero
    
    init(width: Int, height: Int) {
        self.captureWidth = width
        self.captureHeight = height
        self.overlayWindow = OverlayWindow(width: width, height: height)
        self.screenCapture = ScreenCapture()
        
        self.eventMonitor = EventMonitor(
            onRightClick: { [weak self] in
                self?.captureScreenshot()
            },
            onMouseMove: { [weak self] location in
                self?.lastCursorPosition = location
                self?.overlayWindow.updatePosition(cursorLocation: location)
            },
            onEscapeKey: {
                NSApplication.shared.terminate(nil)
            }
        )
    }
    
    func start() {
        // Get initial cursor position and set overlay there
        let initialCursorLocation = NSEvent.mouseLocation
        // Convert from AppKit coordinates to CGEvent coordinates for consistency
        guard let screen = NSScreen.main else { return }
        let screenHeight = screen.frame.height
        let cgEventLocation = CGPoint(
            x: initialCursorLocation.x,
            y: screenHeight - initialCursorLocation.y
        )
        
        lastCursorPosition = cgEventLocation
        overlayWindow.updatePosition(cursorLocation: cgEventLocation)
        overlayWindow.show()
        eventMonitor?.start()
    }
    
    private func captureScreenshot() {
        // Use the same cursor position that was used to position the overlay
        let cursorLocation = lastCursorPosition
        
        // Hide overlay before capture
        overlayWindow.hide()
        
        // Small delay to ensure overlay is hidden
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            
            // Use the EXACT same coordinate conversion as the overlay positioning
            guard let screen = NSScreen.main else { return }
            let screenHeight = screen.frame.height
            
            // Convert from CGEvent coordinates (top-left origin) to CoreGraphics coordinates (top-left origin)
            // This should match exactly what the overlay shows
            let topLeftX = cursorLocation.x
            let topLeftY = cursorLocation.y
            
            // Create capture rect using the exact same coordinates as the overlay
            let captureRect = CGRect(
                x: topLeftX,
                y: topLeftY,
                width: CGFloat(self.captureWidth),
                height: CGFloat(self.captureHeight)
            )
            
            print("=== COORDINATE MATCH DEBUG ===")
            print("Cursor location (CGEvent): \(cursorLocation)")
            print("Screen height: \(screenHeight)")
            print("Capture rect (CG): \(captureRect)")
            print("Target size: \(self.captureWidth) × \(self.captureHeight)")
            
            if let filename = self.screenCapture.captureSimple(rect: captureRect, targetWidth: self.captureWidth, targetHeight: self.captureHeight) {
                print("Screenshot saved: \(filename)")
            } else {
                print("Failed to capture screenshot")
            }
            
            self.overlayWindow.show()
        }
    }
}