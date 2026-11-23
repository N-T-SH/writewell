# Writewell — Decisions

The record of product and technical choices. Each section further down lists the options considered, with the original recommendation marked **★**.

## Decided (2026-11-23)

| # | Topic | Decision | Notes |
|---|---|---|---|
| D-1 | UI framework | **AppKit-first** | AppKit owns the window, split view, sidebar and editor (the hot paths). SwiftUI is used only for Settings, About and the command palette. This gives the best long-term performance headroom: no SwiftUI diffing or bridging on launch, resize, scroll or typing. |
| D-2 | Rendering | **Inline, hide syntax off the caret, block-level scope** | Marks show for the whole block that holds the caret. |
| D-3 | Text engine | **TextKit 2**, TextKit 1 as fallback | Validated by the M1 spike. |
| D-4 | Flavor | **CommonMark + GFM + extras**: math (`$…$`, `$$…$$`) with inline math editing, wiki-links `[[…]]`, highlights `==…==`, Mermaid | Wiki-links resolve by file name within the open folder. |
| D-5 | File model | **Files first, optional folder sidebar** | |
| D-6 | Parser | **swift-markdown** (cmark-gfm), with custom inline extensions for math, wiki-links and highlights | cmark-gfm has no math or wiki-link support, so those are our own inline pass. |
| D-7 | Typography | **Small curated set, user picks, sensible defaults** | Roughly 3 body fonts and 2 mono fonts, all open-licensed and bundled. No arbitrary system-font picker. |
| D-8 | Themes | **One house theme**, light + dark | |
| D-9 | Character | **(2)** curated typography, **(3)** distinctive caret and subtle motion, **(4)** writing-session stats, **(5)** zero-chrome mode | Typewriter scrolling, focus mode and sound were not picked. Clarity hints (7) were picked, then deferred with D-21 on 2026-11-23. |
| D-10 | Images | **Copy into `./assets/`** next to the file | |
| D-11 | Export | **HTML + PDF + rich text, plus Pandoc formats when Pandoc is installed** | Fine to skip in v1. |
| D-12 | Min macOS | **macOS 26 Tahoe** | Native Liquid Glass. TextKit 2 at its most mature. |
| D-13 | License | **Apache 2.0** | |
| D-14 | Distribution | **Notarized DMG + Sparkle + Homebrew cask**, free | Price not discussed; assumed free with optional sponsorship. |
| D-15 | Tooling | **XcodeGen** (`project.yml`) + SPM packages | |
| D-16 | Sync | **None of our own** | |
| D-17 | Plugins | **Deferred** | Not in v1. |
| D-18 | Settings | **Very few settings** | |
| D-19 | Repo | **`N-T-SH/writewell`, public** | |
| D-20 | Telemetry | **None** (default; not discussed) | |
| D-21 | AI | **Deferred**: no AI assistant and no local clarity helper for now | Research notes kept below for when this is picked up. |
| D-22 | Name | **Rename to a coined word; shortlist below** | "WriteWell" is already used by other writing tools. |

### Open tensions to resolve later
- **D-7 vs D-9(2):** D-9 option 2 said "no font picker in v1". D-7 chose a picker. Resolved as a *curated* picker: a few hand-picked fonts with one clear default.
- **D-12 and reach:** macOS 26 only means users on 15 or earlier can't run it. Fine for an opinionated v1. Revisit if people ask.

