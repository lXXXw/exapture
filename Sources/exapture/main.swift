import Foundation
import ArgumentParser
import AppKit

struct Exapture: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "exapture",
        abstract: "A precise screenshot tool with cursor-following overlay"
    )
    
    @Option(name: .shortAndLong, help: "Screenshot width (default: 1280)")
    var width: Int = 1280
    
    @Option(name: .shortAndLong, help: "Screenshot height (default: 800)")
    var height: Int = 800
    
    func run() throws {
        let app = NSApplication.shared
        app.setActivationPolicy(.accessory)
        
        let captureController = CaptureController(width: width, height: height)
        
        print("Exapture started - Right click to capture, ESC to exit")
        print("Capture size: \(width) x \(height)")
        
        captureController.start()
        app.run()
    }
}

Exapture.main()