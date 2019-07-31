import Foundation

public class Version: Option<Bool> {
    public let version: String

    public init(
        _ version: String,
        name: String? = "version",
        shorthand: Character? = "v",
        documentation: String? = "Display tool version"
    ) {
        self.version = version
        super.init(initialValue: false, name: name, shorthand: shorthand, documentation: documentation)
    }

    override public func validate(
        in commands: [Command],
        outputStream: inout TextOutputStream,
        errorStream: inout TextOutputStream
    ) throws {
        if value {
            outputStream.write(version)
            outputStream.write("\n")
            exitProcess(0)
        }
    }
}