### AI assistant notes
Sources Nitesh pointed to:
- Zonder Labs, ["Slop"](https://zonderlabs.com/slop) (Nov 2026). Argues AI slop is mostly a *clarity* problem, not word tells like "delve" or em dashes. Names three faults, after Williams's *Style*: (1) hidden characters and actions (the actor or action buried in a noun), (2) vague wording (unclear references, stacked nouns, odd word choices), (3) empty statements and misplaced emphasis.
- Clark, Martin and Mahowald, ["Why Is AI-Generated Language So Hard to Understand?"](https://arxiv.org/abs/2610.29162). Finds that LLM text overuses forms tied to reader processing cost: dropped optional "that", long dependencies, stacked noun compounds, nouns used as verbs, inanimate subjects with agentive verbs, and rare word sequences. It also shows length penalties in training push models toward these compact forms.

What this means for Writewell:
1. **The assistant edits for clarity; it doesn't write for you.** Its main jobs are "find the actor and action", "untangle this sentence" and "what is the point of this paragraph?". It is not a "write a paragraph about X" tool.
2. **Suggestions are diffs the writer accepts, never silent rewrites.** The text stays the writer's.
3. **The model's own output must pass the same checks.** Prompt against compression: prefer explicit "that", short dependencies, verbs over nominalizations, animate subjects. Length is not a goal.
4. **(Deferred.) Clarity hints could ship first and need no AI.** A local, deterministic linter flags nominalizations, stacked nouns (3+), long subject–verb gaps and inanimate-agent verbs, using a dependency parse or heuristics. This gives most of the value with zero network and zero privacy cost, and the BYOK assistant later builds on it.

### D-22 name shortlist (2026-11-23)
Checked against App Store and web search results only (no trademark search):

| Name | Meaning | Conflicts found |
|---|---|---|
| **Fleuron** ★ | The printer's flower ornament ❦ | None found for apps |
| Inkmere | Coined: a "mere" (small lake) of ink | None found |
| Ductus | The order and direction of pen strokes in lettering | None found for apps |
| Lettrine | A drop cap, in French and in typography | Only a LaTeX package of that name |
| Proza | "Prose" in Polish and Dutch | None found for apps; a Google font is named Proza Libre |

Ruled out because apps already use them: Inklet, Margo (a Markdown editor), Quillo, Tintly, Folia, Scrivo, Inkwell, Penna, Inkora.

### D-22 name check findings (2026-11-23)
- **No Mac Markdown editor called Writewell found** in App Store or web results.
- **Other products already use the name, in writing tools:**
  - WriteWell, a web app for writing templates (writewellapp.com), on [Product Hunt](https://www.producthunt.com/products/writewell) and [G2](https://www.g2.com/sellers/writewell), including "WriteWell for Google Docs".
  - A [WriteWell Online](https://chrome.google.com/webstore/detail/writewell-online/obkdedbflcnbpillohfoghmjpekelpek) Chrome extension.
  - An iOS app, [Writewell - Calligraphy Fonts](https://apps.apple.com/us/app/id6447175365).
  - Several small GitHub repos named WriteWell, including a Chrome proofreading extension.
- **Not checked:** registered trademarks (needs a USPTO/EUIPO search) and domain ownership (the proxy here blocked lookups for writewell.app, .com, .io and .dev).
- **Assessment:** fine as a working name for an open-source project. There is a real risk of confusion or a trademark complaint if it is distributed widely, because WriteWell is an active writing-tool brand. Decide before v0.1 ships publicly. If you rename, a coined name is safer than a descriptive one.

---

# Background: options considered

## Foundations

### D-1 · UI framework
| | Option | Trade-off |
|---|---|---|
| A | Pure SwiftUI (`TextEditor`) | Fast to build, but `TextEditor` can't do hidden syntax, custom layout or real performance. Dead end for this app. |
| **★ B** | **SwiftUI shell + AppKit editor** (`NSTextView` wrapped) | SwiftUI for windows, sidebar and settings; AppKit where it matters. The common pattern for serious Mac editors. |
| C | Pure AppKit | Maximum control, more boilerplate, slower iteration on chrome. |

### D-2 · Rendering model (the biggest "character" choice)
| | Option | Feel |
|---|---|---|
| A | Split live preview (source left, HTML right) | Classic, easy, but it's every other editor. Not Typora/Lettera. |
| **★ B** | **Inline, hide syntax off the caret** (Typora-style) | `**bold**` shows as **bold**; the asterisks reappear only when the caret is inside that element. Clean page, still plain text. |
| C | Inline, syntax always visible but dimmed (iA Writer / Lettera style) | Never hides anything, no caret jumps, simpler and more honest. Less "magic". |
| D | B with a toggle to C | Best of both, but two modes to polish and test. |

Recommendation: **B**, with block-level scope (marks show for the whole block the caret is in, not only the word) to avoid jitter. C is a strong alternative if you value "no surprises" over "clean page". It's also easier to build well.

### D-3 · Text engine
| | Option | Trade-off |
|---|---|---|
| **★ A** | **TextKit 2** (`NSTextLayoutManager`) | Modern, viewport-based layout (fast on huge files), custom layout fragments for images, rules, code blocks. Some rough edges. |
| B | TextKit 1 (`NSLayoutManager`) | Proven, well documented glyph hiding. Slower on very large docs, legacy path. |
| C | Custom renderer (Core Text / Metal) | Ultimate speed and control; you'd rebuild IME, accessibility, spellcheck. Not worth it. |

Plan: A, validated by the M1 spike, with B as the fallback.

### D-4 · Markdown flavor
| | Option |
|---|---|
| A | Strict CommonMark only |
| **★ B** | **CommonMark + GFM** (tables, task lists, strikethrough, autolinks, footnotes) + YAML front matter |
| C | B + extras: math (`$…$`), Mermaid, highlights (`==x==`), wiki-links (`[[x]]`) |

Recommend B for v1, add math and Mermaid in v1.0 if you want them. Wiki-links pull toward a notes app (see D-5).

### D-6 · Parser
| | Option | Trade-off |
|---|---|---|
| **★ A** | **swift-markdown** (Apple, wraps cmark-gfm) | Spec-correct, source ranges for every node, maintained. |
| B | Raw cmark-gfm via C | Fastest, more glue code. |
| C | Own incremental parser | Best incremental behavior, a lot of work and spec risk. |

Start with A and parse per block for incremental updates. Revisit only if profiling says so.

---

## Product shape

### D-5 · File and folder model
| | Option | Feel |
|---|---|---|
| A | Single file only (TextEdit-like, one window per doc) | Simplest, very "Mac". |
| **★ B** | **Files first, optional folder sidebar** (open a folder as a workspace) | Like Typora. Covers drafts and a blog repo. |
| C | Library app (managed vault, tags, search) | Bear/Obsidian territory. A different product. |

### D-9 · The character: what makes it Writewell?
Pick 2–3 signature touches. These shape the brand more than any setting.
- **★** Typewriter scrolling + focus mode (dim all but the current paragraph)
- **★** Beautiful default typography with no font picker in v1 ("we chose for you")
- **★** A distinctive caret (soft blink, slightly thicker, accent coloured) and subtle motion
- A "writing session" stat: words written today and time in flow
- Zero-chrome mode: the window is just paper; the toolbar appears on hover
- Sound: optional soft typewriter key sounds
- Hemingway-style hints (adverbs, long sentences), off by default

### D-18 · Settings philosophy
| | Option |
|---|---|
| **★ A** | **Very few settings** (theme, font size, line width, focus/typewriter). Opinionated defaults. |
| B | Typora-level preferences |
| C | Everything configurable (JSON config) |

### D-17 · Extensibility / plugins
| | Option |
|---|---|
| **★ A** | **None in v1.** Custom CSS for export only. |
| B | User CSS themes for the editor too |
| C | JS or Lua plugin API |

Plugins are a large, long-term API commitment. Revisit after v1.

---

## Look

### D-7 · Typography
| | Option |
|---|---|
| A | System fonts only (SF Pro / New York / SF Mono) |
| **★ B** | **Bundle one open-licensed pair**, e.g. a serif for body (Literata, Source Serif 4 or iA Writer Quattro) + a mono for code (JetBrains Mono or IBM Plex Mono) |
| C | Ship several, user picks |

Also: default measure (line length). Recommend ~68 characters, centered, with generous leading (1.6).

### D-8 · Themes
| | Option |
|---|---|
| **★ A** | **One house theme**, light + dark, follows system |
| B | 3–4 curated themes (paper, night, sepia, high contrast) |
| C | User-installable CSS themes (Typora-style) |

### D-10 · Images
| | Option |
|---|---|
| **★ A** | **Paste/drop copies into `./assets/` next to the file** and inserts a relative link |
| B | Copy next to the file, same folder |
| C | Ask every time / configurable folder |

---

## Output and data

### D-11 · Export
| | Option |
|---|---|
| **★ A** | **HTML + PDF (themed) + copy as rich text** built in |
| B | A + DOCX/EPUB/LaTeX via an optional Pandoc install |
| C | A + B with Pandoc bundled (adds ~100 MB, a no-go for "small and fast") |

Recommend A in v0.3, B as a v1.x add-on.

### D-16 · Sync
| | Option |
|---|---|
| **★ A** | **None of our own.** Files live wherever you put them (iCloud Drive, Dropbox, git). NSDocument handles conflicts and versions. |
| B | Built-in iCloud container ("Writewell" folder in iCloud Drive) |
| C | Own sync service |

### D-20 · Telemetry
**★ None.** No analytics, no network calls except the update check (which you can turn off). This is a selling point.

### D-21 · AI features
| | Option |
|---|---|
| **★ A** | **Only what macOS gives for free** (Apple Writing Tools work automatically in `NSTextView`) |
| B | Bring-your-own-key assistant panel |
| C | None, actively disabled |

---

## Platform and project

### D-12 · Minimum macOS
| | Option | Trade-off |
|---|---|---|
| A | macOS 14 Sonoma | Wider reach; TextKit 2 still has more bugs here |
| **★ B** | **macOS 15 Sequoia** | Mature TextKit 2, Writing Tools, modern SwiftUI. Good reach in late 2026. |
| C | macOS 26 Tahoe | Latest design language (Liquid Glass) natively, smallest audience |

### D-13 · License
| | Option | Effect |
|---|---|---|
| **★ A** | **MIT** | Simplest and most permissive. Anyone can fork, including closed-source. |
| B | Apache 2.0 | Permissive plus a patent grant, a bit more boilerplate |
| C | GPL-3.0 | Forks must stay open. Blocks closed-source rebrands, and the App Store is awkward with GPL. |
| D | MPL-2.0 | File-level copyleft, a middle ground |

Pick C or D if you mind someone shipping a paid clone. Otherwise A.

### D-14 · Distribution
| | Option |
|---|---|
| **★ A** | **Notarized DMG on GitHub Releases + Sparkle updates + Homebrew cask** |
| B | A + Mac App Store (sandboxing makes folder access and file watching more work) |
| C | App Store only |

And price: **★ free**, with optional sponsorship (GitHub Sponsors), or free source with a paid App Store build.

### D-15 · Project tooling
| | Option |
|---|---|
| A | Plain `.xcodeproj` checked in |
| **★ B** | **XcodeGen or Tuist** (`project.yml`) with SPM packages, so there are no project-file merge conflicts and contributors get a clean setup |

### D-19 · Repo name and visibility
**★ `N-T-SH/writewell`, public from day one** (open source, build in the open). Alternative: private until v0.1, then flip public.

### D-22 · Name check
"Writewell" — check the App Store, the domain and trademark conflicts before anything ships. Want me to look?
