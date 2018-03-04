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

func assertEqual<S1: StringProtocol, S2: StringProtocol>(
    _ value: S1,
    _ expected: S2,
    file: StaticString = #file,
    line: UInt = #line
) {
    if let indexOfFirstDifference = value.indexOfFirstDifference(with: expected) {
        XCTFail(value.diffString(at: indexOfFirstDifference, other: expected), file: file, line: line)
    }
}

private extension StringProtocol {
    func indexOfFirstDifference<S: StringProtocol>(with other: S) -> Self.Index? {
        var selfIndex = startIndex
        var otherIndex = other.startIndex
        while selfIndex != self.endIndex && otherIndex != other.endIndex {
            if self[selfIndex] != other[otherIndex] {
                return selfIndex
            } else {
                selfIndex = index(after: selfIndex)
                otherIndex = other.index(after: otherIndex)
            }
        }

        if count != other.count {
            return index(before: selfIndex)
        } else {
            return nil
        }
    }

    func diffString<S: StringProtocol>(at index: Self.Index, other: S) -> String {
        var windowStartIndex = index
        for _ in 0..<windowReach {
            let before = self.index(before: index)
            guard self[before] != "\n" else { break }
            windowStartIndex = before
            guard before != startIndex else { break }
        }

        let distance = self.distance(from: startIndex, to: windowStartIndex)
        let selfSubstring = windowSubstring(offsetBy: distance)
        let otherSubstring = other.windowSubstring(offsetBy: distance)

        let markerPosition = Swift.min(windowReach, distance) + (distance > windowReach ? 1 : 0)
        let markerPrefix = String(repeating: " ", count: markerPosition)
        let markerLine = "\(markerPrefix)\(markerArrow)"

        return """
            Difference at index \(distance):
            \(selfSubstring)
            \(otherSubstring)
            \(markerLine)
            """
    }

    /// Given a string and a range, return a string representing that substring.
    ///
    /// If the range starts at a position other than 0, an ellipsis
    /// will be included at the beginning.
    ///
    /// If the range ends before the actual end of the string,
    /// an ellipsis is added at the end.
    func windowSubstring(offsetBy distance: Int) -> String {
        let lowerBound = index(startIndex, offsetBy: Swift.max(distance - windowReach, 0))
        let upperBound = index(startIndex, offsetBy: distance + windowReach, limitedBy: endIndex) ?? endIndex
        let prefix = lowerBound != startIndex ? ellipsis : ""
        let suffix = upperBound != endIndex ? ellipsis : ""
        return "\(prefix)\(self[lowerBound..<upperBound])\(suffix)"
    }
}

private let windowReach = 10
private let windowLength = 2 * windowReach + 1
private let markerArrow = "\u{2b06}"  // "⬆"
private let ellipsis = "\u{2026}"  // "…"
