# Exapture - Precise Screenshot Tool for Mac

**The most accurate screenshot tool for macOS** - Capture exact pixel dimensions with a real-time cursor-following overlay. Perfect for developers, designers, and anyone who needs pixel-perfect screenshots.

[![GitHub release](https://img.shields.io/github/v/release/lXXXw/exapture)](https://github.com/lXXXw/exapture/releases)
[![macOS](https://img.shields.io/badge/macOS-11.0+-blue)](https://github.com/lXXXw/exapture)
[![Swift](https://img.shields.io/badge/Swift-5.9+-orange)](https://github.com/lXXXw/exapture)
[![License](https://img.shields.io/github/license/lXXXw/exapture)](LICENSE)

## ✨ Why Choose Exapture?

Unlike other Mac screenshot tools, Exapture gives you **pixel-perfect precision** with a live preview overlay:

- 🎯 **Exact dimensions**: Set custom width/height (1280×800, 1920×1080, etc.)
- 👁️ **Live preview**: Dotted overlay shows exactly what you'll capture
- ⚡ **Lightning fast**: Right-click to capture, ESC to exit
- 🖥️ **Retina ready**: Perfect for MacBook Pro, iMac, and external displays
- 🎨 **Developer friendly**: CLI tool, perfect for automation and scripts

## 🚀 Key Features

### Screenshot Tool Features
- **Precise screenshot capture** with custom dimensions
- **Cursor-following overlay** with dotted red border
- **Pixel-perfect accuracy** for design work
- **Custom screenshot sizes** via command line
- **Instant capture** with right-click
- **Desktop auto-save** with timestamps

### macOS Integration  
- **Native macOS app** built with Swift
- **Retina display support** for high-DPI screens
- **System accessibility** integration
- **Lightweight and fast** (1.5MB binary)

## 📦 Installation Options

### Quick Install (Recommended)
```bash
# Download and install the latest release
curl -L https://github.com/lXXXw/exapture/releases/latest/download/exapture -o exapture
chmod +x exapture
sudo mv exapture /usr/local/bin/
```

### Build from Source
```bash
git clone https://github.com/lXXXw/exapture.git
cd exapture
swift build -c release
sudo cp .build/release/exapture /usr/local/bin/
```

### Homebrew (Coming Soon)
```bash
# Will be available soon
brew install exapture
```

## 🎮 Usage Examples

### Basic Screenshot Capture
```bash
# Default 1280×800 screenshot
exapture

# Common screen sizes
exapture --width 1920 --height 1080  # Full HD
exapture --width 1280 --height 720   # HD
exapture --width 800 --height 600    # Classic 4:3
exapture -w 1024 -h 768              # iPad resolution
```

### Use Cases
- **Web developers**: Capture exact browser viewport sizes
- **UI/UX designers**: Get pixel-perfect design mockups  
- **QA testers**: Document bugs with precise screenshots
- **Content creators**: Consistent social media image sizes
- **Developers**: Automate screenshot capture in scripts

## 🛠 How It Works

1. **Launch**: `exapture` command starts the tool
2. **Position**: Dotted red overlay appears at your cursor
3. **Preview**: Move mouse to see exact capture area
4. **Capture**: Right-click to take screenshot
5. **Save**: Auto-saved to Desktop with timestamp
6. **Exit**: Press ESC to quit

**File naming**: `exapture_2024-08-01_14-30-25.png`

## 📋 System Requirements

- **macOS**: 11.0 (Big Sur) or later
- **Architecture**: Apple Silicon (M1/M2/M3) or Intel
- **Permissions**: Accessibility access (auto-prompted)
- **Storage**: 2MB disk space

## 🔐 Privacy & Permissions

Exapture needs **Accessibility permissions** to:
- ✅ Monitor mouse clicks and movement
- ✅ Detect keyboard shortcuts (ESC key)
- ❌ No internet access
- ❌ No data collection
- ❌ No telemetry or analytics

**Grant permissions**: System Settings → Privacy & Security → Accessibility → Add Exapture

## 🆚 Comparison with Other Screenshot Tools

| Feature | Exapture | Lightshot | Snagit | macOS Screenshot |
|---------|----------|-----------|--------|------------------|
| Exact dimensions | ✅ | ❌ | ❌ | ❌ |
| Live preview overlay | ✅ | ❌ | ❌ | ❌ |
| CLI automation | ✅ | ❌ | ❌ | ✅ |
| Free & open source | ✅ | ✅ | ❌ | ✅ |
| Custom sizes | ✅ | ❌ | ✅ | ❌ |
| Lightweight | ✅ (1.5MB) | ❌ | ❌ | ✅ |

## 🎯 Perfect For

- **Frontend Developers** - Test responsive designs
- **UI/UX Designers** - Create consistent mockups  
- **QA Engineers** - Document visual bugs
- **Content Creators** - Social media graphics
- **Bloggers** - Consistent image sizes
- **Students** - Academic presentations
- **Anyone** who needs precise screenshots

## ❓ FAQ

**Q: How is this different from built-in macOS screenshot tools?**  
A: Exapture provides exact pixel dimensions with live preview. macOS tools capture arbitrary areas.

**Q: Can I use this in automated scripts?**  
A: Yes! It's a CLI tool perfect for automation and CI/CD pipelines.

**Q: Does it work on external monitors?**  
A: Absolutely! Full support for multiple displays and Retina screens.

**Q: Is it safe to use?**  
A: 100% open source, no network access, no data collection. You can review all code.