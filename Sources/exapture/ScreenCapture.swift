import Foundation
import CoreGraphics
import ImageIO
import UniformTypeIdentifiers
import AppKit

class ScreenCapture {
    
    func capture(rect: CGRect) -> String? {
        guard let display = CGMainDisplayID() as CGDirectDisplayID?,
              let image = CGDisplayCreateImage(display, rect: rect) else {
            return nil
        }
        
        let filename = generateFilename()
        let url = URL(fileURLWithPath: filename)
        
        guard let destination = CGImageDestinationCreateWithURL(
            url as CFURL,
            UTType.png.identifier as CFString,
            1,
            nil
        ) else {
            return nil
        }
        
        CGImageDestinationAddImage(destination, image, nil)
        
        if CGImageDestinationFinalize(destination) {
            return filename
        }
        
        return nil
    }
    
    func captureSimple(rect: CGRect, targetWidth: Int, targetHeight: Int) -> String? {
        // Get the full screen image first
        guard let display = CGMainDisplayID() as CGDirectDisplayID?,
              let fullScreenImage = CGDisplayCreateImage(display) else {
            print("Failed to create full screen image")
            return nil
        }
        
        // Get screen scale factor
        guard let screen = NSScreen.main else { return nil }
        let scale = screen.backingScaleFactor
        
        // Convert our logical rect to the actual pixels in the screen image
        let scaledRect = CGRect(
            x: rect.origin.x * scale,
            y: rect.origin.y * scale,
            width: rect.size.width * scale,
            height: rect.size.height * scale
        )
        
        print("Full screen size: \(fullScreenImage.width) × \(fullScreenImage.height)")
        print("Scaled rect: \(scaledRect)")
        
        // Crop the image to our desired area
        guard let croppedImage = fullScreenImage.cropping(to: scaledRect) else {
            print("Failed to crop image")
            return nil
        }
        
        // Create a new image context with our exact target size
        guard let colorSpace = CGColorSpace(name: CGColorSpace.sRGB) else { return nil }
        guard let context = CGContext(
            data: nil,
            width: targetWidth,
            height: targetHeight,
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue
        ) else { return nil }
        
        // Draw the cropped image into our target size context
        context.draw(croppedImage, in: CGRect(x: 0, y: 0, width: targetWidth, height: targetHeight))
        
        // Get the final image
        guard let finalImage = context.makeImage() else { return nil }
        
        // Save it
        let filename = generateFilename()
        let url = URL(fileURLWithPath: filename)
        
        guard let destination = CGImageDestinationCreateWithURL(
            url as CFURL,
            UTType.png.identifier as CFString,
            1,
            nil
        ) else {
            return nil
        }
        
        CGImageDestinationAddImage(destination, finalImage, nil)
        
        if CGImageDestinationFinalize(destination) {
            print("Final image size: \(finalImage.width) × \(finalImage.height)")
            return filename
        }
        
        return nil
    }
    
    private func generateFilename() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        let timestamp = formatter.string(from: Date())
        
        let desktopPath = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true).first ?? "."
        return "\(desktopPath)/exapture_\(timestamp).png"
    }
}