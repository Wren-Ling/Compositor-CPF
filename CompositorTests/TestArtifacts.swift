import Foundation

/// Keeps a test's image output for someone to look at afterwards.
///
/// Swift Testing's `Attachment` records one into the result bundle, but it only exists from Swift 6.1 on:
/// on an older toolchain these are written to a folder in the temporary directory instead, which is just
/// as easy to open by hand.
enum TestArtifacts {
    /// Where the images land. Created on first use.
    static var directory: URL {
        let base = FileManager.default.temporaryDirectory.appendingPathComponent("CompositorTestArtifacts", isDirectory: true)
        try? FileManager.default.createDirectory(at: base, withIntermediateDirectories: true)
        return base
    }

    /// Writes `data` as `name`, returning the file it went to.
    @discardableResult
    static func record(_ data: Data, named name: String) -> URL? {
        let url = directory.appendingPathComponent(name)
        try? data.write(to: url)
        return url
    }
}
