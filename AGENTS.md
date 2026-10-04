# Notes for AI agents

Compositor is a macOS image editor for compositing and photo work, written in Swift (SwiftUI and AppKit, with some C for pixel work).

## Designing or editing a Compositor project

If you've been asked to make or change an image in a `.comp` project, you don't need the app's source code. Read [docs/writing-comp-files.md](docs/writing-comp-files.md): it covers the file format, the rules that make a project load, and how to write it safely while it's open, so the person can watch the canvas update as you work.

## Working on the app itself

- Build: open `Compositor.xcodeproj` and run the **Compositor** scheme, or `xcodebuild -project Compositor.xcodeproj -scheme Compositor -destination 'platform=macOS' build`.
- Tests: the `CompositorTests` target (`xcodebuild ... test -only-testing:CompositorTests`). CI runs these on every push. The scheme pins the test run to English, so tests may assert on English text even on a Mac set to another language.
- The floor is macOS 15 and Xcode 16 (Swift 6.0), for both architectures. An API newer than that needs a fallback: guard it with `#available` and, when the *compiler* is too old to know the name at all, with `#if compiler(>=…)` around it (see `ToolbarGap` and `HiddenToolbarBackground` in `ContentView.swift`). Note that `nonisolated` on a *type* is Swift 6.2-only — those types are inferred `@MainActor` by `SWIFT_DEFAULT_ACTOR_ISOLATION`, so on Swift 6.0 they need `@MainActor` written out.
- Match the surrounding code: its naming, its comment style and density.
- American spelling in code, comments and UI ("color", not "colour").
- The UI is localized into Simplified Chinese through `Compositor/Localizable.xcstrings`; a new user-facing string needs a `zh-Hans` entry there. SwiftUI literals (`Text("…")`, `.help("…")`) are looked up on their own; a `String` handed to AppKit needs `String(localized:)`, and a title only known at runtime needs `String(localizedKey:)`.
- Enum raw values that are saved (`LayerBlendMode`, `AdjustmentKind` and the other `Codable` ones) stay English: they are the project format. Show them with `displayName` or `displayKey`, never `rawValue`.
- Releases are universal (Apple silicon and Intel). On an Intel Mac a Metal texture can't use shared storage; use `device.textureStorageMode`. A compute kernel that reads and writes one texture within a single dispatch only comes out right on read-write texture tier 2, which Intel's integrated GPUs lack — there the write lands on garbage. Read through a buffer and write in a second pass instead (see the two smudge kernels in `MetalWarp`); the CPU dab path is orders of magnitude too slow for a large brush.
- The project file format is described in [docs/project-format.md](docs/project-format.md). A change to what's saved means a format version bump there and in `ProjectManifest.current`.
