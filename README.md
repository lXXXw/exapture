# Exapture

A precise screenshot tool for macOS that lets you capture exact dimensions with a cursor-following overlay.

## Features

- **Cursor-following overlay**: Red border box that shows exactly what will be captured
- **Precise dimensions**: Capture exactly the size you specify (default 1280×800)
- **Simple controls**: Right-click to capture, ESC to exit
- **Retina display support**: Handles high-DPI displays correctly

## Installation

```bash
# Clone and build
git clone <repository-url>
cd exapture
swift build -c release

# Install globally (optional)
cp .build/release/exapture /usr/local/bin/
```

## Usage

```bash
# Default 1280×800 capture
exapture

# Custom dimensions
exapture --width 1920 --height 1080
exapture -w 800 -h 600
```

## How it works

1. **Start**: Red overlay box appears at your cursor
2. **Move**: Box follows cursor showing capture area  
3. **Right Click**: Takes screenshot of exact area
4. **ESC**: Exits program

Screenshots are saved to your Desktop with timestamps like `exapture_2024-01-01_14-30-25.png`.

## Requirements

- macOS 11.0+
- Swift 5.9+
- **Accessibility permissions** (system will prompt on first run)

## Permissions

The app requires Accessibility permissions to:
- Monitor global mouse events
- Detect right-clicks and ESC key presses

Grant permissions in: **System Settings → Privacy & Security → Accessibility**