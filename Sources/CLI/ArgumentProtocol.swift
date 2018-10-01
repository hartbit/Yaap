public struct ArgumentHelp {
    public let category: String
    public let label: String
    public let description: String
}

public protocol ArgumentParser: class {
    func parse<I: IteratorProtocol>(arguments: inout I) throws where I.Element == String
}

public protocol CommandProperty: ArgumentParser {
    var priority: Double { get }
    var usage: String? { get }
    var help: [ArgumentHelp] { get }
    func setup(withLabel label: String)
}

enum ParseError: Error, Equatable {
    case missingArgument
    case invalidFormat(String)
}
