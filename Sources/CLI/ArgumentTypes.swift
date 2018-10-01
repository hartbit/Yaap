public protocol ArgumentType: CustomStringConvertible {
    init<I: IteratorProtocol>(arguments: inout I) throws where I.Element == String
}

extension String: ArgumentType {
    public init<I: IteratorProtocol>(arguments: inout I) throws where I.Element == String {
        guard let argument = arguments.next() else {
            throw ParseError.missingArgument
        }

        self = argument
    }
}

extension Bool: ArgumentType {
    public init<I: IteratorProtocol>(arguments: inout I) throws where I.Element == String {
        guard let argument = arguments.next() else {
            throw ParseError.missingArgument
        }

        guard let bool = Bool(argument) else {
            throw ParseError.invalidFormat(argument)
        }

        self = bool
    }
}

extension Int: ArgumentType {
    public init<I: IteratorProtocol>(arguments: inout I) throws where I.Element == String {
        guard let argument = arguments.next() else {
            throw ParseError.missingArgument
        }

        guard let int = Int(argument) else {
            throw ParseError.invalidFormat(argument)
        }

        self = int
    }
}

extension Int8: ArgumentType {
    public init<I: IteratorProtocol>(arguments: inout I) throws where I.Element == String {
        guard let argument = arguments.next() else {
            throw ParseError.missingArgument
        }

        guard let int = Int8(argument) else {
            throw ParseError.invalidFormat(argument)
        }

        self = int
    }
}

extension Int16: ArgumentType {
    public init<I: IteratorProtocol>(arguments: inout I) throws where I.Element == String {
        guard let argument = arguments.next() else {
            throw ParseError.missingArgument
        }

        guard let int = Int16(argument) else {
            throw ParseError.invalidFormat(argument)
        }

        self = int
    }
}

extension Int32: ArgumentType {
    public init<I: IteratorProtocol>(arguments: inout I) throws where I.Element == String {
        guard let argument = arguments.next() else {
            throw ParseError.missingArgument
        }

        guard let int = Int32(argument) else {
            throw ParseError.invalidFormat(argument)
        }

        self = int
    }
}

extension Int64: ArgumentType {
    public init<I: IteratorProtocol>(arguments: inout I) throws where I.Element == String {
        guard let argument = arguments.next() else {
            throw ParseError.missingArgument
        }

        guard let int = Int64(argument) else {
            throw ParseError.invalidFormat(argument)
        }

        self = int
    }
}

extension UInt: ArgumentType {
    public init<I: IteratorProtocol>(arguments: inout I) throws where I.Element == String {
        guard let argument = arguments.next() else {
            throw ParseError.missingArgument
        }

        guard let int = UInt(argument) else {
            throw ParseError.invalidFormat(argument)
        }

        self = int
    }
}

extension UInt8: ArgumentType {
    public init<I: IteratorProtocol>(arguments: inout I) throws where I.Element == String {
        guard let argument = arguments.next() else {
            throw ParseError.missingArgument
        }

        guard let int = UInt8(argument) else {
            throw ParseError.invalidFormat(argument)
        }

        self = int
    }
}

extension UInt16: ArgumentType {
    public init<I: IteratorProtocol>(arguments: inout I) throws where I.Element == String {
        guard let argument = arguments.next() else {
            throw ParseError.missingArgument
        }

        guard let int = UInt16(argument) else {
            throw ParseError.invalidFormat(argument)
        }

        self = int
    }
}

extension UInt32: ArgumentType {
    public init<I: IteratorProtocol>(arguments: inout I) throws where I.Element == String {
        guard let argument = arguments.next() else {
            throw ParseError.missingArgument
        }

        guard let int = UInt32(argument) else {
            throw ParseError.invalidFormat(argument)
        }

        self = int
    }
}

extension UInt64: ArgumentType {
    public init<I: IteratorProtocol>(arguments: inout I) throws where I.Element == String {
        guard let argument = arguments.next() else {
            throw ParseError.missingArgument
        }

        guard let int = UInt64(argument) else {
            throw ParseError.invalidFormat(argument)
        }

        self = int
    }
}

extension Float: ArgumentType {
    public init<I: IteratorProtocol>(arguments: inout I) throws where I.Element == String {
        guard let argument = arguments.next() else {
            throw ParseError.missingArgument
        }

        guard let float = Float(argument) else {
            throw ParseError.invalidFormat(argument)
        }

        self = float
    }
}

extension Double: ArgumentType {
    public init<I: IteratorProtocol>(arguments: inout I) throws where I.Element == String {
        guard let argument = arguments.next() else {
            throw ParseError.missingArgument
        }

        guard let double = Double(argument) else {
            throw ParseError.invalidFormat(argument)
        }

        self = double
    }
}

extension Array: ArgumentType where Element: ArgumentType {
    public init<I: IteratorProtocol>(arguments: inout I) throws where I.Element == String {
        self.init()

        while true {
            do {
                try append(Element.init(arguments: &arguments))
            } catch ParseError.missingArgument {
                break
            }
        }
    }
}

extension Set: ArgumentType where Element: ArgumentType {
    public init<I: IteratorProtocol>(arguments: inout I) throws where I.Element == String {
        self.init()

        while true {
            do {
                try insert(Element.init(arguments: &arguments))
            } catch ParseError.missingArgument {
                break
            }
        }
    }
}
