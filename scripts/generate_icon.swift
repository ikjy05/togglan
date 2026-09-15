import Cocoa

let sizes: [Int] = [16, 32, 128, 256, 512]
let outDir = "Togglan.iconset"

try? FileManager.default.removeItem(atPath: outDir)
try! FileManager.default.createDirectory(atPath: outDir, withIntermediateDirectories: true)

func makeIcon(size: Int) -> NSImage {
    let s = CGFloat(size)
    let image = NSImage(size: NSSize(width: s, height: s))
    image.lockFocus()

    let context = NSGraphicsContext.current!.cgContext
    let rect = CGRect(x: 0, y: 0, width: s, height: s)

    let inset = s * 0.06
    let bgRect = rect.insetBy(dx: inset, dy: inset)
    let radius = bgRect.width * 0.225

    let path = CGPath(roundedRect: bgRect, cornerWidth: radius, cornerHeight: radius, transform: nil)

    let colors = [
        NSColor(calibratedRed: 0.20, green: 0.55, blue: 0.98, alpha: 1.0).cgColor,
        NSColor(calibratedRed: 0.10, green: 0.75, blue: 0.70, alpha: 1.0).cgColor
    ]
    let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors as CFArray, locations: [0, 1])!

    context.saveGState()
    context.addPath(path)
    context.clip()
    context.drawLinearGradient(
        gradient,
        start: CGPoint(x: bgRect.minX, y: bgRect.maxY),
        end: CGPoint(x: bgRect.maxX, y: bgRect.minY),
        options: []
    )
    context.restoreGState()

    let symbolConfig = NSImage.SymbolConfiguration(pointSize: s * 0.5, weight: .semibold)
    if let symbol = NSImage(systemSymbolName: "cable.connector", accessibilityDescription: nil)?
        .withSymbolConfiguration(symbolConfig) {
        let tinted = NSImage(size: symbol.size)
        tinted.lockFocus()
        NSColor.white.set()
        let symRect = NSRect(origin: .zero, size: symbol.size)
        symbol.draw(in: symRect)
        symRect.fill(using: .sourceAtop)
        tinted.unlockFocus()

        let symSize = symbol.size
        let drawRect = NSRect(
            x: (s - symSize.width) / 2,
            y: (s - symSize.height) / 2,
            width: symSize.width,
            height: symSize.height
        )
        tinted.draw(in: drawRect)
    }

    image.unlockFocus()
    return image
}

func savePNG(_ image: NSImage, path: String, size: Int) {
    let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: size, pixelsHigh: size,
                                bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
                                colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
    rep.size = NSSize(width: size, height: size)

    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
    image.draw(in: NSRect(x: 0, y: 0, width: size, height: size))
    NSGraphicsContext.restoreGraphicsState()

    let pngData = rep.representation(using: .png, properties: [:])!
    try! pngData.write(to: URL(fileURLWithPath: path))
}

for size in sizes {
    let img1x = makeIcon(size: size)
    savePNG(img1x, path: "\(outDir)/icon_\(size)x\(size).png", size: size)

    let img2x = makeIcon(size: size * 2)
    savePNG(img2x, path: "\(outDir)/icon_\(size)x\(size)@2x.png", size: size * 2)
}

print("Iconset generated at \(outDir)")
