public struct Tool {
    public let name: String
    public let version: String
    public let command: Command
    public var outputStream: TextOutputStream = FileOutputStream.standardOutput
    public var errorStream: TextOutputStream = FileOutputStream.standardError

    public init(name: String, version: String, command: Command) {
        self.name = name
        self.version = version
        self.command = command
    }

    public func run() {
    }

    public func parse(arguments: [String]) {
        
    }
}
