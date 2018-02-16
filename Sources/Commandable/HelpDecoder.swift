class HelpDecoder: Decoder {
    let codingPath: [CodingKey] = []
    let userInfo: [CodingUserInfoKey: Any] = [:]

    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> {
        return KeyedDecodingContainer(HelpKeyedDecodingContainer(decoder: self))
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        throw CommandableError.invalidCommand("single value containers are not supported")
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        throw CommandableError.invalidCommand("unkeyed containers are not supported")
    }
}

class HelpKeyedDecodingContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
    var allKeys: [Key] = []
    var codingPath: [CodingKey] = []
    private let decoder: HelpDecoder

    init(decoder: HelpDecoder) {
        self.decoder = decoder
    }

    func contains(_ key: Key) -> Bool {
        return false
    }

    func decodeNil(forKey: Key) throws -> Bool {
        throw CommandableError.invalidCommand("decoding nil is not supported")
    }

    func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
        return false
    }

    func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        return 0
    }

    func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
        return 0
    }

    func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
        return 0
    }

    func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
        return 0
    }

    func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
        return 0
    }

    func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
        return 0
    }

    func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
        return 0
    }

    func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
        return 0
    }

    func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
        return 0
    }

    func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
        return 0
    }

    func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
        return 0
    }

    func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        return 0
    }

    func decode(_ type: String.Type, forKey key: Key) throws -> String {
        return ""
    }

    func decode<T: Decodable>(_ type: T.Type, forKey key: Key) throws -> T {
        fatalError()
    }

    func nestedContainer<NestedKey: CodingKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> {
        fatalError()
    }

    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        fatalError()
    }

    func superDecoder() throws -> Decoder {
        fatalError()
    }

    func superDecoder(forKey key: Key) throws -> Decoder {
        fatalError()
    }
}
