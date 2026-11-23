# Writewell

A simple, open-source, very fast, Mac-native Markdown editor, inspired by Typora and Lettera.

You write in plain Markdown. Writewell styles it as you type and hides the syntax when your caret is elsewhere, so the page looks finished while the file on disk stays plain text.

> **Status:** pre-alpha. This repository holds the plan and the project scaffold. Nothing is usable yet.

- [PLAN.md](PLAN.md): what we're building, architecture, roadmap, performance budget
- [DECISIONS.md](DECISIONS.md): product and technical decisions, with the options considered

## Principles

1. **Fast**: launch under 300 ms, keystroke to screen under 8 ms.
2. **Native**: AppKit + TextKit 2. No Electron, no web view in the editor.
3. **Plain files**: your `.md` files, untouched. No database, no lock-in.
4. **Opinionated**: few settings, good defaults.
5. **Character**: curated type, a caret with personality, a window that is just paper.

## Building

Requires **macOS 26** and **Xcode 26** or later, plus [XcodeGen](https://github.com/yonaskolb/XcodeGen).

```sh
brew install xcodegen
xcodegen generate
open Writewell.xcodeproj
```

The core logic lives in a Swift package and can be tested on its own:

```sh
swift test --package-path Packages/WritewellKit
```

## License

[Apache 2.0](LICENSE)
