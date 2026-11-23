# Writewell — Plan

> A simple, open-source, very fast, Mac-native Markdown editor. Inspired by Typora and Lettera.
> Opinionated, with a personality of its own.

Status: **v0.2** (2026-11-23). Decisions are recorded in [DECISIONS.md](DECISIONS.md); references like *(D-n)* point there.

---

## 1. What Writewell is

A writing tool, not a note database. You open a `.md` file (or a folder of them) and write. The Markdown stays plain text on disk, byte for byte. The editor makes that text look good *while you type*.

**Pillars**

1. **Fast.** Cold launch under 300 ms. Keystroke-to-glyph under 8 ms (one frame at 120 Hz). A 1 MB document opens and scrolls without stutter.
2. **Native.** AppKit and TextKit 2, so you get system spellcheck, dictation, Writing Tools, services, the Find bar, accessibility, VoiceOver, IME input and Handoff for free.
3. **Plain files.** No database, no proprietary format, no lock-in.
4. **Opinionated.** Few settings, good defaults, one house theme *(D-8, D-18)*.
5. **Character** *(D-9)*:
   - curated typography with a clear default
   - a distinctive caret and subtle motion
   - a zero-chrome window that is just paper
   - writing-session stats
   - optional clarity hints

**Non-goals for v1:** collaboration, plugins *(D-17)*, iOS, built-in sync *(D-16)*, a backlinks or graph view, a WYSIWYG table editor, an AI assistant (after v1, *D-21*), Pandoc export (after v1, *D-11*).

## 2. Who it is for

People who write prose in Markdown, such as blog posts, essays, docs and drafts. They want Typora's "the formatting disappears into the text" feel in a lighter, truly native, open-source app.

## 3. Architecture (D-1, D-2, D-3, D-6, D-12)

Target: **macOS 26 Tahoe and later**, Swift 6, Apple silicon and Intel.

```
┌──────────────────────────── Writewell.app ─────────────────────────────┐
│ AppKit shell: NSWindow, NSSplitView, sidebar (NSOutlineView), menus   │
│ SwiftUI only for Settings, About and the command palette              │
│                                                                        │
│  ┌──────────── EditorViewController (AppKit) ─────────────────┐        │
│  │ NSTextView on TextKit 2                                    │        │
│  │  • NSTextContentStorage  ← the Markdown text itself         │        │
│  │  • Styler: AST → attributes (fonts, colours, hidden marks) │        │
│  │  • Custom NSTextLayoutFragments: images, rules, code, math │        │
│  └───────────────▲────────────────────────────────────────────┘        │
│                  │ incremental re-parse of edited blocks              │
│  ┌───────────────┴────────────┐   ┌───────────────────────────┐        │
│  │ MarkdownCore (Swift pkg)    │   │ Workspace (Swift pkg)     │        │
│  │ swift-markdown + own inline │   │ NSDocument, FSEvents,     │        │
│  │ ext: math, [[wiki]], ==hl== │   │ folder tree, wiki-link idx│        │
│  └────────────────────────────┘   └───────────────────────────┘        │
│  ┌────────────────────────────┐   ┌───────────────────────────┐        │
│  │ Export (HTML, PDF)          │   │ Themes (tokens + fonts)   │        │
│  └────────────────────────────┘   └───────────────────────────┘        │
└────────────────────────────────────────────────────────────────────────┘
```

**Why AppKit-first (D-1).** The editor, window, split view and sidebar are where performance is felt: launch, resize, scroll and typing. Keeping them in AppKit avoids SwiftUI diffing and bridging on those paths and gives direct control over layout and drawing. SwiftUI is used only where it is cheap and pleasant: settings, the About window and the palette.

**The text storage *is* the Markdown.** We never convert into a rich-text model and back. Rendering is pure styling: attributes on ranges, plus hiding syntax characters when the caret is outside their block (D-2). That keeps saves lossless, undo native and typing fast.

**Incremental parsing.** On each edit, find the dirty block range, re-parse only that, and restyle only those ranges. A full re-parse runs in the background for structural changes, such as opening a code fence or a `$$` math block.

