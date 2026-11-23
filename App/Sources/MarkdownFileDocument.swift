import AppKit
import EditorKit

/// One `.md` file. The file's text is the single source of truth (see PLAN.md §3):
/// we read bytes, edit them as text, and write the same text back.
final class MarkdownFileDocument: NSDocument {
    private var text: String = ""
    private var editor: EditorViewController?

    override class var autosavesInPlace: Bool { true }

    override func makeWindowControllers() {
        let editor = EditorViewController(text: text)
        self.editor = editor
        let window = NSWindow(contentViewController: editor)
        window.setContentSize(NSSize(width: 760, height: 880))
        window.titlebarAppearsTransparent = true
        window.styleMask.insert(.fullSizeContentView)
        addWindowController(NSWindowController(window: window))
    }

    override func data(ofType typeName: String) throws -> Data {
        Data((editor?.text ?? text).utf8)
    }

    override func read(from data: Data, ofType typeName: String) throws {
        guard let string = String(data: data, encoding: .utf8) else {
            throw CocoaError(.fileReadInapplicableStringEncoding)
        }
        text = string
    }
}
