import Testing
@testable import MarkdownCore

@Test func parsesTopLevelBlocks() {
    let parsed = ParsedMarkdown("# Title\n\nA paragraph.\n\n- item\n")
    #expect(parsed.blockCount == 3)
}

@Test func keepsSourceByteForByte() {
    let source = "*a*  \n\n```swift\nlet x = 1\n```\n"
    #expect(ParsedMarkdown(source).source == source)
}
