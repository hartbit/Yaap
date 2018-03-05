import Foundation
import XCTest
import Commandable

extension ArgumentHelp: Equatable {
    public static func == (lhs: ArgumentHelp, rhs: ArgumentHelp) -> Bool {
        return lhs.category == rhs.category &&
            lhs.label == rhs.label &&
            lhs.description == rhs.description
    }
}

struct DocumentationCommand: Command {
    let documentation: String

    init(documentation: String) {
        self.documentation = documentation
    }

    func run() throws {}
}