**Markdown extensions (D-4, D-6).** swift-markdown handles CommonMark and GFM. A small inline pass of our own adds:
- `$inline$` and `$$display$$` math. It shows as rendered math off-caret and as editable source on-caret, so you edit the math inline.
- `[[wiki-links]]` and `[[target|label]]`, resolved by file name within the open folder (D-5). ⌘-click follows the link, and a missing target offers to create the file.
- `==highlights==`.
- Mermaid fenced blocks (` ```mermaid `), rendered off-caret.

**Math and Mermaid rendering.** Render to an image off the main thread and cache by source hash. Candidates: a native TeX layout engine (e.g. SwiftMath) for speed, or KaTeX/Mermaid in a hidden, shared WKWebView used only for rasterizing. Decide in M1.

**Modules (Swift Package Manager)**

| Package | Responsibility |
|---|---|
| `MarkdownCore` | Parsing, AST, block diffing, extensions. Pure Swift, no AppKit, unit-tested. |
| `EditorKit` | TextKit 2 view, styler, syntax hiding, custom fragments, caret, input rules (auto-pair, list continuation). |
| `Workspace` | Documents, folders, FSEvents watching, autosave, wiki-link index. |
| `Export` | Markdown → HTML (shared with themes), PDF via WebKit print. |
| `Themes` | Theme tokens (light and dark), bundled open-licensed fonts. |
| `App` | AppKit app delegate, windows, menus; SwiftUI settings. |

## 4. Feature scope

### v0.1 — "It writes" (MVP)
- Open, edit and save a single `.md` file (NSDocument: autosave, versions, revert).
- Inline live styling: headings, bold, italic, code, links, quotes, lists, task lists, rules, highlights.
- Syntax marks hide when the caret leaves the block.
- Fenced code blocks in monospace with a background.
- House theme, light and dark, with default fonts.
- The Writewell caret: soft blink, accent colour, eased movement.
- Word, character and reading-time count.
- Shortcuts: ⌘B, ⌘I, ⌘K link, ⌘1–6 headings.
- Performance budget enforced in CI (see §6).

### v0.2 — "It feels good"
- Zero-chrome mode: the window is just paper, and the toolbar and sidebar appear on hover or a shortcut.
- Writing-session stats: words written today and time spent writing, kept locally.
- Inline images with paste/drop into `./assets/` (D-10).
- Inline math editing (`$…$`, `$$…$$`).
- Code syntax highlighting.
- Tables rendered as aligned grids (edited as text).
- Outline sidebar and command palette (⌘⇧P).
- Curated font picker in Settings (D-7).

### v0.3 — "It holds a body of work"
- Folder mode: file tree, quick open (⌘P), new file in folder.
- `[[Wiki-links]]` with autocomplete, follow-link, create-on-missing, and renames that update links.
- Search across the folder.
- Export: HTML, PDF, print and copy as rich text, all using the theme.
- YAML front matter shown as a collapsible header.

### v1.0 — "Ship it"
- Mermaid diagrams.
- Clarity hints (D-9(7)), off by default. A local, deterministic linter that needs no AI flags nominalizations, stacked nouns, long subject–verb gaps and vague references. See the AI assistant notes in DECISIONS.md.
- Sparkle auto-update, notarized DMG, Homebrew cask (D-14).
- Full accessibility pass, localization scaffolding.

### After v1
- Pandoc export (DOCX, EPUB, LaTeX) when Pandoc is installed (D-11).
- Bring-your-own-key AI assistant focused on clarity edits, shown as diffs (D-21).
- Plugin or extension story (D-17).

## 5. Milestones (rough)

| Milestone | Contents | Size |
|---|---|---|
| M0 Scaffold | XcodeGen project, SPM packages, CI, README, LICENSE | done with this commit |
| M1 Spike | TextKit 2 editor with styling, block-scoped syntax hiding and one math fragment on a 1 MB file; measure latency | 1 week |
| M2 v0.1 | MVP list above | 2–3 weeks |
| M3 v0.2 | Feel features | 2–3 weeks |
| M4 v0.3 | Folders, wiki-links, search, export | 3 weeks |
| M5 v1.0 | Mermaid, clarity hints, polish, distribution | 3–4 weeks |

**M1 is the key risk-reduction step.** TextKit 2 has sharp edges: custom fragments, scroll height estimates, and selection across hidden glyphs. If the spike shows problems, fall back to TextKit 1 glyph hiding.

## 6. Performance budget (enforced)

| Metric | Budget | How measured |
|---|---|---|
| Cold launch to editable window | < 300 ms (Apple silicon) | XCTest launch metric |
| Keystroke to display | < 8 ms p95 | signposts around edit → display |
| Open 1 MB `.md` | < 150 ms to first paint | XCTest perf test |
| Memory, 1 MB doc | < 80 MB | Instruments, nightly |
| App bundle | < 15 MB | CI check |

No Electron. No WebView in the editing path; one is allowed only to rasterize math and diagrams, and for export.

## 7. Repository layout

```
writewell/
├── README.md  PLAN.md  DECISIONS.md  LICENSE (Apache-2.0)
├── project.yml                 XcodeGen spec → Writewell.xcodeproj (git-ignored)
├── App/                        AppKit app target (+ SwiftUI settings)
├── Packages/WritewellKit/      one local SPM package, one library per module:
│   └── Sources/{MarkdownCore,EditorKit,Workspace,Export,Themes}
├── Tests/Fixtures/             sample .md files incl. a stress doc
└── .github/workflows/ci.yml    macOS runner: generate, build, test
```

## 8. Risks

| Risk | Mitigation |
|---|---|
| TextKit 2 bugs with hidden syntax and custom fragments | M1 spike first, TextKit 1 fallback |
| Caret jumps when marks hide or show | Block-level scope; never shift text under the caret |
| Math rendering cost while typing | Render off the main thread, cache by hash, show source while editing |
| Wiki-links pull toward a "notes app" | No backlinks or graph view in v1; links are just navigation |
| macOS 26-only limits reach | Accepted for v1 (D-12) |
| Name conflict with the existing WriteWell brand | Decide on the name before the public v0.1 (D-22) |

## 9. Next steps

1. Start the M1 TextKit 2 spike.
2. Decide whether to keep the name before the first public build.
