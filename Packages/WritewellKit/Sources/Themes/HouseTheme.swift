import AppKit

/// The one house theme (D-8). Fonts become a small curated set in v0.2 (D-7).
@MainActor
public enum HouseTheme {
    public static var bodyFont: NSFont {
        // Placeholder until the bundled serif lands: New York via the system serif design.
        let base = NSFont.systemFont(ofSize: 17)
        let descriptor = base.fontDescriptor.withDesign(.serif) ?? base.fontDescriptor
        return NSFont(descriptor: descriptor, size: 17) ?? base
    }

    public static var monoFont: NSFont { .monospacedSystemFont(ofSize: 15, weight: .regular) }

    public static var caretColor: NSColor { .controlAccentColor }
}
