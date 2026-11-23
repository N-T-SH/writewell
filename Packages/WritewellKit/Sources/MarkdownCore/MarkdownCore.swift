import Markdown

/// A parsed snapshot of a Markdown string.
///
/// The string is the source of truth. This type only describes it, so the
/// editor can style ranges without ever re-serializing the text.
public struct ParsedMarkdown: Sendable {
    public let source: String
    public let blockCount: Int

    public init(_ source: String) {
        self.source = source
        let document = Document(parsing: source)
        self.blockCount = document.childCount
    }
}
