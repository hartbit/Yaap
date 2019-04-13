import Foundation

public class Version: Option<Bool> {
    public let version: String

    public init(
        version: String,
        name: String? = "version",
        shorthand: Character? = "v",
        defaultValue: Bool = false,
        documentation: String? = "Display tool version"
    ) {
        self.version = version
        super.init(name: name, shorthand: shorthand, defaultValue: defaultValue, documentation: documentation)
    }

    override public func validate(
        in commands: [Command],
        outputStream: inout TextOutputStream,
        errorStream: inout TextOutputStream
    ) throws {
        if value {
            outputStream.write(version)
            exitProcess(0)
        }
    }
}
