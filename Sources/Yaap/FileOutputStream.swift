import Foundation

internal class FileOutputStream: TextOutputStream {
    private let handle: FileHandle

    internal init(handle: FileHandle) {
        self.handle = handle
    }

    internal func write(_ string: String) {
        handle.write(string.data(using: .utf8)!)
    }
}
