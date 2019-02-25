public protocol ArgumentParser: class {
    @discardableResult
    func parse(arguments: inout [String]) throws -> Bool
}

public struct PropertyInfo: Equatable {
    public let category: String
    public let label: String
    public let documentation: String
}

public protocol CommandProperty: ArgumentParser {
    var priority: Double { get }
    var usage: String? { get }
    var info: [PropertyInfo] { get }

    func setup(withLabel label: String)
    func validate(
        in commands: [Command],
        outputStream: inout TextOutputStream,
        errorStream: inout TextOutputStream
    ) throws
}

public enum ParseError: Error, Equatable {
    case missingArgument
    case invalidFormat(String)
}
