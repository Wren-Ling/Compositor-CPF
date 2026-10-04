import Foundation
import SwiftUI

/// A display name for a value whose stored spelling has to stay put.
///
/// Most of the enums in `Document/` are `Codable` with a `String` raw value, and that raw value is
/// written into `manifest.json`: it is the project file's format, the same spelling
/// `docs/writing-comp-files.md` promises anyone authoring a `.comp`. Translating it would break every
/// saved project, so the raw value stays English and the translation sits beside it instead — the raw
/// value goes to disk, `displayName` goes to the screen.
///
/// The catalog is keyed by the raw value ("Multiply", "Gaussian Blur"), so one entry serves both a
/// hand-written `Text("Multiply")` and a `Text(mode.displayKey)` built at runtime.
protocol LocalizedDisplayName {
    /// The name to draw, looked up in the string catalog under the raw value.
    var displayName: String { get }

    /// The same name as a `LocalizedStringKey`, for SwiftUI views that localize their own text.
    var displayKey: LocalizedStringKey { get }
}

extension LocalizedDisplayName where Self: RawRepresentable, Self.RawValue == String {
    var displayName: String { String(localizedKey: rawValue) }
    var displayKey: LocalizedStringKey { LocalizedStringKey(rawValue) }
}

extension String {
    /// Looks up a key that is only known at runtime, such as a title handed to a shared slider helper.
    /// A key missing from the catalog comes back unchanged.
    init(localizedKey key: String) {
        self.init(localized: String.LocalizationValue(key))
    }
}

// Display-only enums whose raw values are drawn as picker and menu labels.
extension CameraRawUprightMode: LocalizedDisplayName {}
extension CameraRawProjection: LocalizedDisplayName {}
extension CameraRawProcessVersion: LocalizedDisplayName {}
extension CameraRawCurvePage: LocalizedDisplayName {}
extension CameraRawPointChannel: LocalizedDisplayName {}
extension CameraRawMixerPage: LocalizedDisplayName {}
extension CameraRawMixerTab: LocalizedDisplayName {}
extension CameraRawGradePage: LocalizedDisplayName {}
extension CameraRawWhiteBalance: LocalizedDisplayName {}
extension CameraRawGlowStyle: LocalizedDisplayName {}
extension CameraRawVignetteStyle: LocalizedDisplayName {}
extension LevelsSample: LocalizedDisplayName {}
extension LevelsAuto: LocalizedDisplayName {}
extension HueSampleMode: LocalizedDisplayName {}
// Saved to UserDefaults under their raw values, so these keep English raw values too.
extension GridAppearance.Preset: LocalizedDisplayName {}
extension GridAppearance.Style: LocalizedDisplayName {}
