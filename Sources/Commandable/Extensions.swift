extension Collection where Element: Comparable {
    func compactConsecutiveSame() -> [Element] {
        var newArray: [Element] = []
        newArray.reserveCapacity(count)

        for value in self {
            if value != newArray.last {
                newArray.append(value)
            }
        }

        return newArray
    }
}

