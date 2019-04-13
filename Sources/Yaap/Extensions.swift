import Foundation

//swiftlint:disable explicit_acl

extension Collection where Element: Comparable {
    internal func compactConsecutiveSame() -> [Element] {
        var newArray: [Element] = []
        newArray.reserveCapacity(count)

        for value in self where value != newArray.last {
            newArray.append(value)
        }

        return newArray
    }
}

extension StringProtocol {
    /// Converted from psuedocode at https://en.wikipedia.org/wiki/Levenshtein_distance
    internal func levenshteinDistance<T: StringProtocol>(to other: T) -> Int {
        guard !isEmpty else { return other.count }
        guard !other.isEmpty else { return count }

        // create two work vectors of integer distances
        // initialize v0 (the previous row of distances)
        // this row is A[0][i]: edit distance for an empty s
        // the distance is just the number of characters to delete from t
        var array0: [Int] = Array(0...other.count)
        var array1: [Int] = Array(repeating: 0, count: other.count + 1)

        for (index1, character) in enumerated() {
            // calculate v1 (current row distances) from the previous row v0

            // first element of v1 is A[i+1][0]
            //   edit distance is delete (i+1) chars from s to match empty t
            array1[0] = index1 + 1

            // use formula to fill in the rest of the row
            for (index2, otherCharacter) in other.enumerated() {
                // calculating costs for A[i+1][j+1]
                let deletionCost = array0[index2 + 1] + 1
                let insertionCost = array1[index2] + 1
                let substitutionCost = array0[index2] + (character == otherCharacter ? 0 : 1)
                array1[index2 + 1] = Swift.min(deletionCost, insertionCost, substitutionCost)
            }

            // copy v1 (current row) to v0 (previous row) for next iteration
            swap(&array0, &array1)
        }

        // after the last swap, the results of v1 are now in v0
        return array0[other.count]
    }
}
