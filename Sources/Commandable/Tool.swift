public struct Tool {
    let name: String
    let version: String
    let command: Command

    init(name: String, version: String, command: Command) {
        self.name = name
        self.version = version
        self.command = command
    }
}
