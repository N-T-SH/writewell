// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "WritewellKit",
    platforms: [.macOS(.v26)],
    products: [
        .library(name: "MarkdownCore", targets: ["MarkdownCore"]),
        .library(name: "EditorKit", targets: ["EditorKit"]),
        .library(name: "Workspace", targets: ["Workspace"]),
        .library(name: "Export", targets: ["Export"]),
        .library(name: "Themes", targets: ["Themes"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-markdown.git", from: "0.9.0"),
    ],
    targets: [
        // Parsing, AST and block diffing. No AppKit, so it stays fast to test.
        .target(name: "MarkdownCore", dependencies: [
            .product(name: "Markdown", package: "swift-markdown"),
        ]),
        // TextKit 2 editor, styler, syntax hiding, custom layout fragments.
        .target(name: "EditorKit", dependencies: ["MarkdownCore", "Themes"]),
        // Folders, file watching, wiki-link index.
        .target(name: "Workspace", dependencies: ["MarkdownCore"]),
        // HTML and PDF export.
        .target(name: "Export", dependencies: ["MarkdownCore", "Themes"]),
        // Theme tokens and bundled fonts.
        .target(name: "Themes"),
        .testTarget(name: "MarkdownCoreTests", dependencies: ["MarkdownCore"]),
    ]
)
