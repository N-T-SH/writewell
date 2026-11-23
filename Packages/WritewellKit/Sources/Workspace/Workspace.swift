import Foundation

/// A folder opened as a workspace (D-5). Filled in during M4.
public struct Workspace: Sendable {
    public let root: URL
    public init(root: URL) { self.root = root }
}
