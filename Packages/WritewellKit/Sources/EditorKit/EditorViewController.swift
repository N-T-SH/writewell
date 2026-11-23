import AppKit
import Themes

/// The writing surface: an NSTextView on TextKit 2 (D-3).
///
/// M0 shows plain text with the house typography. M1 adds the styler and
/// block-scoped syntax hiding (D-2).
@MainActor
public final class EditorViewController: NSViewController {
    private let initialText: String
    private var textView: NSTextView!

    public var text: String { textView?.string ?? initialText }

    public init(text: String) {
        self.initialText = text
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) is not supported") }

    public override func loadView() {
        let scrollView = NSScrollView()
        scrollView.hasVerticalScroller = true
        scrollView.drawsBackground = false

        let textView = NSTextView(usingTextLayoutManager: true)
        textView.autoresizingMask = [.width]
        textView.isRichText = false
        textView.allowsUndo = true
        textView.isAutomaticQuoteSubstitutionEnabled = false
        textView.isAutomaticDashSubstitutionEnabled = false
        textView.font = HouseTheme.bodyFont
        textView.textColor = .textColor
        textView.insertionPointColor = HouseTheme.caretColor
        textView.textContainerInset = NSSize(width: 64, height: 56)
        textView.string = initialText

        scrollView.documentView = textView
        self.textView = textView
        self.view = scrollView
    }
}
