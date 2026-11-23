import AppKit

// AppKit-first (D-1): a plain NSApplication with a document controller.
// SwiftUI is used only for secondary windows such as Settings.
let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.regular)
app.run()
